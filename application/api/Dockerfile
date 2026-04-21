# =============================================================================
# Dockerfile — API Service (Express.js + MongoDB)
# =============================================================================
# Multi-stage build for a lightweight, secure production image.
# Stage 1: Install dependencies
# Stage 2: Copy application code and run as non-root user
# =============================================================================

# ── Stage 1: Install dependencies ──
FROM node:18-alpine AS dependencies
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci --only=production

# ── Stage 2: Production image ──
FROM node:18-alpine
WORKDIR /usr/src/app

# Copy installed node_modules from the dependencies stage
COPY --from=dependencies /usr/src/app/node_modules ./node_modules

# Copy application source code
COPY . .

# Run as non-root user for security
USER node

# Expose the API port
EXPOSE 8080

# Start the API server
CMD ["node", "server.js"]
