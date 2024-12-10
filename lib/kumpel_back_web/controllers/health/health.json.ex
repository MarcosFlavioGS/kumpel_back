defmodule KumpelBackWeb.Health.HealthJSON do
  def index(%{status: status}) do
    %{
      status: status
    }
  end
end
