defmodule KV.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    # defines stuff to supervise
    children = [
      # will call KV.start_link(KV.Registry)
      # the first arg is the module to call start_link upon
      # the sec arg is the args to give
      # this will name the process KV.Registry (common to use the same name)
      worker(KV.Registry, [KV.Registry]),
      supervisor(KV.Bucket.Supervisor, [])
    ]

    # supervise there children using the given strategy
    supervise(children, strategy: :one_for_one)
  end
end
