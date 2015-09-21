defmodule FFI do
  @on_load :init

  @typemap %{
    void: 0,
    string: 1,
    int: 2
  }

  def init do
    :ok = :erlang.load_nif("./ffi_nif", 0)
  end

  def call({library, function, arguments, return_type}, values) do
    nif_call(String.to_atom(library),
              function,
              Enum.map(arguments, &map_type/1),
              map_type(return_type),
              clean_values(values))
  end

  def nif_call(library, function, arguments, return_type, values) do
    :badarg
  end

  defp map_type(type), do: @typemap[type]

  defp clean_values(values) do
    Enum.map values, fn
      str when is_bitstring(str) -> to_char_list(str)
      other -> other
    end
  end
end
