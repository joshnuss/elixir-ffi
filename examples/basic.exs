defmodule MyLib do
  use FFI.Library

  ffi_lib "libstdc++.so.6"

  attach_function :puts, [:string], :int
end

MyLib.puts(["Hello World from C stdlib"])
