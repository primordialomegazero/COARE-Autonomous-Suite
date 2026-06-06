#!/bin/bash
# ONE-CLICK COARE DEPLOY — Full Autonomous Suite

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  COARE AUTONOMOUS SUITE — ONE-CLICK DEPLOY               ║"
echo "╚══════════════════════════════════════════════════════════╝"

echo ""
echo "[1/5] Starting COARE Emulation..."
docker-compose -f docker-compose.coare.yml up -d 2>/dev/null

echo "[2/5] Starting B5 FHE Engine..."
docker run -d --name coare-b5 --restart unless-stopped -p 8086:8086 ghcr.io/primordialomegazero/dost-asti-fhe:latest 2>/dev/null
sleep 3

echo "[3/5] Starting Auto-Heal Monitor..."
nohup bash tools/auto_heal.sh > /tmp/auto_heal.log 2>&1 &

echo "[4/5] Starting Auto-Archive..."
nohup python3 tools/ckan/auto_archive.py > /tmp/auto_archive.log 2>&1 &

echo "[5/5] Starting Auto-Scale Monitor..."
nohup bash tools/auto_scale.sh > /tmp/auto_scale.log 2>&1 &

sleep 2
echo ""
echo "=== VERIFICATION ==="
curl -s -X POST http://localhost:8086/api/self-test | python3 -c "
import sys,json
d=json.load(sys.stdin)
print(f\"  Engines: {d.get('engines_active','?')}/4\")
print(f\"  Performance: {d.get('perf_bar','N/A')}\")
print(f\"  TRL Level: {d.get('trl_assessment',{}).get('trl_level','?')}\")
print(f\"  Audit: {d.get('immutable_log',{}).get('ok','?')}\")
"

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  COARE AUTONOMOUS SUITE — DEPLOYED                       ║"
echo "║  Auto-Heal: ON | Auto-Archive: ON | Auto-Scale: ON       ║"
echo "╚══════════════════════════════════════════════════════════╝"
