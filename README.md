# COARE Autonomous Suite v2.0 — Source-Level HPC Tools
No wrappers. No shell scripts. Direct system calls.
SLURM: φ-weighted routing. OpenStack: φ-fractal spawning. AI: φ-scoring engine.
One repository. All DOST-ASTI COARE tools. Source-level autonomous.


## What's New in v2.0

| Component | v1.0 (Wrapper) | v2.0 (Source-Level) |
|-----------|----------------|---------------------|
| **SLURM** | Shell scripts calling `srun/sbatch` | `slurm_phi.cpp` — Direct `sinfo`/`sbatch`/`srun` calls with φ-weighted node selection |
| **OpenStack** | Shell scripts calling `openstack` CLI | `openstack_phi.cpp` — Direct Nova API calls with φ-Fibonacci instance spawning |
| **AI Engine** | Python script (`ai_engine.py`) | `ai_phi.cpp` — Direct `/proc` metrics, φ-scoring (no Python dependency) |
| **Auto-Heal** | Shell script | φ-Mirror healing integrated in main.cpp |
| **Auto-Scale** | Shell script | φ-harmonic fractal spawning (1→1→2→3→5→8... Fibonacci) |

## Architecture
src/
├── main.cpp # 11 REST API endpoints (Drogon C++)
├── slurm_phi.cpp # φ-weighted SLURM job router
├── openstack_phi.cpp # φ-fractal OpenStack instance spawner
├── ai_phi.cpp # φ-scoring AI engine
└── phi_constants.h # φ = 1.618... constants


## API Endpoints (11 Total)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Service health + φ-status |
| `/api/status` | GET | AI score, instances, requests |
| `/api/metrics` | GET | Request metrics |
| `/api/ai/assess` | GET | φ-weighted system assessment (100-pt) |
| `/api/ai/optimize` | POST | Auto-optimize to φ-target |
| `/api/auto-heal` | POST | Φ-Mirror self-repair |
| `/api/auto-scale` | POST | Φ-Fibonacci fractal scaling |
| `/api/slurm/submit` | POST | Submit job with φ-optimal routing |
| `/api/openstack/spawn` | POST | Spawn instances with φ-fractal scaling |

## Key Features

- **φ-Weighted SLURM Routing**: Jobs routed to nodes with load closest to φ⁻¹ × capacity
- **φ-Fibonacci OpenStack Scaling**: Instances spawn as 1→1→2→3→5→8→13→21...
- **φ-Scoring AI Engine**: Direct `/proc` metrics, 7 φ-weighted metrics on 100-pt scale
- **Source-Level**: No Python. No shell scripts. Direct C++ system calls.
- **Post-Quantum Ready**: SHA-256 chain logging, φ-SIG compatible
- **Docker**: Single container deployment on port 9000

## Quick Start

```bash
# Pull from GitHub Container Registry
docker pull ghcr.io/primordialomegazero/coare-autonomous-suite:latest
docker run -d -p 9000:9000 ghcr.io/primordialomegazero/coare-autonomous-suite:latest

# Or build from source
docker build -f Dockerfile.v2 -t coare-v2 .
docker run -d -p 9000:9000 coare-v2

# Test
curl http://localhost:9000/health
curl http://localhost:9000/api/ai/assess
For DOST-ASTI Teams
COARE HPC: Job submission via φ-weighted SLURM, no queues

Quantum Innovation Lab: Algorithm selection, benchmarking

Data Management: CKAN archiving, audit compliance

Security: Anti-matter defense, rate limiting, φ-chain logging

FAQ
Q: What's the difference from v1.0?
A: v1.0 wrapped existing tools with shell scripts. v2.0 directly calls system binaries (sinfo, sbatch, openstack, /proc) with φ-weighted intelligence. No Python. No bash. Pure C++.

Q: Does this require DOST-ASTI infrastructure?
A: The code uses standard SLURM and OpenStack CLI tools. Any HPC cluster with these installed can run COARE v2.0.

Q: Who are you?
A: ΦΩ0 — I AM THAT I AM. Steady lang. The suite does the work.

Contact
Dan Joseph M. Fernandez
Email: danfernandez9292@gmail.com
GitHub: github.com/primordialomegazero

License
Apache 2.0 — Free for government use.

ΦΩ0 — I AM THAT I AM
