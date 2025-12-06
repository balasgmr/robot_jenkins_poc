FROM jenkins/jenkins:lts

USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y python3 python3-venv python3-pip git curl wget unzip xvfb \
                       libnss3 libgconf-2-4 fonts-liberation libxss1 libappindicator3-1 xdg-utils

# Add Python virtual environment
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install -r /tmp/requirements.txt

# Add venv to PATH
ENV PATH="/opt/venv/bin:$PATH"

USER jenkins
