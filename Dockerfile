FROM n8nio/n8n:latest

# --------------------------------------------------------
# 1. INSTALL PYTHON & LIBRARIES
# --------------------------------------------------------
# Switch to root user to install system packages
USER root

# Install Python 3 and PIP (Package Manager)
RUN apk add --update --no-cache python3 py3-pip

# Install the specific libraries for your Password Protected Excel workflow
# --break-system-packages is required on newer Alpine/Python versions
RUN pip3 install msoffcrypto-tool pandas openpyxl --break-system-packages

# --------------------------------------------------------
# 2. YOUR CONFIGURATION (ENV VARS)
# --------------------------------------------------------
ENV NODE_ENV=production
ENV N8N_PORT=5678
ENV N8N_HOST=0.0.0.0
ENV GENERIC_TIMEZONE=Asia/Kolkata
ENV N8N_DEFAULT_BINARY_DATA_MODE=filesystem
ENV N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true

# --------------------------------------------------------
# 3. ENABLE PYTHON IN N8N
# --------------------------------------------------------
# Tell n8n to allow running code nodes in 'internal' mode
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_RUNNERS_MODE=internal
# Point n8n to the python we just installed
ENV N8N_PYTHON_BINARY=/usr/bin/python3

# --------------------------------------------------------
# 4. FINALIZE
# --------------------------------------------------------
# Switch back to the standard 'node' user for security
USER node

EXPOSE 5678
