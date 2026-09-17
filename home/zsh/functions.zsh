function service_monitoring {
	if [ $# != 2 ]; then
		echo "Usage: $0 [mode] [service_name]"
	else
		if [ `uname` = "Darwin" ]; then
			brew services $1 $2
		else
			sudo systemctl $1 $2
		fi
	fi
}

function start {
	if [ $# != 1 ]; then
		echo "Usage: $0 [service_name]"
	else
		service_monitoring $0 $1
	fi
}

function stop {
	if [ $# != 1 ]; then
		echo "Usage: $0 [service_name]"
	else
		service_monitoring $0 $1
	fi
}

function restart {
	if [ $# != 1 ]; then
		echo "Usage: $0 [service_name]"
	else
		service_monitoring $0 $1
	fi
}

function status {
	if [ $# != 1 ]; then
		echo "Usage: $0 [service_name]"
	else
		if [ `uname` = 'Darwin' ]; then
			service_monitoring info $1
		else
			service_monitoring $0 $1
		fi
	fi
}

function phpserver {
	if [ $# != 2 ]; then
		php -S localhost:8080
	elif [ $1 = "-p" ]; then
		php -S localhost:$2
	else
		php -S localhost:8080
	fi
}

function dval {
	docker run --rm --workdir $HOME -v $PWD:$HOME -it arthurpigeon/valgrind
}

function old_keygen {
	if [ $# != 2 ]; then
		echo "Usage: $0 [key_name] [email_address]"
	else
		ssh-keygen -t ed25519 -f ~/.ssh/$1_ed -C "$2"
		eval "$(ssh-agent -s)"
		if [[ `uname` == 'Darwin' ]]; then
			echo "Host *\n\tAddKeysToAgent yes\n\tIdentityFile ~/.ssh/$1_ed" >> ~/.ssh/config
		else
			echo "IdentityFile ~/.ssh/$1_ed" >> ~/.ssh/config
		fi
		ssh-add ~/.ssh/$1_ed
		echo "The public key:"
		cat ~/.ssh/$1_ed.pub
	fi
}

function keygen() {
  if [ ! -x "$(command -v gum)" ]; then
    echo "Error: need gum tool to run this script, install here (https://github.com/charmbracelet/gum)"
    return 1
  fi

  echo "Choose your algorithm: "
  local SSH_ALGO=$(gum choose ed25519 ecdsa rsa)
	if [ "$?" -ne 0 ]; then
		return 1;
	fi

  local PROMPT_GUM="Enter your email: "
  local EMAIL_GUM=$(gum input --prompt "$PROMPT_GUM" --placeholder "john.davis@gmail.com")
	if [ "$?" -ne 0 ]; then
		return 1;
	fi

  local DEFAULT_LOCATION="$HOME/.ssh"
  local PROMPT_GUM="Choose where to store the key (enter for default): "
  local LOCATION=$(gum input --prompt "$PROMPT_GUM" --placeholder "$DEFAULT_LOCATION")
	if [ "$?" -ne 0 ]; then
		return 1;
	fi
  if [ -z "$LOCATION" ]; then
    local LOCATION="$DEFAULT_LOCATION"
  fi
  if [ ! -d "$LOCATION" ]; then
    echo "Error: '$LOCATION' is not a valid directory"
    return 1
  fi

  local PROMPT_GUM="Choose a name for the key: "
  local NAME_GUM=$(gum input --prompt "$PROMPT_GUM" --placeholder "name")
	if [ "$?" -ne 0 ]; then
		return 1;
	fi
  if [ -z "$NAME_GUM" ]; then
    echo "Error: please give a name"
    return 1
  fi

  local PROMPT_GUM="Give the hostname for the key: "
  local HOST_GUM=$(gum input --prompt "$PROMPT_GUM" --placeholder "github.com")
	if [ "$?" -ne 0 ]; then
		return 1;
	fi
  if [ -z "$HOST_GUM" ]; then
    local HOST_GUM="github.com"
  fi

  local PROMPT_GUM="Give the username for the key: "
  local USER_GUM=$(gum input --prompt "$PROMPT_GUM" --placeholder "git")
	if [ "$?" -ne 0 ]; then
		return 1;
	fi
  if [ -z "$USER_GUM" ]; then
    local USER_GUM="git"
  fi

  local FILENAME="$LOCATION/$NAME_GUM"_"$SSH_ALGO"
  echo "Summary:"
  echo "- Algo: $SSH_ALGO"
  echo "- Email: $EMAIL_GUM"
  echo "- Host: $HOST_GUM"
  echo "- User: $USER_GUM"
  echo "- File: $FILENAME"

  gum confirm || return 1

  ssh-keygen -t "$SSH_ALGO" -f "$FILENAME" -C "$EMAIL_GUM" -N "" -q || (echo "Error: ssh-keygen failed" && exit 1) || return 1
  echo 'eval $(ssh-agent -s)'
  echo "\nHost $NAME_GUM\n\tHostName $HOST_GUM\n\tUser $USER_GUM\n\tAddKeysToAgent yes\n\tIdentityFile $FILENAME" >> "$DEFAULT_LOCATION/config"

  echo '\nYour new public key:'
  cat "$FILENAME.pub"
}

function vm() {
	local function usage() {
		echo "Usage: vm <start|stop> <vm_name>"
		echo "       vm list"
	}
	if [ $# -ge 3 ]; then
		usage()
		return 1
	fi
	if [ $# == 1 ]; then
		if [ $1 != 'list' ]; then
			usage()
			return 1
		fi
	fi
}

function cstart() {
	if [ $# != 1 ]; then
		echo "Usage: $0 <name>"
		echo "\tnames: binexp/kali/valgrind"
		return 1
	fi
	if [[ $1 == 'binexp' ]]; then
		docker run --rm -v "$PWD":/chal -it --platform linux/amd64 binexp
	elif [[ $1 == 'kali' ]]; then
		docker run --rm -v "$PWD":/chal -it kali:latest
	elif [[ $1 == 'valgrind' ]]; then
		docker run --rm -p 6667:6667 -v "$PWD":/work -it myvalgrind:latest
	else
		echo "Unknown name"
	fi
}

function fingerprint_setup() {
	cat /etc/pam.d/sudo > /tmp/pamd.sudo.bkup
	echo "auth       sufficient     pam_tid.so" > /etc/pam.d/sudo
	cat /tmp/pamd.sudo.bkup >> /etc/pam.d/sudo
}

function flush_dns() {
	sudo killall -HUP mDNSResponder
  sudo dscacheutil -flushcache
}

function pgpenc() {
	if [ $# != 2 ]; then
		echo "Usage: $0 <user-key-id> <message>"
	else
		echo $2 | gpg --encrypt --armor -r $1
	fi
}
