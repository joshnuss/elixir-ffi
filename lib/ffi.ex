defmodule FFI do
  @on_load :init

  def init do
    :erlang.load_nif("./ffi_nif", 0)
  end

  def call({library, name, arguments, return_type}, params),
    do: nif_call(library, name, arguments, return_type, params)

  def nif_call(library, name, arguments, return_type, params) do
    :badarg
  end
end
