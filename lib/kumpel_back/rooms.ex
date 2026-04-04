defmodule KumpelBack.Rooms do
  @moduledoc """
    Module responsable for facades to functions
  """
  alias KumpelBack.Rooms.Create
  alias KumpelBack.Rooms.Update
  alias KumpelBack.Rooms.Get
  alias KumpelBack.Rooms.List
  alias KumpelBack.Rooms.Delete
  alias KumpelBack.Rooms.Room

  @spec create(map(), String.t()) ::
          {:ok, Room.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, :room_code_allocation_failed}
  defdelegate create(params, user_id), to: Create, as: :call

  @spec update(map()) ::
          {:ok, Room.t()} | {:error, :not_found} | {:error, Ecto.Changeset.t()}
  defdelegate update(params), to: Update, as: :call

  @spec get(String.t()) :: {:ok, Room.t()} | {:error, :not_found}
  defdelegate get(id), to: Get, as: :call

  @spec list() :: {:ok, [Room.t()]} | {:error, :not_found}
  defdelegate list(), to: List, as: :call

  @spec delete(String.t()) ::
          {:ok, Room.t()} | {:error, :not_found} | {:error, Ecto.Changeset.t()}
  defdelegate delete(id), to: Delete, as: :call
end
