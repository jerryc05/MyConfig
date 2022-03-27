#![no_main]
#![feature(generator_trait)]

#[macro_use]
mod utils;
mod test;

use crate::ncurses::*;
use crate::utils::*;

#[no_mangle]
pub fn main(_argc: i32, _argv: *const *const u8) -> i32 {
    let n = NcursesMgr::default();
    box_(n.stdscr(), 0, 0);
    {
        let x = getcurx(n.stdscr());
        let y = getcury(n.stdscr());
        wmove(n.stdscr(), y + 1, 1);
        waddstr(n.stdscr(), &format!("{} {}", x, y));
    }
    wmove(n.stdscr(), getcury(n.stdscr()) + 1, 1);
    waddstr(n.stdscr(), "Hello, world! Ncurses!");
    {
        let x = getcurx(n.stdscr());
        let y = getcury(n.stdscr());
        wmove(n.stdscr(), y + 1, 1);
        waddstr(n.stdscr(), &format!("{} {}", x, y));
    }
    wrefresh(n.stdscr());
    wgetch(n.stdscr());

    0
}
