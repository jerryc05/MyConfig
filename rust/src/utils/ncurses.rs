use ncurses::*;

pub use ncurses::{KEY_F0, KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6, KEY_F7, KEY_F9};
pub use ncurses::{KEY_F10, KEY_F11, KEY_F12, KEY_F13, KEY_F14, KEY_F15};

#[derive(Debug)]
pub struct NcursesWindow(WINDOW);

impl Default for NcursesWindow {
    fn default() -> Self {
        NcursesWindow(initscr())
    }
}

impl Drop for NcursesWindow {
    fn drop(&mut self) {
        endwin();
    }
}

impl NcursesWindow {
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
