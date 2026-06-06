defmodule KumpelBackWeb.Messages.MessagesController do
  @moduledoc """
  Serves paginated message history for a room.
  """

  use KumpelBackWeb, :controller

  alias KumpelBack.Messages
  alias KumpelBack.Rooms

  action_fallback KumpelBackWeb.Messages.FallbackController

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, %{"room_id" => room_id} = params) do
    with {:ok, _room} <- Rooms.get(room_id),
         {:ok, before_dt} <- parse_before(params["before"]),
         limit = parse_limit(params["limit"]),
         {:ok, messages, has_more} <- Messages.list_by_room(room_id, before: before_dt, limit: limit) do
      conn
      |> put_status(:ok)
      |> render(:index, messages: messages, has_more: has_more)
    end
  end

  defp parse_before(nil), do: {:ok, nil}

  defp parse_before(value) when is_binary(value) do
    case DateTime.from_iso8601(value) do
      {:ok, dt, _} -> {:ok, dt}
      _ -> {:error, :invalid_cursor}
    end
  end

  defp parse_limit(nil), do: 50

  defp parse_limit(value) when is_binary(value) do
    case Integer.parse(value) do
      {n, ""} when n > 0 -> n
      _ -> 50
    end
  end
end
