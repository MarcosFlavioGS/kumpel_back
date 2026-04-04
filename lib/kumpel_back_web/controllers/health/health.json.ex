defmodule KumpelBackWeb.Health.HealthJSON do
  @spec index(map()) :: map()
  def index(%{status: status}) do
    %{
      status: status
    }
  end
end
