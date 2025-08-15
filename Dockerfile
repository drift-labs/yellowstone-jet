FROM rust:1.87.0 AS builder
WORKDIR /app

ENV CARGO_DRIFT_FFI_PATH="/usr/local/lib"

RUN apt-get update && \
    apt-get install -y protobuf-compiler jq && \
    rustup component add rustfmt

COPY . .
RUN cargo build --release

# ---- Runtime Stage ----
FROM debian:bookworm-slim
WORKDIR /app

RUN apt-get update && apt-get install -y ca-certificates

COPY --from=builder /app/target/release/jet /app/jet

ENTRYPOINT ["./jet"]
    