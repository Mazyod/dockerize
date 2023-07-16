ARG BASE_IMAGE=python:3.11.4
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND noninteractive

# Create a non-root user and switch to it [1].
# [1] https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user
ARG UID=1000
ARG GID=$UID
RUN groupadd --gid $GID user && \
    useradd --create-home --gid $GID --uid $UID user --no-log-init && \
    chown user /opt/

USER user
WORKDIR /home/user

# Configure Python to print tracebacks on crash [1], and to not buffer stdout and stderr [2].
# [1] https://docs.python.org/3/using/cmdline.html#envvar-PYTHONFAULTHANDLER
# [2] https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUNBUFFERED
ENV PYTHONFAULTHANDLER 1
ENV PYTHONUNBUFFERED 1
ENV PYTHONHASHSEED random

ENV VIRTUAL_ENV /opt/venv
ENV POETRY_VIRTUALENVS_CREATE false
ENV POETRY_NO_INTERACTION 1

ENV PATH "$VIRTUAL_ENV/bin:/home/user/.local/bin:$PATH"

# Set up virtual environment and install poetry
RUN python -m venv $VIRTUAL_ENV \
    && pip install --upgrade pip \
    && pip install --upgrade setuptools wheel pipx \
    && pipx ensurepath \
    && pipx install poetry
