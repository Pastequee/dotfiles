function fingerprint_setup() {
	cat /etc/pam.d/sudo > /tmp/pamd.sudo.bkup
	echo "auth       sufficient     pam_tid.so" > /etc/pam.d/sudo
	cat /tmp/pamd.sudo.bkup >> /etc/pam.d/sudo
}

function flush_dns() {
	sudo killall -HUP mDNSResponder
  sudo dscacheutil -flushcache
}
