defmodule KumpelBackWeb.Auth.ErrorJSON do
  @moduledoc """
    Contains all error view functions for the auth_controller
  """
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  @spec render(String.t(), map()) :: map()
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  # User not found
  @spec error(map()) :: map()
  def error(%{status: :not_found}) do
    %{
      status: :not_found,
      message: "User not found"
    }
  end

  # login (no custom message)
  def error(%{status: :bad_request, message: message}) do
    %{
      status: :bad_request,
      message: message
    }
  end

  # refresh invalid token, etc. (must be before %{status: :unauthorized} alone)
  def error(%{status: :unauthorized, message: message}) do
    %{
      status: :unauthorized,
      message: message
    }
  end

  def error(%{status: :unauthorized}) do
    %{
      status: :unauthorized,
      message: "Unable to login"
    }
  end

  def error(%{message: message}) do
    %{
      status: :unauthorized,
      message: message
    }
  end
end
