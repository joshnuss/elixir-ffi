defmodule FFI.Library do
  defmacro __using__([name: name]) do
    quote do
      import FFI.Library

      def ffi_lib, do: unquote(name)
    end
  end

  defmacro attach_function(name, arguments, return_type) do
    argument_names = make_argument_names(arguments)

    quote do
      def unquote(name)(unquote_splicing(argument_names)) do
        definition = {ffi_lib,
                      unquote(name),
                      unquote(arguments),
                      unquote(return_type)}

        FFI.call(definition, [unquote_splicing(argument_names)])
      end
    end
  end

  defp make_argument_names(arguments) do
    arguments
    |> Enum.with_index
    |> Enum.map(&make_argument_name/1)
  end

  defp make_argument_name({_type, index}) do
    variable_name = [?a + index]
                    |> to_string
                    |> String.to_atom

    Macro.var(variable_name, nil)
  end
end
