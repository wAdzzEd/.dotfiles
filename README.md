# 🏠 Robin's Dotfiles

<div align="center">

![Arch Linux Badge](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=archlinux\&logoColor=fff\&style=for-the-badge)
![Zsh Badge](https://img.shields.io/badge/Zsh-F15A24?logo=gnu-bash\&logoColor=fff\&style=for-the-badge)
![GNU Stow Badge](https://img.shields.io/badge/GNU%20Stow-444444?style=for-the-badge)

</div>

<div align="center">

![Kitty Badge](https://img.shields.io/badge/Kitty-000000?logo=kitty\&logoColor=fff\&style=for-the-badge)  
![Starship Badge](https://img.shields.io/badge/Starship-DD0B78?logo=starship\&logoColor=fff\&style=for-the-badge)  
![Fastfetch Badge](https://img.shields.io/badge/Fastfetch-7B68EE?style=for-the-badge)  
![Micro Badge](https://img.shields.io/badge/Micro-2E8B57?style=for-the-badge)  
![Git Badge](https://img.shields.io/badge/Git-F05032?logo=git\&logoColor=fff\&style=for-the-badge)

</div>

My personal Arch Linux dotfiles, managed with **GNU Stow** and installed through a simple bootstrap script.

The goal of this repository is to keep my development environment **minimal, reproducible and easy to maintain**.

---

## 🚀 Installation

Install Git:

```bash
sudo pacman -S git
```

Clone the repository:

```bash
git clone git@github.com:wAdzzEd/.dotfiles.git ~/.dotfiles
```

Run the bootstrap:

```bash
cd ~/.dotfiles
bash bootstrap.d/bootstrap.sh
```

The bootstrap script will:

* install required packages
* install AUR packages
* configure Git
* create symbolic links using GNU Stow
* configure the default shell

Once finished, reboot your computer.

---

## 📂 Repository Structure

```
.
├── .config/
│   ├── fastfetch/
│   ├── kitty/
│   └── zsh/
│
├── bootstrap.d/
│   ├── packages/
│   └── *.sh
│
├── .gitconfig
├── .zshrc
└── README.md
```

The repository mirrors the structure of `$HOME`, allowing GNU Stow to manage every configuration file automatically.

---

## 🖥️ Environment

* **OS:** Arch Linux
* **Shell:** Zsh
* **Terminal:** Kitty
* **Prompt:** Starship
* **Editor:** Micro *(work in progress)*
* **File Manager:** Yazi
* **Git UI:** Lazygit
* **System Monitor:** Btop

---

## 📸 Screenshots

> Coming soon.

---

## 📜 License

This project is released under the MIT License.
