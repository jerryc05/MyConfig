pub use ncurses::*;

#[derive(Debug)]
struct NcursesWindow(WINDOW);

impl Drop for NcursesWindow {
    fn drop(&mut self) {
        endwin();
    }
}
