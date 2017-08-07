#!/bin/bash
i3-msg -t get_workspaces | jq -r $'.[] | "  <span foreground=\'"+(if .urgent then "#ff0000" elif .focused then "#cccccc" else "#333333" end)+"\'>"+.name+"</span>  "' | sed 's/[0-9]://g' | tr -d '\n'
