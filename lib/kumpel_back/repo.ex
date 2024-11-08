defmodule KumpelBack.Repo do
  use Ecto.Repo,
    otp_app: :kumpel_back,
    adapter: Ecto.Adapters.Postgres
end
