use std::fs::File;
use std::sync::Mutex;
use std::{borrow::Cow, ops::Generator};

use crate::utils::stdout_file;

#[derive(Debug)]
struct TestResult<'a> {
    name: Cow<'a, str>,
    ok: bool,
    reason: Cow<'a, str>,
    elapsed: f32,
}

struct Test<'a> {
    scheduler: &'a dyn Generator<Yield = TestResult<'a>, Return = ()>,
    n_pool: u8,
    stdout: Mutex<File>,
}

impl<'a> Test<'a> {
    pub fn new(
        scheduler: &'a dyn Generator<Yield = TestResult<'a>, Return = ()>,
        n_pool: u8,
    ) -> Self {
        Self {
            scheduler,
            n_pool,
            stdout: Mutex::new(stdout_file()),
        }
    }

    pub const fn version() {
        env!("CARGO_PKG_VERSION");
    }
}

trait TestTrait {
    fn test(&self) {
        // p(
        //     f"{p.L_CYAN}{ver}\t# pools: {p.BOLD}{self.n_pools()}\t{p.NORMAL}Term cols:"
        //     f" {p.BOLD}{get_cols()}"
        // )
    }
}
