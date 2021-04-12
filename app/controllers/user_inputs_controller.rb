class UserInputsController < ApplicationController
  def create
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
end
