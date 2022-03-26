#![no_main]
#![feature(generator_trait)]

#[macro_use]
mod utils;
mod test;

use crate::ncurses::*;
use crate::utils::*;

#[no_mangle]
pub fn main(_argc: i32, _argv: *const *const u8) -> i32 {
    let w: WINDOW = initscr();
    {
        let x = getcurx(w);
        let y = getcury(w);
        addstr(&format!("{} {}", x, y));
        mv(y + 1, 0);
    }
    addstr("Hello, world! Ncurses!");
    {
        let x = getcurx(w);
        let y = getcury(w);
        addstr(&format!("{} {}", x, y));
        mv(y + 1, 0);
    }
    refresh();
    getch();
    endwin();

    0
}
