RUSTFLAGS="$RUSTFLAGS -C opt-level=3 -C inline-threshold=1000 -C target-cpu=native -C debug-assertions=false -C overflow-checks=false -C linker-plugin-lto=true -C link-arg=-fuse-ld=lld -C incremental=true -C codegen-units=256" cargo build --release --config profile.release.lto=\'thin\' --config profile.release.debug=0 --config profile.release.strip=true -Z build-std --target="$(rustc -vV|sed -n "s|host: ||p")"

 

# -Zbuild-std=std,panic_abort -Zbuild-std-features=panic_immediate_abort
