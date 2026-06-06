defmodule KumpelBack.Messages.Create do
  @moduledoc false

  alias KumpelBack.Repo
  alias KumpelBack.Messages.Message

  @spec call(map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  def call(params) do
    params
    |> Message.changeset()
    |> Repo.insert()
  end
end
