defmodule KV.RegistyTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = KV.Registry.start_link
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
end
