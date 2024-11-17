defmodule KumpelBack.Rooms do
  @moduledoc """
    Module responsable for facades to functions
  """
  alias KumpelBack.Rooms.Create
  alias KumpelBack.Rooms.Get

  defdelegate create(params), to: Create, as: :call
  defdelegate get(params), to: Get, as: :call
end
