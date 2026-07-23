mkcd() {
	mkdir -p "$1"
	cd "$1"
}

extract() {
	case "$1" in
		*.tar.gz) tar -xzf "$1" ;;
		*.zip) unzip "$1" ;;
		*.rar) unrar x "$1" ;;
		*) echo "Format non supporté." ;;
	esac
}
