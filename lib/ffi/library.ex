defmodule FFI.Library do
  defmacro __using__(_x) do
    quote do
      import FFI.Library

      def start_link(args \\ []) do
        GenServer.start_link(__MODULE__, :init, [])
      end

      def init(state),
        do: {:ok, state}
    end
  end

  defmacro ffi_lib(name) do
    quote do
      def ffi_lib,
        do: unquote(name)
    end
  end

  defmacro attach_function(name, arguments, return_type) do
    quote do
      def unquote(name)(pid, x) do
        args = {unquote(name), x}

        GenServer.call(pid, args)
      end

      def handle_call({unquote(name), x}, _from, state) do
        IO.puts ffi_lib
        a = IO.puts(x)
        {:reply, a, state}
      end
    end
  end
end
