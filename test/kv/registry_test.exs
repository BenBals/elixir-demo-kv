defmodule KV.RegistyTest do
  use ExUnit.Case, async: true

  setup context do
    {:ok, registry} = KV.Registry.start_link(context.test)
    {:ok, registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") === :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") === 1
  end


  test "removes bucket on exit", %{registry: registry} do
    # make a shopping bucket
    KV.Registry.create(registry, "shopping")
    # get its pid
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    # stop it via Agent.stop (aka crash it)
    Agent.stop(bucket)
    # make sure the bucket no longer is in the registry
    assert KV.Registry.lookup(registry, "shopping") === :error
  end

  test "removes bucket on crash", %{registry: registry} do
    KV.Registry.create registry, "shopping"
    {:ok, bucket} = KV.Registry.lookup registry, "shopping"

    # Stop the bucket with non-normal reason
    Process.exit bucket, :shutdown

    # Wait til the bucket is dead
    ref = Process.monitor bucket
    assert_receive {:DOWN, ^ref, _, _, _}

    assert KV.Registry.lookup registry, "shopping" === :error
  end
end
