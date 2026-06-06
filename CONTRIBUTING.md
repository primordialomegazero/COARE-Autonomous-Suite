
Contributing to COARE Autonomous Suite
Development Setup
bash
git clone https://github.com/primordialomegazero/COARE-Autonomous-Suite
cd COARE-Autonomous-Suite
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
./coare-ai
Docker Development
bash
docker build -t coare-ai:dev .
docker run -d -p 9000:9000 coare-ai:dev
Testing
bash
# Full endpoint test
curl http://localhost:9000/api/status
curl http://localhost:9000/api/ai/assess
curl -X POST http://localhost:9000/api/auto-heal -H "Content-Type: application/json" -d '{}'
Pull Request Guidelines
Fork the repository

Create feature branch

Submit PR with description

All endpoints must maintain 100/100 AI score

License
Apache 2.0 — See LICENSE file
