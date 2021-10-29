# frozen_string_literal: true

# Controller for Users Views
class UsersController < ActionController::Base
  def activate
    response = Operations::Users::Activate.call(form_options_for_activate)
    @activated = response[:activated]
  end

  private

  def form_options_for_activate
    {
      token: params[:token]
    }
  end
end
