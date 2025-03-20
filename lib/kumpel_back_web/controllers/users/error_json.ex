defmodule KumpelBackWeb.Users.ErrorJSON do
  @moduledoc """
    Contains all error view functions for the users_controller
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
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  # GET
  def error(%{status: :not_found}) do
    %{
      status: :not_found,
      message: "User not found"
    }
  end

  # login
  def error(%{status: :unauthorized}) do
    %{
      status: :unauthorized,
      message: "Unable to login"
    }
  end

  # Create
  def error(%{changeset: changeset}) do
    %{
      errors: Ecto.Changeset.traverse_errors(changeset, &translate_errors/1)
    }
  end

  defp translate_errors({msg, opts}) do
    Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
      opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
    end)
  end
end
