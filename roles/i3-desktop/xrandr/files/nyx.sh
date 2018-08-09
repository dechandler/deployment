#!/bin/bash

function default () {
    xrandr \
    --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
    --output HDMI-1 --off \
    --output DP-1 --off \
    --output DP-2 --off
}

function docked () {
    #xrandr \
    #--output DVI-I-1-1 --mode 1920x1080 --pos 0x0 --rotate normal \
    #--output DVI-I-2-2 --mode 1920x1080 --pos 1920x0 --rotate normal \
    #--output eDP-1 --primary --mode 1920x1080 --pos 3840x576 --rotate normal \
    #--output HDMI-1 --off \
    #--output DP-2 --off \
    #--output DP-1 --off

    xrandr \
    --output DVI-I-1-1 --mode 1920x1080 --pos 0x840 --rotate normal \
    --output DVI-I-2-2 --mode 1920x1080 --pos 1920x0 --rotate right \
    --output eDP-1 --primary --mode 1920x1080 --pos 3000x1376 --rotate normal \
    --output HDMI-1 --off \
    --output DP-2 --off \
    --output DP-1 --off
}

function main () {
    if grep 'docked' <<< $@; then
        docked
    else
        default
    fi 
}

main $@ &>/dev/null
