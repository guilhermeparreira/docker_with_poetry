FROM python:3.11.5-slim-bookworm AS builder

# Install system dependencies
RUN apt-get update \
    && apt-get install -y \
    # deps for installing poetry
    curl \
    && rm -rf /var/lib/apt/lists/*

ARG dependecies

ENV PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  # Poetry's configuration:
  POETRY_NO_INTERACTION=1 \
  POETRY_VIRTUALENVS_CREATE=false \
  POETRY_CACHE_DIR='/var/cache/pypoetry' \
  POETRY_HOME='/usr/local' \
  POETRY_VERSION=1.8.2

# Install Poetry:
RUN curl -sSL https://install.python-poetry.org | python3 -

# Set Poetry on PATH -> this way poetry command can be executed directly
ENV PATH="${PATH}:/root/.poetry/bin"

# Copy only requirements to cache them in docker layer
WORKDIR /code
COPY poetry.lock pyproject.toml /code/

# Stage 2: Production stage
FROM builder AS production

# Project initialization:
RUN poetry install $dependecies --no-interaction --no-ansi

# Creating folders, and files for a project:
COPY . /code
