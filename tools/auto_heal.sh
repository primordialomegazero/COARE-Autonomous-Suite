#!/bin/bash
# AUTO-HEAL — COARE Autonomous Recovery
# Monitors B5, auto-restarts on failure

while true; do
    HTTP=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8086/api 2>/dev/null)
    
    if [ "$HTTP" != "200" ]; then
        echo "[$(date '+%H:%M:%S')] ⚠️ B5 down (HTTP $HTTP) — Auto-healing..."
        docker restart coare-b5 2>/dev/null
        sleep 5
        NEW_HTTP=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8086/api 2>/dev/null)
        if [ "$NEW_HTTP" = "200" ]; then
            echo "[$(date '+%H:%M:%S')] ✅ B5 recovered (HTTP $NEW_HTTP)"
        else
            echo "[$(date '+%H:%M:%S')] ❌ Recovery failed — manual intervention needed"
        fi
    fi
    
    sleep 30
done
