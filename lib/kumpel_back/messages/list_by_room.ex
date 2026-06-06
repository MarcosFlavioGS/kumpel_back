defmodule KumpelBack.Messages.ListByRoom do
  @moduledoc false

  import Ecto.Query
  alias KumpelBack.Repo
  alias KumpelBack.Messages.Message

  @default_limit 50
  @max_limit 100

  @spec call(String.t(), keyword()) :: {:ok, [Message.t()], boolean()}
  def call(room_id, opts \\ []) do
    limit = min(Keyword.get(opts, :limit, @default_limit), @max_limit)
    before_dt = Keyword.get(opts, :before)

    query =
      from m in Message,
        where: m.room_id == ^room_id,
        order_by: [desc: m.inserted_at],
        limit: ^(limit + 1)

    query =
      if before_dt do
        where(query, [m], m.inserted_at < ^before_dt)
      else
        query
      end

    results = Repo.all(query)
    has_more = length(results) > limit
    messages = results |> Enum.take(limit) |> Enum.reverse()

    {:ok, messages, has_more}
  end
end
