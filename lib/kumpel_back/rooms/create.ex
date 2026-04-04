defmodule KumpelBack.Rooms.Create do
  @moduledoc false

  alias KumpelBack.Repo
  alias KumpelBack.Rooms.Room
  alias KumpelBack.Rooms.RoomCode

  @max_code_attempts 8

  @spec call(map(), String.t()) ::
          {:ok, Room.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, :room_code_allocation_failed}
  def call(params, user_id) do
    base =
      params
      |> drop_client_code()
      |> Map.put("adm_id", user_id)

    insert_with_unique_code(base, @max_code_attempts)
  end

  defp drop_client_code(params) when is_map(params) do
    params
    |> Map.delete("code")
    |> Map.delete(:code)
  end

  defp insert_with_unique_code(_base, 0), do: {:error, :room_code_allocation_failed}

  defp insert_with_unique_code(base, attempts_left) do
    attrs = Map.put(base, "code", RoomCode.generate())

    case attrs |> Room.changeset() |> Repo.insert() do
      {:ok, room} ->
        {:ok, Repo.preload(room, [:subscribers])}

      {:error, %Ecto.Changeset{} = cs} ->
        if code_unique_violation?(cs) do
          insert_with_unique_code(base, attempts_left - 1)
        else
          {:error, cs}
        end
    end
  end

  defp code_unique_violation?(%Ecto.Changeset{errors: errors}) do
    case errors[:code] do
      {_msg, opts} when is_list(opts) -> Keyword.get(opts, :constraint) == :unique
      _ -> false
    end
  end
end
