FFI
===

An easy way to call external functions (e.g. C functions) from [Elixir](https://github.com/elixir-lang/elixir).

** This is alpha software **

## Example Program

```elixir
defmodule MyLib do
  use FFI.Library

  ffi_lib "c"

  attach_function :puts, [:string], :int
end

MyLib.puts(["Hello world"])
```

## License

MIT
