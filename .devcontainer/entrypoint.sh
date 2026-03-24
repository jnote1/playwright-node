#!/bin/bash
set -e

export DISPLAY="${DISPLAY:-:1}"

# DBUS 세션을 준비해 IBus/dconf가 동작할 수 있게 합니다.
if command -v dbus-launch >/dev/null 2>&1; then
    eval "$(dbus-launch --sh-syntax)"
    export DBUS_SESSION_BUS_ADDRESS

    printf 'export DBUS_SESSION_BUS_ADDRESS=%s\n' "$DBUS_SESSION_BUS_ADDRESS" > /tmp/dbus_env

    for bashrc in /root/.bashrc /home/vscode/.bashrc; do
        if [ -f "$bashrc" ] && ! grep -q "source /tmp/dbus_env" "$bashrc"; then
            echo '[ -f /tmp/dbus_env ] && source /tmp/dbus_env' >> "$bashrc"
        fi
    done
fi

# 한글 입력 초기화는 best-effort로 수행하고 실패해도 컨테이너는 유지합니다.
ibus-daemon -drx || true
sleep 1
dconf write /org/freedesktop/ibus/engine/hangul/initial-input-mode "'hangul'" || true
dconf write /desktop/ibus/general/preload-engines "['hangul']" || true
dconf write /desktop/ibus/general/engines-order "['hangul']" || true

display_num="${DISPLAY#:}"
if [ -n "$display_num" ] && [ -S "/tmp/.X11-unix/X${display_num}" ]; then
    ibus engine hangul || true
fi

# 전달된 명령어 실행
exec "$@"