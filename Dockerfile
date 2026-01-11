# Start with standard Node on Alpine Linux
FROM node:20-alpine

# 1. Install System Python & Build Tools
USER root
RUN apk add --update --no-cache python3 py3-pip build-base

# 2. Create a Virtual Environment (Crucial Step)
# We create a specific folder for Python to live in
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
# Add this venv to the PATH so commands like 'pip' use it automatically
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# 3. Install Your Libraries INSIDE the Virtual Environment
# Since PATH is updated, this installs into /opt/venv, not global system
RUN pip install --upgrade pip && \
    pip install msoffcrypto-tool pandas openpyxl

# 4. Install n8n globally
RUN npm install -g n8n

# 5. Fix Permissions for Render
# We need to make sure the 'node' user owns the n8n folder AND the python folder
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n && \
    chown -R node:node /opt/venv

# 6. Configuration
USER node
ENV NODE_ENV=production
ENV N8N_PORT=5678
ENV N8N_HOST=0.0.0.0
ENV GENERIC_TIMEZONE=Asia/Kolkata

# 7. Enable Python Runner
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_RUNNERS_MODE=internal
# POINT N8N TO THE VIRTUAL ENV PYTHON, NOT SYSTEM PYTHON
ENV N8N_PYTHON_BINARY=/opt/venv/bin/python

EXPOSE 5678
CMD ["n8n"]
