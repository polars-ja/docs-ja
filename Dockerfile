FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    graphviz \
    curl \
    build-essential \
    make

# Rustのインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
ENV PATH="/root/.cargo/bin:${PATH}"

# 作業ディレクトリの設定
WORKDIR /app

# Python仮想環境のセットアップ
RUN python3 -m venv .venv
ENV PATH="/app/.venv/bin:$PATH"
ENV VENV="/app/.venv"
ENV VENV_BIN="/app/.venv/bin"

COPY Makefile /app/
COPY Cargo.toml /app/
COPY examples /app/examples
COPY docs /app/docs
COPY crates /app/crates
COPY py-polars /app/py-polars
COPY py-polars/requirements-dev.txt /app/py-polars/
COPY py-polars/requirements-lint.txt /app/py-polars/
COPY py-polars/docs/requirements-docs.txt /app/py-polars/docs/
COPY docs/requirements.txt /app/docs/

# 依存関係のインストールとビルド
SHELL ["/bin/bash", "-c"]
RUN source .venv/bin/activate
RUN make requirements
RUN make build

COPY mkdocs.yml /app/
CMD ["mkdocs", "serve", "-a", "0.0.0.0:8000", "--no-strict"]
