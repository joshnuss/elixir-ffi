defmodule MyLib do
  use FFI.Library

  ffi_lib "c"

  attach_function :puts, [:string], :int
end

{:ok, pid} = MyLib.start_link

MyLib.puts(pid, "Hello world")
