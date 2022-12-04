tee_if_not_exists() {
  grep -F "$1" "$2" >/dev/null || echo "$1" | sudo tee -a "$2"
}
