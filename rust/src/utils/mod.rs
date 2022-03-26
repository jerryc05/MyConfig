#![allow(dead_code)]
#![allow(unused_attributes)]
#![allow(unused_macros)]

#[macro_use]
mod my_err;
pub mod ncurses;

use std::fs::File;
use std::os::unix::io::FromRawFd;

#[inline]
pub const fn is_debug() -> bool {
    cfg!(debug_assertions)
}

#[macro_use]
macro_rules! static_assert {
    ($x:expr $(,)?) => {
        const _: [(); 0 - !{
            const X: bool = $x;
            X
        } as usize] = [];
    };
}

pub fn stdout_file() -> File {
    unsafe { File::from_raw_fd(1) }
}
