# docker-jenkins-bk
[Jenkins](https://jenkins.io/) sobre [Docker](https://www.docker.com/). Se incluye la instalación de `Python` y restaurar el volumen ya creado.

## Contenido

- ⚙️ | [Pre requisitos](#pre-requisitos)
- 📄 | [Archivos a tener en cuenta](#archivos-a-tener-en-cuenta)
- 🏃 | [Correr el ambiente](#correr-el-ambiente)
- 🔨 | [Como usar el ambiente](#como-usar-el-ambiente)
- 📋 | [Notas](#notas)

## Pre requisitos

- Docker instalado
- Git instalado
- Cuenta de Github
- Respaldos de imagen, contenedor y volumen

Este proyecto contiene los archivos de configuración necesarios para poder arrancar un contenedor previamente creado en `Docker` de `Jenkins` con el respaldo de una imagen y el volumen, por lo que es necesario que se tenga instalado `Docker`:

```
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo apt install docker-compose
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

Nuestro directorio de trabajo por defecto será el descargado, y por consecuente será nuestra referencia para la ejecución de los comandos necesarios y donde se deben colocar los archivos de respaldo.

Se recomienda que se detenga el contenedor para generar el respaldo, los comandos para generar respaldo del docker son:

- Imagen 
```
docker save -o jenkins.tar jenkins
```
- Contenedor 
```
docker export -o jenkins_241024.tar jenkinsPruebasRoot
```
- Volumen
```
docker run --rm --volumes-from a4e354aeb5e3 -v $(pwd):/backup jenkins/jenkins:lts-jdk17 bash -c "cd /var/jenkins_home && tar cvf /backup/jenkinsvol.tar ."
```
Los comandos para importar el respaldo del docker son, posicionandose donde se encuentra cada archivo:

- Imagen 
```
docker load -i jenkins.tar
```
```
docker tag 7bf0dfc06ae6 jenkins/jenkins:lts-jdk17
```
- Contenedor 
```
docker import jenkins.tar jenkins/jenkins:lts-jdk17
```
- Volumen
```
docker volume create volumenJenkinsPruebas
```
```
docker run --rm --user root -v volumenJenkinsPruebas:/recover -v $(pwd):/var/jenkins_home jenkins/jenkins:lts-jdk17 /bin/bash -c "cd /recover && tar xvf /var/jenkins_home/jenkinsvol.tar"
```
## Archivos a tener en cuenta
- Dockerfile - Es nuestra imagen de referencia y la configuración existente de nuestra imagen y volumen importado.
- docker-compose.yml - Es una herramienta que nos permite definir y correr el contenedor con las importaciones.

## Correr el ambiente
1. Clonar el repositorio:
```
$ git clone git@github.com:SAEST/docker-jenkins-bk.git
```

2. Posicionados en la carpeta del proyecto corremos el siguiente comando, para construir la imagen:
```
$ docker-compose build
```

3. Esperamos a que termine de correr el proceso, nos mostrará el siguiente output
```
Building master
[+] Building 22.4s (7/7) FINISHED                                                                        docker:default
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 506B                                                                               0.0s
 => [internal] load metadata for docker.io/jenkins/jenkins:lts-jdk17                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [1/3] FROM docker.io/jenkins/jenkins:lts-jdk17                                                                 0.2s
 => [2/3] RUN apt-get -y update && apt-get install -y     python3     python3-pip     python3-venv                20.7s
 => [3/3] RUN chown -R jenkins:jenkins /var/jenkins_home                                                           0.3s
 => exporting to image                                                                                             1.1s
 => => exporting layers                                                                                            1.1s
 => => writing image sha256:25440cd22ff55df8204f037ed38fd3eb6b168247bc8c22208b5e49fb38aa6c6e                       0.0s
 => => naming to docker.io/jenkins/jenkins:lts-jdk17                                                               0.0s
```

4. Para arrancar el contendor Jenkins, ejecutar el siguiente comando:
```
$ docker-compose up -d
```
-output:
```
root@P24-8KQMDY3:/docker-jenkins-bk# docker-compose up -d
Creating network "jenkinsPruebasRoot_default" with the default driver
Creating volume "jenkinsPruebasRoot_jenkins_home" with default driver
Creating docker-jenkinsPruebasRoot ... done
```
5. Acceder a Jenkins con un navegador a [Localhost](http://localhost:8080/login?from=%2F)

## Notas
- Si se necesita instalar algo adicional en el contenedor, habrá que ponerlo en `docker-compose.yml` para mantener la consistencia en el despliegue y mantenimiento.
- Los siguientes comandos son de ayuda para el manejo de contenedores:

### Muestra una lista de los contenedores y tamaño en disco
```
docker ps -as
```
### Iniciar o parar contenedor
```
docker start jenkinsPruebasRoot
docker stop jenkinsPruebasRoot
```
### 
``` Borrar contenedor
docker rm container ID_CONTENEDOR
```
### Listar imagenes de dockers
```
docker image ls
```
### borrar imagen creada
```
docker image rm jenkins
```
### Listar volumenes (data)
```
docker volume ls
```
### Borrar volumen creado
```
docker volume rm dockerID_IMAGE
```
### Elimina todos los contenedores detenidos, todas las redes no utilizadas por los contenedores, todas las imágenes colgadas y toda la caché de construcción.
```
docker system prune
```
### Resumen de contenedores, volumenes, buils y cache
```
docker system df
```

---

Tags: devops, docker, jenkins, python
