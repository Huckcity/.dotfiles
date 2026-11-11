// Publish this pi/omp session's state as a tmux window option, @pi_state:
//   busy  - working on a turn          ask - waiting on an answer (ask tool)
//   done  - turn finished, not yet looked at (tmux hook flips it to idle on visit)
// The tmux status format colours the window-number badge from it (tmux-silence-badge.sh).
import { execFile } from "node:child_process";

export default function (pi: any) {
  const pane = process.env.TMUX_PANE;
  if (!process.env.TMUX || !pane) return;
  const set = (state: string | null) =>
    execFile("tmux", state ? ["set-option", "-w", "-t", pane, "@pi_state", state]
                           : ["set-option", "-wu", "-t", pane, "@pi_state"], () => {});
  const isAsk = (e: any) => /ask/i.test(String(e?.toolName ?? e?.tool ?? e?.name ?? ""));
  pi.on("session_start", () => set("idle"));
  pi.on("agent_start", () => set("busy"));
  pi.on("agent_end", () => set("done"));
  pi.on("tool_call", (e: any) => { if (isAsk(e)) set("ask"); });
  pi.on("tool_result", (e: any) => { if (isAsk(e)) set("busy"); });
  pi.on("session_shutdown", () => set(null));
}
