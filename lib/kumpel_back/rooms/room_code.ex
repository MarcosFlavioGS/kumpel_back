defmodule KumpelBack.Rooms.RoomCode do
  @moduledoc false

  @length 10

  @doc """
  Generates a new room access code: #{@length} uppercase Base32 characters (~50 bits of entropy).
  """
  @spec generate() :: String.t()
  def generate do
    :crypto.strong_rand_bytes(8)
    |> Base.encode32(padding: false)
    |> String.slice(0, @length)
    |> String.upcase()
  end
end
