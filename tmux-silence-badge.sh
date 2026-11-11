#!/bin/sh
# Colour the catppuccin window-number badge by window state (non-current windows only):
#   pi/omp windows (@pi_state set by ~/.omp/agent/extensions/tmux-state.ts):
#     ask = red (waiting on your answer)   busy = yellow   done = green (until you visit)   idle = grey
#   other windows (tmux monitor-activity / monitor-silence):
#     output since last visit = yellow     quiet for monitor-silence seconds = green       else grey
f=$(tmux show -gv window-status-format)
case "$f" in
  *pi_state*) ;;
  *) tmux set -g window-status-format "$(printf %s "$f" | sed 's|#{@thm_overlay_2}|#{?#{==:#{@pi_state},ask},#{@thm_red},#{?#{==:#{@pi_state},busy},#{@thm_yellow},#{?#{==:#{@pi_state},done},#{@thm_green},#{?#{==:#{@pi_state},idle},#{@thm_overlay_2},#{?window_silence_flag,#{@thm_green},#{?window_activity_flag,#{@thm_yellow},#{@thm_overlay_2}}}}}}}|')" ;;
esac
