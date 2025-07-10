#!/bin/bash
set -e

swww init &
sleep 0.5
swww img "$HOME/Pictures/wallpapers/default.jpg" --transition-type any
