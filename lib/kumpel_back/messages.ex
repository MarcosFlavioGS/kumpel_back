defmodule KumpelBack.Messages do
  @moduledoc """
  Facade for chat message operations.
  """

  alias KumpelBack.Messages.Create
  alias KumpelBack.Messages.ListByRoom
  alias KumpelBack.Messages.Message

  @spec create(map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  defdelegate create(params), to: Create, as: :call

  @spec list_by_room(String.t(), keyword()) :: {:ok, [Message.t()], boolean()}
  defdelegate list_by_room(room_id, opts \\ []), to: ListByRoom, as: :call
end
