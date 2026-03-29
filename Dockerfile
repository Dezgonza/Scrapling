FROM python:3.12-slim-bookworm

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

COPY pyproject.toml ./

RUN uv sync --no-install-project --all-extras --compile-bytecode

COPY . .

RUN apt-get update && \
    uv run playwright install-deps chromium && \
    uv run playwright install chromium && \
    uv sync --all-extras --compile-bytecode && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8000

ENTRYPOINT ["uv", "run", "uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
