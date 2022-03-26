#![no_main]

#[macro_use]
mod utils;

use std::io::Write;
use crate::utils::stdout_file;

#[no_mangle]
pub fn main(_argc: i32, _argv: *const *const u8) -> i32 {
    let mut stdout = stdout_file();
    stdout.write(b"Hello, world!\n").unwrap();
    0
}
