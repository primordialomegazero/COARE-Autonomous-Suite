#!/bin/bash
# FRACTAL AUTO-SCALE — φ-Harmonic Dynamic Scaling
# Scales fractally — no single point of congestion

PHI=1.618033988749895
PHI_INV=0.618033988749895

declare -a INSTANCES=()
BASE_PORT=8086

scale_fractal() {
    local depth=$1
    
    if [ $depth -le 0 ]; then return; fi
    
    local port=$((BASE_PORT + depth))
    
    # Check if instance exists
    if ! curl -s -o /dev/null -w "%{http_code}" http://localhost:$port/api 2>/dev/null | grep -q 200; then
        echo "[SCALE] Spawning fractal instance at depth $depth (port $port)..."
        docker run -d --name "coare-b5-d$depth" --restart unless-stopped \
            -p $port:8086 ghcr.io/primordialomegazero/dost-asti-fhe:latest 2>/dev/null
    fi
    
    # φ-scaled recursive spawn
    sleep $(echo "$PHI_INV * 3" | bc -l 2>/dev/null || echo 2)
    scale_fractal $((depth - 1))
    scale_fractal $((depth - 2)) 2>/dev/null
}

echo "=== FRACTAL AUTO-SCALE — φ-Harmonic Expansion ==="
scale_fractal 5

echo "[DONE] Fractal instances deployed"
docker ps --filter "name=coare-b5" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
