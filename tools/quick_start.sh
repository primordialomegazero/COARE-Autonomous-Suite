#!/bin/bash
echo "COARE Autonomous Suite — Quick Start"
docker pull ghcr.io/primordialomegazero/coare-autonomous-suite:latest
docker run -d -p 8086:8086 -p 9000:9000 --restart unless-stopped ghcr.io/primordialomegazero/coare-autonomous-suite:latest
sleep 3
curl -X POST http://localhost:8086/api/self-test
