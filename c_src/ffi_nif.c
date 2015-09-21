#include <sys/types.h>
#include <stdio.h>
#include <erl_nif.h>
#include <ffi.h>
#include <dlfcn.h>

#define MAXLEN 1024

enum {
  VOID = 0,
  STRING,
  INT
} TYPE;

static void call(char *library, char *function, int argc, ffi_type **args, void **values, ffi_type* returnType) {
  ffi_cif cif;
  int returnValue;
  void* handle;
  void* (*fn);

  handle = dlopen(library, RTLD_LAZY);

  if (!handle) {
    return;
  }

  fn = dlsym(handle, function);

  if (dlerror() != NULL) {
    return;
  }

  if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, argc, returnType, args) == FFI_OK) {
    ffi_call(&cif, (void*)fn, &returnValue, values);
  }

  dlclose(handle);
}

static ERL_NIF_TERM nif_call(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  char library[MAXLEN],
       function[MAXLEN];

  int argumentsLength, valuesLength, returnType, returnValue, i;

  ErlNifCharEncoding encoding = ERL_NIF_LATIN1;

  if (!enif_get_atom(env, argv[0], library, MAXLEN, encoding)) {
    return enif_make_badarg(env);
  }

  if (!enif_get_atom(env, argv[1], function, MAXLEN, encoding)) {
    return enif_make_badarg(env);
  }

  if (!enif_get_list_length(env, argv[2], &argumentsLength)) {
    return enif_make_badarg(env);
  }

  if (!enif_get_int(env, argv[3], &returnType)) {
    return enif_make_badarg(env);
  }

  if (!enif_get_list_length(env, argv[4], &valuesLength)) {
    return enif_make_badarg(env);
  }

  if (valuesLength != argumentsLength) {
    return enif_make_badarg(env);
  }

  ffi_type *ffiArgs[argumentsLength], *ffiReturnType = &ffi_type_sint;
  int args[argumentsLength];
  void *ffiValues[valuesLength];
  ERL_NIF_TERM head, tail = argv[2];
  uint type;

  for (i=0;enif_get_list_cell(env, tail, &head, &tail);i++) {
    ffi_type *ffiType;

    enif_get_uint(env, head, &type);

    args[i] = type;

    switch (type) {
      case VOID:
        ffiType = &ffi_type_void;
        break;
      case STRING:
        ffiType = &ffi_type_pointer;
        break;
      case INT:
        ffiType = &ffi_type_sint;
        break;
    }

    ffiArgs[i] = ffiType;
  }

  tail = argv[4];

  int intData;
  char charData[MAXLEN];
  char *s = charData;

  for (i=0;enif_get_list_cell(env, tail, &head, &tail);i++) {
    type = args[i];

    switch (type) {
      case VOID:
        break;
      case STRING:
        enif_get_string(env, head, charData, MAXLEN, encoding);

        ffiValues[i] = &s;

        break;
      case INT:
        enif_get_int(env, head, &intData);

        ffiValues[i] = &intData;

        break;
    }
  }

  switch (returnType) {
    case VOID:
      ffiReturnType = &ffi_type_void;
      break;
    case STRING:
      ffiReturnType = &ffi_type_pointer;
      break;
    case INT:
      ffiReturnType = &ffi_type_sint;
      break;
  }

  call(library, function, argumentsLength, ffiArgs, ffiValues, ffiReturnType);

  returnValue = 1;

  return enif_make_int(env, returnValue);
}

static ErlNifFunc nif_funcs[] = {
  {"nif_call", 5, nif_call}
};

ERL_NIF_INIT(Elixir.FFI, nif_funcs, NULL, NULL, NULL, NULL)
