function fingerprint_setup() {
  mise run --skip-tools touch-id
}

function flush_dns() {
  sudo killall -HUP mDNSResponder
  sudo dscacheutil -flushcache
}
