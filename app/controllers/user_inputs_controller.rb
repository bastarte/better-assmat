class UserInputsController < ApplicationController
  def create
    @assmat = Assmat.find(params[:assmat])
    @user = current_user

    UserInput.create!(assmat: @assmat, user: @user, comment: "", selected: false)

    redirect_to assmats_path

  end

  def update
    @user_input = UserInput.find(params[:id])
    @user_input.update(user_input_params)

    redirect_to assmats_path
  end

  private

  def user_input_params
    params.require(:user_input).permit(:comment, :selected)
  end

  def user_input_assmat_params
    params.require(:assmat).permit(:id)
  end
end
