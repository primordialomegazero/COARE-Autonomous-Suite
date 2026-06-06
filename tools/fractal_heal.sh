#!/bin/bash
# FRACTAL AUTO-HEAL — Recursive Self-Repair System
# Each heal level spawns deeper verification

PHI=1.618033988749895

heal_level() {
    local depth=$1
    
    HTTP=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8086/api 2>/dev/null)
    
    if [ "$HTTP" != "200" ]; then
        echo "[$(date '+%H:%M:%S')] [DEPTH $depth] ⚠️ Failure detected — Healing..."
        docker restart coare-b5 2>/dev/null
        sleep $(( depth * 2 ))
        
        # Recursive deeper check
        if [ $depth -gt 1 ]; then
            heal_level $((depth - 1))
        fi
    else
        echo "[$(date '+%H:%M:%S')] [DEPTH $depth] ✅ Healthy"
    fi
}

while true; do
    heal_level 5
    sleep 30
done
