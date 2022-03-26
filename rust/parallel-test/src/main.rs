#![no_main]
#![feature(generator_trait)]

#[macro_use]
mod utils;
mod test;

use crate::ncurses::*;
use crate::utils::*;

#[no_mangle]
pub fn main(_argc: i32, _argv: *const *const u8) -> i32 {
    let w = NcursesWindow::default();
    {
        let x = w.getcurx();
        let y = w.getcury();
        w.addstr(&format!("{} {}", x, y));
        w.move_(y + 1, 0);
    }
    w.addstr("Hello, world! Ncurses!");
    {
        let x = w.getcurx();
        let y = w.getcury();
        w.addstr(&format!("{} {}", x, y));
        w.move_(y + 1, 0);
    }
    w.refresh();
    w.getch();

    0
}
