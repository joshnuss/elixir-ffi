CC=gcc
CFLAGS=-fPIC
OBJ = ffi_nif.o
TARGET = ffi_nif.so
LIBS += -ldl -lffi
ERTS_INCLUDE_PATH ?=$(REBAR_PLT_DIR)/erts-7.3/include
DIR=c_src

$(DIR)/%.o: $(DIR)/%.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS) -I$(ERTS_INCLUDE_PATH)

$(TARGET): $(DIR)/$(OBJ)
	$(CC) -shared -o $@ $^ $(CFLAGS) $(LIBS)

.PHONY : $(TARGET)

clean :
	$(RM) $(DIR)/*.o *.so
