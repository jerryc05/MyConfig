# Enable any project's local .gdbinit
set auto-load safe-path /

# Pause at any exception/signal
catch throw

# When displaying a pointer to an object, identify the actual (derived) type of the object
# rather than the declared type, using the virtual function table.
set print object on

# Print C++ names in their source form rather than their mangled form, even in assembler code
# printouts such as instruction disassemblies. The default is off.
set print asm-demangle on
