FROM jenkins/jenkins:lts-jdk17

ENV JENKINS_URL=http://localhost:8080

USER root

RUN apt-get -y update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv 

# Cambiar permisos de los directorios necesarios
RUN chown -R jenkins:jenkins /var/jenkins_home

#Instalar la version mas actual de chrome
RUN apt-get update && apt-get install -y wget gnupg
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update && apt-get install -y google-chrome-stable

USER jenkins