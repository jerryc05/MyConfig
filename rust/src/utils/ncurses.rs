use std::rc::Rc;

use ncurses::*;

use crate::utils::*;

pub use ncurses::{ERR, OK};
pub use ncurses::{KEY_F0, KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6, KEY_F7, KEY_F9};
pub use ncurses::{KEY_F10, KEY_F11, KEY_F12, KEY_F13, KEY_F14, KEY_F15};

#[cfg(debug_assertions)]
#[derive(Debug)]
pub struct NcursesWindow(Rc<WINDOW>);

#[cfg(not(debug_assertions))]
#[derive(Debug)]
pub struct NcursesWindow(WINDOW);

impl Default for NcursesWindow {
    #[cfg(debug_assertions)]
    fn default() -> Self {
        NcursesWindow(Rc::new(stdscr()))
    }
    #[cfg(not(debug_assertions))]
    fn default() -> Self {
        NcursesWindow(stdscr())
    }
}

impl Drop for NcursesWindow {
    #[cfg(debug_assertions)]
    fn drop(&mut self) {
        if Rc::strong_count(&self.0) == 1 {
            endwin();
        }
    }
    #[cfg(not(debug_assertions))]
    fn drop(&mut self) {
        if (self.0 == stdscr()) {
            endwin()
        }
    }
}

impl NcursesWindow {
    pub fn get_window(&self) -> WINDOW {
        self.0
    }
    pub fn newwin(lines: i32, cols: i32, y: i32, x: i32) -> Self {
        NcursesWindow(newwin(lines, cols, y, x))
    }
    pub fn addstr(&self, s: &str) {
        waddstr(self.0, s);
    }
    pub fn box_(&self, v: chtype, h: chtype) -> i32 {
        box_(self.0, v, h)
    }
    pub fn getch(&self) -> i32 {
        wgetch(self.0)
    }
    pub fn getbegx(&self) -> i32 {
        getbegx(self.0)
    }
    pub fn getbegy(&self) -> i32 {
        getbegy(self.0)
    }
    pub fn getcurx(&self) -> i32 {
        getcurx(self.0)
    }
    pub fn getcury(&self) -> i32 {
        getcury(self.0)
    }
    pub fn getmaxx(&self) -> i32 {
        getmaxx(self.0)
    }
    pub fn getmaxy(&self) -> i32 {
        getmaxy(self.0)
    }
    pub fn halfdelay(&self, tenths: i32) -> i32 {
        halfdelay(tenths)
    }
    pub fn keypad(&self, b: bool) -> i32 {
        keypad(self.0, b)
    }
    pub fn move_(&self, y: i32, x: i32) -> i32 {
        wmove(self.0, y, x)
    }
    pub fn noecho(&self) -> i32 {
        noecho()
    }
    pub fn raw(&self) -> i32 {
        raw()
    }
    pub fn refresh(&self) -> i32 {
        wrefresh(self.0)
    }
}
