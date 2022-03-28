use std::io::Write;

pub use ncurses::{
    box_, getcurx, getcury, keypad, waddnstr, waddstr, wgetch, wmove, wrefresh, WINDOW,
};
use ncurses::{endwin, initscr, newwin, noecho, raw, stdscr};
pub use ncurses::{ERR, OK};
pub use ncurses::{KEY_F0, KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6, KEY_F7, KEY_F9};
pub use ncurses::{KEY_F10, KEY_F11, KEY_F12, KEY_F13, KEY_F14, KEY_F15};

use crate::utils::{is_debug, sout};

#[derive(Debug)]
pub struct NcursesMgr {}

#[cfg(feature = "ref-count-init")]
static mut REF: usize = 0;

impl Default for NcursesMgr {
    fn default() -> NcursesMgr {
        #[cfg(feature = "ref-count-init")]
        fn do_() -> bool {
            let mut do_ = true;
            if cfg!(feature = "ref-count-init") {
                if unsafe { REF } != 0 {
                    do_ = false;
                }
                unsafe {
                    REF += 1;
                }
            }
            do_
        }

        #[cfg(not(feature = "ref-count-init"))]
        fn do_() -> bool {
            true
        }

        if do_() {
            if is_debug() {
                sout().write(b"init ncurses\n").unwrap();
            }
            initscr();
        }
        NcursesMgr {}
    }
}

impl Drop for NcursesMgr {
    fn drop(&mut self) {
        #[cfg(feature = "ref-count-init")]
        fn do_() -> bool {
            debug_assert!(unsafe { REF } > 0);
            let mut do_ = true;
            if cfg!(feature = "ref-count-init") {
                unsafe {
                    REF -= 1;
                }
                if unsafe { REF } != 0 {
                    do_ = false;
                }
            }
            do_
        }

        #[cfg(not(feature = "ref-count-init"))]
        fn do_() -> bool {
            true
        }

        if do_() {
            let r = endwin();
            if is_debug() {
                sout().write(b"end ncurses\n").unwrap();
            }
            debug_assert_eq!(r, OK);
        }
    }
}

impl NcursesMgr {
    pub fn newwin(&self, lines: i32, cols: i32, y: i32, x: i32) -> WINDOW {
        newwin(lines, cols, y, x)
    }
    pub fn stdscr(&self) -> WINDOW {
        stdscr()
    }
    pub fn noecho(&self) -> i32 {
        noecho()
    }
    pub fn raw(&self) -> i32 {
        raw()
    }
}
