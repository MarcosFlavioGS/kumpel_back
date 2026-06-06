defmodule KumpelBackWeb.Messages.MessagesJSON do
  @moduledoc """
  JSON renderers for message history responses.
  """

  alias KumpelBack.Messages.Message

  @spec index(map()) :: map()
  def index(%{messages: messages, has_more: has_more}) do
    %{
      data: Enum.map(messages, &serialize/1),
      has_more: has_more
    }
  end

  @spec serialize(Message.t()) :: map()
  def serialize(%Message{} = msg) do
    %{
      id: msg.id,
      body: msg.body,
      user: msg.user_name,
      color: msg.color,
      inserted_at: DateTime.to_iso8601(msg.inserted_at)
    }
  end
end
