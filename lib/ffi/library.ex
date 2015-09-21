defmodule FFI.Library do
  defmacro __using__(_x) do
    quote do
      import FFI.Library
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
      def unquote(name)(pid, params) do
        args = {unquote(name), params}

        GenServer.call(pid, args)
      end

      def handle_call({unquote(name), params}, _from, state) do
        IO.puts ffi_lib
        a = IO.puts(params)
        {:reply, a, state}
      end
    end
  end
end
