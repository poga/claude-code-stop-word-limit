#!/bin/bash
# Stop hook: if the reply is over 150 words, ask to restate.
# Uses last_assistant_message from stdin: the transcript file is flushed
# AFTER Stop hooks run, so parsing it sees only the previous reply.
input=$(cat)

# Skip when already continuing from a Stop hook, so we never loop forever.
active=$(jq -r '.stop_hook_active // false' <<<"$input")
[ "$active" = "true" ] && exit 0

words=$(jq -r '.last_assistant_message // "" | [scan("\\S+")] | length' <<<"$input")

if [ "${words:-0}" -gt 150 ]; then
  jq -n '{decision: "block", reason: "Restate concisely. That reply is too long to follow. Re-pitch it: give a little context, use ASD-STE100 Simplified Technical English, and stay under 150 words per text block."}'
fi
exit 0
