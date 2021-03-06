class AssmatsController < ApplicationController
  PREFIX = 'https://assmat.loire-atlantique.fr/'.freeze

  def index
    @assmats = Assmat.all.order(:distance)
    @user = current_user
    @markers = make_markers

    @user_inputs = {}
    Assmat.joins(:user_inputs).each do |assmat|
      ui = UserInput.find_by(user: @user, assmat: assmat)
      @user_inputs[assmat] = ui
    end
  end

  def patch_comment

  end

  def refresh
    Availability.delete_all
    Assmat.delete_all
    import_from_web

    pp @assmats

    redirect_to assmats_path
  end

  private

  def make_markers
    # the `geocoded` scope filters only flats with coordinates (latitude & longitude)
    @assmats.geocoded.map do |assmat|
      {
        lat: assmat.latitude,
        lng: assmat.longitude,
        infoWindow: render_to_string(partial: "shared/info_window", locals: { assmat: assmat })
      }
    end
  end

  def import_from_web
    page = 0
    loop do
      attributes = { start: page * 10 }
      call(attributes)
      # There is no information about being on the last page or not.
      # If we go loop until page 1000, the server will keep serving the last X results for each page we request
      break if @assmat.name != Assmat.last.name # not very safe if the last page has exactly 10 results
      break if page >= 16 # guard clause
      page += 1
    end
  end

  def call(attributes = { start: 0 })
    @url = "https://assmat.loire-atlantique.fr/jcms/parents/faire-une-recherche-d-assistante-maternelle-fr-r1_58176?idCommune=rp1_62646&codeInsee=44109&cities=44036&longitude=-1.56512&latitude=47.219901&cityName=Nantes&adresse=#{ENV['ADDRESS_TO_SEARCH']}&distance=3000&month=1617200000000&age=1%7C17%7C2%7C3%7C10%7C15%7C16%7C19&branchesId=cra_67000&branchesId=cra_67001&branchesId=&nomassmat=&isSearch=Ok&hashKey=88&withDispo=true&withDispoFuture=true&withNonDispo=false&withDispoNonRenseigne=false&start=#{attributes[:start]}"

    html_file = URI.parse(@url).open.read
    html_doc  = Nokogiri::HTML(html_file)

    html_doc.search('.amcontainer').each do |amcontainer|
      data1   = amcontainer.search('.row-fluid')[0]
      data2   = amcontainer.search('.row-fluid')[1]

      @assmat = Assmat.new
      parse_data1(data1)
      break if Assmat.select(:name).map(&:name).include?(@assmat.name)

      parse_data2(data2)
      @assmat.save!
      parse_subpage(@assmat.url)
      # binding.pry
      pp Assmat.select(:name).map(&:name), (@assmat.name)

      pp @assmat
    end
    @assmat
  end

  def parse_data1(data1)
    @assmat.name        = data1.at_css('h2').text.strip
    @assmat.last_update = data1.at_css('p').text.strip[-10..-1]
    quartier            = data1.at_css('.quartier')
    @assmat.area        = quartier ? quartier.text.strip[11..-1].split(' ').join(' ') : 'quartier inconnu'
    @assmat.distance    = data1.text.strip.match(/?? (?<dist>.{1,4}) km/)[:dist].gsub(',', '.').to_f
  end

  def parse_data2(data2)
    regexp2         = /((?<address>.*) (T??l fixe : (?<phone>(\d)+)) T??l portable: (?<cell>.*) Courriel (?<available>.*) En savoir plus|(?<address>.+) T??l portable: (?<cell>.+) Courriel (?<available>.*) En savoir plus)/
    data2_text      = data2.text.split.join(' ')
    contact_details = data2_text.match(regexp2) || {} # empty hash if nil
    @assmat.address = contact_details[:address] || ''
    @assmat.phone   = contact_details[:phone] || 'NC'
    @assmat.cell    = contact_details[:cell] || 'NC'
    @assmat.general_availability = contact_details[:available] || 'NC'
    # pp @assmat

    @assmat.url = "#{PREFIX}#{data2.search('.wysiwyg a').attribute('href').value}"
  end

  def parse_subpage(url)
    html_file = URI.parse(url).open.read

    li = Nokogiri::HTML(html_file).css('.listeDispos li')
    li.each_with_index do |dispo, index|
      next unless (index % 3).zero? # after each li with data, there are 2 lis with nothing interesting

      # get availability details
      cr_dispo        = dispo.at_css('p.crDispos') ? dispo.at_css('p.crDispos').text.strip : 'NC'
      precision_dispo = if dispo.at_css('div.precisionDispo p')
                          dispo.at_css('div.precisionDispo p').text.strip.gsub(',', '-')
                        else
                          'Pas de pr??cision'
                        end
      # get the full calendar, which is a big table of avail/not available timeslots.
      creneau_dispo = '|'
      dispo.search('tr td img').each_with_index do |creneau, index_creneau|
        if index_creneau.even? # I can't make the search precise enough so I have to eliminate some cr*ppy tag
          creneau_dispo << (creneau['class'] == 'creneauNonDispo' ? '-' : 'X')
        end
        creneau_dispo << '|' if (creneau_dispo.size % 8).zero?
      end

      availability = Availability.new(
        assmat: @assmat,
        description: cr_dispo,
        details: precision_dispo,
        calendar: creneau_dispo,
      )
      availability.save!
    end
  end
end
