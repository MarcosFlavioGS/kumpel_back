defmodule KumpelBack.Rooms do
  @moduledoc """
    Module responsable for facades to functions
  """
  alias KumpelBack.Rooms.Create

  defdelegate create(params), to: Create, as: :call
end
