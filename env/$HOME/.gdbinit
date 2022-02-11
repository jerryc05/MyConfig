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

# Ignore a signal, e.g. SIGUSR1
#handle SIGUSR1 nostop noprint

# Set the executable to run, e.g. ./a.out
#file ./a.out

# Set the arguments to pass to the executable, e.g. ./a.out arg1 arg2
#run arg1 arg2
