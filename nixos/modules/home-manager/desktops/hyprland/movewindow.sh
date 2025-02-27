#!/usr/bin/env bash

# Taken from https://github.com/outfoxxed/hy3/issues/2#issuecomment-2273454747

SOCAT="socat - $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock"
if [ "$1" = "r" ] ; then
    NowWindow="$(echo -n '[[BATCH]]j/activewindow;/dispatch hy3:movewindow r, once, visible' |$SOCAT |grep -vE '^(ok)?$' | jaq '.address')"
    ThenWindow="$(echo -n 'j/activewindow' |$SOCAT | jaq ".address")"
    if [ "$NowWindow" = "$ThenWindow" ]; then
        echo -n '/dispatch movewindow mon:-1' |$SOCAT
    fi
elif [ "$1" = "l" ] ; then
    NowWindow="$(echo -n '[[BATCH]]j/activewindow;/dispatch hy3:movewindow l, once, visible' |$SOCAT |grep -vE '^(ok)?$' | jaq ".address")"
    ThenWindow="$(echo -n 'j/activewindow' |$SOCAT| jaq ".address")"
    if [ "$NowWindow" = "$ThenWindow" ]; then
        echo -n '/dispatch movewindow mon:+1' |$SOCAT
    fi
fi
