#!/bin/bash
# AUTO-SLURM — Intelligent COARE Job Submission
# Automatically detects workload and submits optimal job

echo "=== AUTO-SLURM — Intelligent Job Router ==="

# Check B5 status
STATUS=$(curl -s http://localhost:8086/api/self-test 2>/dev/null)
CURRENT_LOAD=$(echo "$STATUS" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('add_tps',0))" 2>/dev/null)

# Auto-select job type based on load
if [ "$CURRENT_LOAD" -gt 60000000 ]; then
    echo "[OPTIMAL] System healthy — submitting benchmark"
    sbatch tools/slurm/benchmark.job
elif [ "$CURRENT_LOAD" -gt 30000000 ]; then
    echo "[GOOD] Moderate load — submitting batch encrypt"
    sbatch tools/slurm/encrypt_batch.job
else
    echo "[LOW] Light load — running self-optimization"
    curl -s -X POST http://localhost:8086/api/self-test > /dev/null
fi

echo "[DONE] Job routed. Check status: squeue"
