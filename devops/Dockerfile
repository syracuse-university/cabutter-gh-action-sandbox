FROM python:3.13-slim

RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install git-cliff

WORKDIR /repo

COPY scripts/ /scripts/

RUN chmod +x /scripts/*.bash

ENTRYPOINT ["/scripts/release-workflow.bash"]
