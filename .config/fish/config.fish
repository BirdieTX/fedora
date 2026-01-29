if status is-interactive
	# Commands to run in interactive sessions can go here

	# Remove fish greeting
	set -U fish_greeting

		# User defined functions
		alias cat='bat -p'
		alias ff='fastfetch'
		alias fft='fastfetch -c $HOME/.config/fastfetch/term.jsonc'
		alias ls='eza'
		alias neofetch='fastfetch -c neofetch'
		alias nf='fastfetch -c neofetch'
		alias update-grub='sudo grub2-mkconfig -o /boot/grub2/grub.cfg'

	# Run fastfetch configuration on shell startup (expect tty)
	fastfetch -c ~/.config/fastfetch/term.jsonc
end
