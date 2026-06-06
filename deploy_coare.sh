#!/bin/bash
# ONE-CLICK COARE DEPLOY — Full Autonomous Suite

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  COARE AUTONOMOUS SUITE — ONE-CLICK DEPLOY               ║"
echo "╚══════════════════════════════════════════════════════════╝"

echo ""
echo "[1/5] Starting COARE Environment..."
docker-compose -f docker-compose.coare.yml up -d 2>/dev/null
sleep 5

echo "[2/5] Verifying COARE Suite..."
curl -s http://localhost:9000/health > /dev/null 2>&1 && echo "  ✅ COARE Suite online" || echo "  ⚠️ COARE Suite starting..."

echo "[3/5] Starting Auto-Heal Monitor..."
nohup bash tools/auto_heal.sh > /tmp/coare_heal.log 2>&1 &

echo "[4/5] Starting Auto-Archive..."
nohup python3 tools/ckan/auto_archive.py > /tmp/coare_archive.log 2>&1 &

echo "[5/5] Starting Auto-Scale Monitor..."
nohup bash tools/auto_scale.sh > /tmp/coare_scale.log 2>&1 &

sleep 3
echo ""
echo "=== VERIFICATION ==="
curl -s http://localhost:9000/api/self-test | python3 -c "
import sys,json
d=json.load(sys.stdin)
print(f\"  Score: {d.get('overall_score','?')}/100\")
print(f\"  Status: {d.get('overall_status','?')}\")
print(f\"  Security: {d.get('security',{}).get('score','?')}/100\")
print(f\"  Source: {d.get('att',{}).get('src','?')}\")
" 2>/dev/null || echo "  ⚠️ COARE Suite still initializing..."

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  COARE AUTONOMOUS SUITE — DEPLOYED                       ║"
echo "║  Auto-Heal: ON | Auto-Archive: ON | Auto-Scale: ON       ║"
echo "║  Endpoints: http://localhost:9000/api/self-test          ║"
echo "╚══════════════════════════════════════════════════════════╝"

echo ""
echo "  Optional: B5 FHE Engine (requires separate license)"
echo "  docker run -d --name coare-fhe -p 8086:8086 ghcr.io/primordialomegazero/dost-asti-fhe:latest"
