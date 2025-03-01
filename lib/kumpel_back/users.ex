defmodule KumpelBack.Users do
  @moduledoc """
    Module responsable for facades to functions
  """
  alias KumpelBack.Users.Create
  alias KumpelBack.Users.Get

  defdelegate create(params), to: Create, as: :call
  defdelegate get(id), to: Get, as: :call
end
