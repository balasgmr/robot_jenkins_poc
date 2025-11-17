FROM jenkins/jenkins:lts

USER root

# Install essential tools
RUN apt-get update && \
    apt-get install -y python3 python3-pip git curl wget unzip

# Install Chrome + ChromeDriver (for UI tests)
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

RUN CHROME_VERSION=$(google-chrome --version | cut -d ' ' -f3 | cut -d. -f1) && \
    wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/${CHROME_VERSION}.0/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && \
    rm /tmp/chromedriver.zip

# Install Python libs & Robot Framework
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Install k6
RUN curl -s https://api.github.com/repos/grafana/k6/releases/latest \
    | grep "browser_download_url.*deb" \
    | cut -d '"' -f 4 \
    | wget -qi - && \
    dpkg -i k6*.deb && rm k6*.deb

USER jenkins
