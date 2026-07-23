# ~/.zshrc

# Use XDG rep
export ZDOTDIR="$HOME"

# Load modules
for file in ~/.config/zsh/*.zsh; do
	[[ -f "$file" ]] && source "$file"
done

# Starship
if command -v starship >/dev/null 2>&1; then
	eval "$(starship init zsh)"
fi
