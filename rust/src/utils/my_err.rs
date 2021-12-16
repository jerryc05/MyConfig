#![allow(dead_code)]
#![allow(unused_macros)]

use core::result;
use std::borrow::Cow;
use std::fmt::{Debug, Formatter, Result};

pub(crate) const CONSOLE_FMT_WIDTH: usize = 50;

pub(crate) type MyResult<T> = result::Result<T, MyErr>;

pub struct MyErr {
  err: Cow<'static, str>,
  file: &'static str,
  line: u32,
}

impl MyErr {
  pub fn from_str<T: Into<Cow<'static, str>>>(
    s: T, file: &'static str, line: u32,
  ) -> Self {
    Self { err: s.into(), file, line }
  }

  pub fn from_err<T: Debug>(
    err: &T, file: &'static str, line: u32,
  ) -> Self {
    Self::from_str(format!("{:?}", err), file, line)
  }
}

#[macro_use]
macro_rules! my_err_of_str {
  ($s:expr $(, )?) => {
    MyErr::from_str($s, file!(), line!())
  };
  ($s:expr, $offset:expr $(, )?) => {
    MyErr::from_str($s, file!(), line!() - $offset)
  };
}

#[macro_use]
macro_rules! my_err_of_err {
  ($e:expr $(, )?) => {
    MyErr::from_err(&$e, file!(), line!())
  };
  ($e:expr, $offset:expr $(, )?) => {
    MyErr::from_err(&$e, file!(), line!() - $offset)
  };
}

impl Debug for MyErr {
  fn fmt(&self, f: &mut Formatter<'_>) -> Result {
    const ERROR: &str = "ERROR";
    writeln!(
      f, "
{1:-^0$}
| msg: [{2}]
|
| at: [{3}:{4}]
{1:-^0$}",
      CONSOLE_FMT_WIDTH, ERROR, self.err, self.file, self.line)
  }
}