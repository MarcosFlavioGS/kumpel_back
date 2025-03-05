defmodule KumpelBack.Users do
  @moduledoc """
    Module responsable for facades to functions
  """
  alias KumpelBack.Users.Create
  alias KumpelBack.Users.Get
  alias KumpelBack.Users.Delete
  alias KumpelBack.Users.Update

  defdelegate create(params), to: Create, as: :call
  defdelegate get(id), to: Get, as: :call
  defdelegate delete(id), to: Delete, as: :call
  defdelegate update(params), to: Update, as: :call
end
