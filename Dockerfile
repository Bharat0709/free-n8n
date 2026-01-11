FROM n8nio/n8n:latest

# --------------------------------------------------------
# 1. INSTALL PYTHON & LIBRARIES (DEBIAN VERSION)
# --------------------------------------------------------
USER root

# Install Python 3 and PIP using apt-get
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install the libraries
# We use --break-system-packages because newer Debian versions manage python externally
RUN pip3 install msoffcrypto-tool pandas openpyxl --break-system-packages

# --------------------------------------------------------
# 2. YOUR CONFIGURATION
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
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_RUNNERS_MODE=internal
ENV N8N_PYTHON_BINARY=/usr/bin/python3

# --------------------------------------------------------
# 4. FINALIZE
# --------------------------------------------------------
USER node

EXPOSE 5678
