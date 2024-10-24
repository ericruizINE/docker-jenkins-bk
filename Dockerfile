FROM jenkins/jenkins:lts-jdk17

ENV JENKINS_URL=http://localhost:8080

USER root

RUN apt-get -y update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv 

# Cambiar permisos de los directorios necesarios
RUN chown -R jenkins:jenkins /var/jenkins_home

USER jenkins