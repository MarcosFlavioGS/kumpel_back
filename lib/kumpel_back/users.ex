defmodule KumpelBack.Users do
  @moduledoc """
    Module responsable for facades to functions
  """
  alias KumpelBack.Users.Create
  alias KumpelBack.Users.Get
  alias KumpelBack.Users.Delete
  alias KumpelBack.Users.Update
  alias KumpelBack.Users.List
  alias KumpelBack.Users.Verify
  alias KumpelBack.Users.User

  @spec create(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  defdelegate create(params), to: Create, as: :call

  @spec get(String.t()) :: {:ok, User.t()} | {:error, :not_found}
  defdelegate get(id), to: Get, as: :call

  @spec delete(String.t()) ::
          {:ok, User.t()} | {:error, :not_found} | {:error, Ecto.Changeset.t()}
  defdelegate delete(id), to: Delete, as: :call

  @spec update(map()) ::
          {:ok, User.t()} | {:error, :not_found} | {:error, Ecto.Changeset.t()}
  defdelegate update(params), to: Update, as: :call

  @spec list() :: {:ok, [User.t()]} | {:error, :not_found}
  defdelegate list(), to: List, as: :call

  @spec login(map()) ::
          {:ok, User.t()} | {:error, :not_found | :unauthorized}
  defdelegate login(params), to: Verify, as: :call
end
