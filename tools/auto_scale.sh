#!/bin/bash
# AUTO-SCALE — COARE Dynamic Resource Manager

while true; do
    LOAD=$(curl -s -X POST http://localhost:8086/api/self-test 2>/dev/null | python3 -c "import sys,json;print(json.load(sys.stdin).get('add_tps',0))" 2>/dev/null)
    
    if [ "$LOAD" -gt 65000000 ]; then
        echo "[$(date '+%H:%M:%S')] 🟢 Optimal — $LOAD TPS"
    elif [ "$LOAD" -gt 40000000 ]; then
        echo "[$(date '+%H:%M:%S')] 🟡 Moderate — Scaling up suggested"
    else
        echo "[$(date '+%H:%M:%S')] 🔴 Low — Check system health"
    fi
    
    sleep 60
done
