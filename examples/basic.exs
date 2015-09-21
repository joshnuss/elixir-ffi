defmodule MyLib do
  use FFI.Library

  ffi_lib "c"

  attach_function :puts, [:string], :int
end

IO.inspect MyLib.puts("Hello world")
