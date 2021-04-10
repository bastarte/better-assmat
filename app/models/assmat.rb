class Assmat < ApplicationRecord
  has_many :availabilities, dependent: :destroy
  has_many :user_inputs, dependent: :destroy

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
