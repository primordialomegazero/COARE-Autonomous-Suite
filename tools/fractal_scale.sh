#!/bin/bash
# FRACTAL AUTO-SCALE — φ-Harmonic COARE Instance Spawning
PHI=1.618033988749895
PHI_INV=0.618033988749895
BASE_PORT=9000
IMAGE="ghcr.io/primordialomegazero/coare-autonomous-suite:latest"

scale_fractal() {
    local depth=$1
    if [ $depth -le 0 ]; then return; fi
    local port=$((BASE_PORT + depth))
    
    if ! curl -s -o /dev/null -w "%{http_code}" http://localhost:$port/api/status 2>/dev/null | grep -q 200; then
        echo "[SCALE] Spawning COARE instance at depth $depth (port $port)..."
        docker run -d --name "coare-d$depth" --restart unless-stopped -p $port:9000 $IMAGE 2>/dev/null
    fi
    
    sleep $(echo "$PHI_INV * 2" | bc -l 2>/dev/null || echo 1)
    scale_fractal $((depth - 1))
}

echo "=== FRACTAL COARE SCALE — φ-Harmonic Expansion ==="
scale_fractal 5
echo "[DONE] COARE fractal mesh deployed"
docker ps --filter "name=coare-d" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
