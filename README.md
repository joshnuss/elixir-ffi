FFI
===

*** Warning: Turns out this is a really bad idea, do not use! When the BEAM calls native functions it needs to know how many reductions should be used. Otherwise calling a long running function can break the scheduling completly, because with this approach a long running function is considered 1 reduction ***

An easy way to call external functions (e.g. C functions) from [Elixir](https://github.com/elixir-lang/elixir).

Inspired by [Ruby's FFI](https://github.com/ffi/ffi)

** This is alpha software **

## Example Program

```elixir
defmodule MyLib do
  use FFI.Library, name: "libstdc++.so.6"

  attach_function :puts, [:string], :int
end

MyLib.puts("Hello World from C stdlib")
```

## Installation

The package can be installed by adding `ffi` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ffi, git: "https://github.com/joshnuss/elixir-ffi.git"}]
end
```

## Running Examples

```shell
mix run examples/basic.exs
```

## License

MIT
