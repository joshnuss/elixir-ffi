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
      def unquote(name)(params) do
        definition = {ffi_lib,
                      unquote(name),
                      unquote(arguments),
                      unquote(return_type)}

        FFI.call(definition, params)
      end
    end
  end
end
