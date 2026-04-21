# =============================================================================
# Dockerfile — Web Service (React Frontend)
# =============================================================================
# Multi-stage build:
#   Stage 1 → Install dependencies and build the production bundle
#   Stage 2 → Serve the static files using a lightweight Nginx image
# =============================================================================

# ── Stage 1: Build the React application ──
FROM node:18-alpine AS build
WORKDIR /usr/src/app

# Install dependencies first (layer caching optimization)
COPY package*.json ./
RUN npm ci

# Copy source and build the production bundle
COPY . .
RUN npm run build

# ── Stage 2: Production image using Nginx ──
FROM nginx:1.25-alpine
COPY --from=build /usr/src/app/build /usr/share/nginx/html

# Expose the HTTP port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
