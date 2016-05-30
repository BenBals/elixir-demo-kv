defmodule KV.Bucket do
  @doc """
  Starts a new bucket and hands back its identifier (pid)
  """
  def start_link do
    Agent.start_link fn -> %{} end
  end

  @doc """
  get the value for a key from a bucket
  """
  def get(bucket, key) do
    Agent.get bucket, fn map -> Map.get map, key end
  end

  @doc """
  set the value for a key in a bucket
  """
  def put(bucket, key, value) do
    Agent.update bucket, fn map -> Map.put map, key, value end
  end

  @doc """
  Deletes `key` from `bucket`

  Returns the current value of `key` if present
  """
  def delete bucket, key do
    Agent.get_and_update bucket, &Map.pop(&1, key)
  end


end
