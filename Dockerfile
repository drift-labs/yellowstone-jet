# ---- Build Stage ----
FROM rust:1.87.0 AS builder
WORKDIR /app

ENV CARGO_DRIFT_FFI_PATH="/usr/local/lib"

# 1. Cache dependencies first
RUN apt-get update && apt-get install jq -y && rustup component add rustfmt
COPY . .
RUN cargo build --release

# ---- Runtime Stage ----
FROM debian:bookworm-slim
WORKDIR /app

RUN apt-get update && apt-get install -y ca-certificates

# Copy the binary and library
COPY --from=builder /app/target/release/jet /app/jet

ENTRYPOINT ["./jet"] 