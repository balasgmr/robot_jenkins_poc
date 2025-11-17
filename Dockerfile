FROM jenkins/jenkins:lts

USER root

# Install dependencies and Docker CLI
RUN apt-get update && \
    apt-get install -y \
        python3 python3-venv python3-pip \
        chromium chromium-driver \
        curl gnupg software-properties-common \
        ca-certificates apt-transport-https && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian bookworm stable" \
        > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# Install k6
RUN curl -s https://dl.k6.io/key.gpg | apt-key add - && \
    echo "deb https://dl.k6.io/deb stable main" \
        > /etc/apt/sources.list.d/k6.list && \
    apt-get update && \
    apt-get install -y k6 && \
    rm -rf /var/lib/apt/lists/*

# Allow Jenkins to access docker.sock
RUN usermod -aG root jenkins

USER jenkins
