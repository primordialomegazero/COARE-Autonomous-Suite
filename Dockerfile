FROM ubuntu:22.04

# Labels
LABEL org.opencontainers.image.title="COARE Autonomous Suite"
LABEL org.opencontainers.image.description="AI-Powered HPC Management for DOST-ASTI COARE"
LABEL org.opencontainers.image.version="1.0.0-enterprise"
LABEL org.opencontainers.image.authors="Dan Joseph M. Fernandez"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.source="https://github.com/primordialomegazero/COARE-Autonomous-Suite"

# Dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 libjsoncpp25 libpq5 libmariadb3 curl python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Binary
COPY build/coare-ai .

# Tools
COPY tools/ ./tools/

# Security: non-root user
RUN groupadd -r coare && useradd -r -g coare coare \
    && chown -R coare:coare /app \
    && chmod +x tools/*.sh tools/*.py 2>/dev/null

USER coare

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:9000/health || exit 1

EXPOSE 9000

ENTRYPOINT ["./coare-ai"]
