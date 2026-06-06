defmodule KumpelBackWeb.Messages.ErrorJSON do
  @moduledoc false

  @spec render(String.t(), map()) :: map()
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  @spec error(map()) :: map()
  def error(%{status: :not_found}) do
    %{status: :not_found, message: "Room not found"}
  end

  def error(%{status: :invalid_cursor}) do
    %{status: :bad_request, message: "Invalid cursor value for 'before' parameter"}
  end
end
