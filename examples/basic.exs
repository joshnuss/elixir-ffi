defmodule MyLib do
  use FFI.Library, name: "libstdc++.so.6"

  attach_function :puts, [:string], :int
  attach_function :printf, [:string, :int], :int
end

MyLib.puts("Hello World from C stdlib")
MyLib.printf("Random number: %d\n", :rand.uniform(10))
