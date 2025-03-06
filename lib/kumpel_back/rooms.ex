defmodule KumpelBack.Rooms do
  @moduledoc """
    Module responsable for facades to functions
  """
  alias KumpelBack.Rooms.Create
  alias KumpelBack.Rooms.Update
  alias KumpelBack.Rooms.Get
  alias KumpelBack.Rooms.List
  alias KumpelBack.Rooms.Delete

  defdelegate create(params), to: Create, as: :call
  defdelegate update(params), to: Update, as: :call
  defdelegate get(id), to: Get, as: :call
  defdelegate list(), to: List, as: :call
  defdelegate delete(id), to: Delete, as: :call
end
