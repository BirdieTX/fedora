if status is-interactive
	# Commands to run in interactive sessions can go here

	# Remove fish greeting
	set -U fish_greeting

		# User defined functions
		alias cat='bat -p'
		alias dnfarm='sudo dnf5 autoremove'
		alias dnfcu='dnf5 check-upgrade'
		alias dnfdg='sudo dnf5 downgrade --allowerasing --allowd-downgrade'
		alias dnfdl='dnf5 download --alldeps --resolve'
		alias dnfin='sudo dnf5 install --allowerasing --allow-downgrade'
		alias dnfls='dnf5 list'
		alias dnflsi='dnf5 list --installed'
		alias dnfmin='sudo dnf5 upgrade --allowerasing --allow-downgrade --minimal'
		alias dnfpatch='sudo dnf5 upgrade --allowerasing --allow-downgrade --bugfix --security'
		alias dnfrb='sudo dnf5 offline reboot'
		alias dnfref='dnf5 check-upgrade --refresh'
		alias dnfrm='sudo dnf5 remove'
		alias dnfsd='sudo dnf5 offline reboot --poweroff'
		alias dnfse='dnf5 list | grep'
		alias dnfsei='dnf5 list --installed | grep'
		alias dnfup='sudo dnf5 upgrade --allowerasing --allow-downgrade'
		alias ff='fastfetch'
		alias fft='fastfetch -c $HOME/.config/fastfetch/term.jsonc'
		alias fparm='flatpak uninstall --unused'
		alias fpin='flatpak install'
		alias fpls='flatpak list'
		alias fprm='flatpak uninstall'
		alias fpse='flatpak search'
		alias fpsei='flatpak list | grep'
		alias fpup='flatpak update'
		alias ls='eza'
		alias neofetch='fastfetch -c neofetch'
		alias nf='fastfetch -c neofetch'
		alias update-grub='sudo grub2-mkconfig -o /boot/grub2/grub.cfg'

	# Run fastfetch configuration on shell startup (expect tty)
	fastfetch -c ~/.config/fastfetch/term.jsonc
end
