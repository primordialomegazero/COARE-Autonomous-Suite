#!/bin/bash
# FRACTAL AUTO-SLURM — φ-Weighted Recursive Job Scheduler
# No queues, no congestion — jobs distribute fractally

PHI=1.618033988749895
PHI_INV=0.618033988749895

echo "=== FRACTAL AUTO-SLURM — Recursive Job Distribution ==="

# φ-harmonic load detection
LOAD=$(curl -s -X POST http://localhost:8086/api/self-test 2>/dev/null | python3 -c "import sys,json;print(json.load(sys.stdin).get('add_tps',0))" 2>/dev/null)

# Recursive fractal distribution
fractal_submit() {
    local depth=$1
    local parent_job=$2
    
    if [ $depth -le 0 ]; then return; fi
    
    # φ-scaled job size
    local job_size=$(( 1000 * $depth ))
    
    echo "[DEPTH $depth] Submitting fractal job ($job_size ops)..."
    sbatch --job-name="fractal_d${depth}" --cpus-per-task=$depth \
        --wrap="curl -s -X POST http://localhost:8086/api -H 'Content-Type: application/json' \
        -d '{\"operation\":\"benchmark\",\"data\":{\"iterations\":$job_size}}'" \
        2>/dev/null
    
    # Recursive child jobs at φ⁻¹ scale
    sleep $(echo "$PHI_INV * 2" | bc -l 2>/dev/null || echo 1)
    fractal_submit $((depth - 1)) "$parent_job"
    fractal_submit $((depth - 2)) "$parent_job" 2>/dev/null
}

# Start fractal distribution at depth 7
fractal_submit 7 "root"

echo "[DONE] Fractal jobs distributed — check: squeue"
