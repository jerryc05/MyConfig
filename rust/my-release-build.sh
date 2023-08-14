RUSTFLAGS="$RUSTFLAGS -C opt-level=3 -C inline-threshold=1000 -C target-cpu=native -C debug-assertions=false -C overflow-checks=false -C linker-plugin-lto=true -C incremental=true -C codegen-units=256" cargo build --release -Z build-std --target="$(rustc -vV|sed -n "s|host: ||p")"


# -Zbuild-std=std,panic_abort -Zbuild-std-features=panic_immediate_abort 