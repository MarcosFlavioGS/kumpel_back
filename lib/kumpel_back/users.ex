defmodule KumpelBack.Users do
  @moduledoc """
    Module responsable for facades to functions
  """
  alias KumpelBack.Users.Create

  defdelegate create(params), to: Create, as: :call
end
