#![allow(dead_code)]
#![allow(unused_attributes)]
#![allow(unused_macros)]

#[macro_use]
mod my_err;
pub mod ncurses;

use std::fs::File;
use std::mem::ManuallyDrop;

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

macro_rules! file_from_fd {
    ($x:expr) => {
        unsafe { ManuallyDrop::new(File::from_raw_fd($x.as_raw_fd())) }
    };
}

macro_rules! file_from_handle {
    ($x:expr) => {
        panic!("haven't test if ManuallyDrop is required");
        unsafe { File::from_raw_handle($x.into_raw_handle()) }
    };
}

pub fn sout() -> ManuallyDrop<File> {
    #[cfg(unix)]
    {
        use std::os::unix::io::{AsRawFd, FromRawFd};
        file_from_fd!(std::io::stdout())
    }
    #[cfg(target_os = "wasi")]
    {
        use std::os::wasi::io::{AsRawFd, FromRawFd};
        file_from_fd!(std::io::stdout())
    }
    #[cfg(target_family = "windows")]
    {
        use std::os::windows::io::{AsRawHandle, FromRawHandle};
        file_from_handle!(std::io::stdout())
    }
}
