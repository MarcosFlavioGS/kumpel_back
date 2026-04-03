defmodule KumpelBackWeb.Health.HealthControllerTest do
  use KumpelBackWeb.ConnCase

  describe "index/2" do
    test "returns 200 JSON for health check" do
      conn = get(build_conn(), ~p"/api/health")

      assert json_response(conn, 200)
    end
  end
end
