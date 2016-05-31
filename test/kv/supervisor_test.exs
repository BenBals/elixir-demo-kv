defmodule KV.SupervisorTest do
  use ExUnit.Case, async: true


  test "cleans registry on bucket supervisor crash" do
    KV.Registry.create KV.Registry, "shopping"
    bucket_supervisor_pid = :erlang.whereis KV.Bucket.Supervisor
    Process.exit bucket_supervisor_pid, :shutdown

    ref = Process.monitor KV.Bucket.Registry
    assert_receive {:DOWN, ^ref, _, _, _}

    assert KV.Registry.lookup KV.Registry, "shopping" === :error
  end
end
