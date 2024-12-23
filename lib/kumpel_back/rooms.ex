defmodule KumpelBack.Rooms do
  @moduledoc """
    Module responsable for facades to functions
  """
  alias KumpelBack.Rooms.Create
  alias KumpelBack.Rooms.Get
  alias KumpelBack.Rooms.List

  defdelegate create(params), to: Create, as: :call
  defdelegate get(params), to: Get, as: :call
  defdelegate list(), to: List, as: :call
end
