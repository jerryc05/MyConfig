/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

extern "C" const char *__asan_default_options() {  // NOLINT
  return ":allow_addr2line=1"
         ":check_initialization_order=1"
         ":check_printf=1"
         ":decorate_proc_maps=1"
         ":detect_container_overflow=1"
         ":detect_invalid_pointer_pairs=2"
         ":detect_leaks=1"
         ":detect_stack_use_after_return=1"
         ":exitcode=1"
         ":fast_unwind_on_check=1"
         ":fast_unwind_on_fatal=1"
         ":fast_unwind_on_malloc=1"
         ":handle_abort=1"
         ":handle_segv=1"
         ":handle_sigbus=1"
         ":handle_sigfpe=1"
         ":handle_sigill=1"
         ":handle_sigtrap=1"
         ":intercept_tls_get_addr=1"
         ":leak_check_at_exit=1"
         ":print_summary=1"
         ":strict_init_order=1"
         ":strict_memcmp=0"
         ":strict_string_checks=1"
         ":symbolize=1"
         ":unmap_shadow_on_exit=1"
         ":windows_hook_rtl_allocators=1";

  // [BUG] "detect_invalid_pointer_pairs=2"conflicts with "detect_stack_use_after_return=1" when the stack size is too big (will be fixed soon)
  // [MSG] "check_initialization_order=1" is not supported on MacOS
  // [DEL] "handle_ioctl=1" is Linux only?
  // [DEL] "print_module_map=1" prints too much text
  // [DEL] "print_stats=1" prints too much text
  // [DEL] "verbosity=1" prints too much text
}

extern "C" const char *__ubsan_default_options() {  // NOLINT
  return ":allow_addr2line=1"
         ":decorate_proc_maps=1"
         ":fast_unwind_on_check=1"
         ":fast_unwind_on_fatal=1"
         ":fast_unwind_on_malloc=1"
         ":handle_abort=1"
         ":handle_segv=1"
         ":handle_sigbus=1"
         ":handle_sigfpe=1"
         ":handle_sigill=1"
         ":handle_sigtrap=1"
         ":intercept_tls_get_addr=1"
         ":leak_check_at_exit=1"
         ":legacy_pthread_cond=1"
         ":print_stacktrace=1"
         ":print_summary=1"
         ":strict_string_checks=1"
         ":symbolize=1";

  // [DEL] "handle_ioctl=1" is Linux only?
  // [DEL] "verbosity=1" prints too much text
}
