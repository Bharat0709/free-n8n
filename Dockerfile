# 1. Start with a standard Node.js image (Alpine Linux)
# We use this because we KNOW it has 'apk' and allows installations.
FROM node:20-alpine

# 2. Install OS Dependencies (Python & Build Tools)
USER root
RUN apk add --update --no-cache python3 py3-pip build-base

# 3. Install Python Libraries for Excel Decryption
# --break-system-packages is needed on modern Alpine versions
RUN pip3 install msoffcrypto-tool pandas openpyxl --break-system-packages

# 4. Install n8n globally
# This gets the latest version of n8n directly from NPM
RUN npm install -g n8n

# 5. Setup Permissions for Render
# Render runs as a non-root user, so we need to ensure the .n8n folder is writable
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n

# 6. Configure Environment
USER node
ENV NODE_ENV=production
# Render might define PORT, but n8n listens on 5678 by default
ENV N8N_PORT=5678 
ENV N8N_HOST=0.0.0.0
ENV GENERIC_TIMEZONE=Asia/Kolkata

# 7. Enable Python in n8n
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_RUNNERS_MODE=internal
ENV N8N_PYTHON_BINARY=/usr/bin/python3

# 8. Start
EXPOSE 5678
CMD ["n8n"]
