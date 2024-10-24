# docker-jenkins-bk
[Jenkins](https://jenkins.io/) sobre [Docker](https://www.docker.com/). Se incluye la instalación de Python y restaurar el volumen ya creado.

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

Este proyecto contiene los archivos de configuración necesarios para poder arrancar un contenedor de Docker con Jenkins con el respaldo de una imagen y el volumen, la cual contiene un usuario administrador y los plugins necesarios para el pipeline del proyecto de automatización. 

Nuestro directorio de trabajo por defecto será el descargado, y por consecuente será nuestra referencia para la ejecución de los comandos necesarios y donde se deben colocar los archivos de respaldo.

## Archivos a tener en cuenta
- Dockerfile - Es nuestra imagen de referencia y la configuración existente de nuestra imagen y volumen respaldado.
- docker-compose.yml - Es una herramienta que nos permite definir y correr el contenedor respaldado.
```
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo apt install docker-compose
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```


**Referencias:** 📚
- [Docker](https://www.docker.com/)
- [Docker compose](https://docs.docker.com/compose/)

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

4. Para arrancar Jenkins, ejecutar el siguiente comando:
```
$ docker-compose up -d
```
-output:
```
root@P24-8KQMDY3:/docker-jenkins# docker-compose up -d
Creating network "docker-jenkins_default" with the default driver
Creating volume "docker-jenkins_jenkins_home2" with default driver
Creating docker-jenkins_master_1 ... done
```
5. Acceder a Jenkins con un navegador a [Localhost](http://localhost:8080/login?from=%2F)

La contraseña del usuario `admin` de Jenkins es: 
```
$ password
```
## Como usar el ambiente

Al construir la imagen del `docker-compose.yml` contiene los plugins necesarios ademas de `Blueocean` y `Allure Reports` por lo que es necesario realizar la configuracion del Allure Commandline:

- Ir a `Administrar Jenkins - Tools` http://localhost:8080/manage/configureTools/
- Ubicarnos en Allure Commandline
- Añadir Allure Commandline
    ```
    Nombre: ALLUREHOME
    Version: 2.30.0
    Extraer *.zip/*.tar.gz: https://github.com/allure-framework/allure2/releases/download/2.30.0/allure-2.30.0.zip
    ```
- Save - Guardamos la configuración

Al arrancar el docker-jenkins, se crea el Pipeline `Publicacion` en automático asi como se construye por primera vez para validar las configuraciones, por lo que puede mandar error al no tener `Allure Commandline` (regresar al paso anterior).

Una vez configurada correctamente, se puede construir el Pipeline sin problemas desde `Blue Ocean` y validar los resultados en el reporte de `Allure`.

Arrancar ambiente
```
$ docker compose up --detach 
```

Detener ambiete
```
$ docker compose down
```

## Notas
- Si se necesita instalar algo adicional en el contenedor, habrá que ponerlo en `docker-compose.yml` para mantener la consistencia en el despliegue y mantenimiento.
- Los siguientes comandos son de ayuda para el manejo de contenedores:

### Muestra una lista de los contenedores y tamaño en disco
```
docker ps -as
```
### Iniciar o parar contenedor
```
docker stop docker-jenkins_master_1
docker stop docker-jenkins_master_1
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
docker volume rm docker-jenkins_jenkins_home
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
