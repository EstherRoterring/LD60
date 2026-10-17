FROM oven/bun:canary

WORKDIR /app

COPY package.json .

# Mount bun.lock file and install dependencies with frozen lock file
RUN --mount=type=bind,source=bun.lock,target=/app/bun.lock \
    bun install --frozen-lockfile

# Mount source files and build output
RUN --mount=type=bind,source=src,target=/app/src \
    --mount=type=bind,source=tsconfig.json,target=/app/tsconfig.json \
    bun build ./src/index.ts --target=bun --outdir=dist

# Expose port 3000
EXPOSE 3000

# Start server
CMD ["bun", "dist/index.js"]
