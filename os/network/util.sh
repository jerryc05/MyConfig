tee_if_not_exists() {
  fgrep "$1" "$2" >/dev/null || echo "$1" | sudo tee -a "$2"
}
