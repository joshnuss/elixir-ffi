defmodule MyLib do
  use FFI.Library, name: "libstdc++.so.6"

  attach_function :puts, [:string], :int
end

MyLib.puts(["Hello World from C stdlib"])
