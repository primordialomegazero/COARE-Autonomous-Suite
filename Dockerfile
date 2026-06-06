FROM ubuntu:22.04
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 libjsoncpp25 libpq5 libmariadb3 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY build/coare-ai .
COPY tools/ ./tools/
RUN groupadd -r coare && useradd -r -g coare coare && chown -R coare:coare /app
USER coare
EXPOSE 9000
ENTRYPOINT ["./coare-ai"]
