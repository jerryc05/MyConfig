#![allow(dead_code)]
#![allow(unused_attributes)]
#![allow(unused_macros)]

#[macro_use]
pub mod my_err;

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
