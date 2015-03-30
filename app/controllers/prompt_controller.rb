class PromptController < ApplicationController

  #
  #  build a hash with all the prompt and current values
  #
  def show
    @prompts = Hash.new
    current_user.prompt_fields.each do |key|
      if current_user.prompt_values
        @prompts[key] = current_user.prompt_values[key]
      else
        @prompts[key] = ""
      end
    end
  end

  #
  #  take the prompts entered by the user and same them in the session data
  #  unless the user did a cancel
  #
  def create
    if params[:commit] == "Cancel"
      redirect_to current_user.prompt_cancel
    else
      current_user.prompt_values = params[:prompts]
      current_user.save
      redirect_to current_user.prompt_ok
    end
  end

end
