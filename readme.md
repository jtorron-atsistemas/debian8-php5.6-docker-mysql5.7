# Docker Images para desarrollo
## Entornos antiguos

### Descripción
Recientemente he tenido que trabajar en un proyecto en el que el cliente utilizada un entorno antiguo y no tenía opciones a mejorarlo. Dado que en windows es muy dificil llegar a instalar este entorno he preparado estas imagenes para montar los contenedores Docker en el stack:
- Debian 8
- PHP 5.6
- XDebug 2.2.5
- MySQL 5.7

Esta configuración montará tres contenedores separados para una api, una web y el servidor mysql. Por supuesto no es necesario tener un contenedor para una api y otro para la web, pero prefería montarlo así para que queden todas als posibles necesidades cubiertas.

#### Estructura de imágenes
El sistema montará 3 imágenes con los siguientes tags:
1. *atsistemas:base*: Configuración e instalación de lo necesario para un servidor web con php5 en debian 8 (debian:jessie).
2. *atsistemas:api*: Utiliza la imagen base para agregarle ciertas configuraciones necesarias para la api.
3. *atsistemas:web*: Lo mismo que la anterior (api) pero para la web.

La razón de no utilizar una sola imagen es que la web y la api pueden tener configuraciones diferentes tales como copia de ficheros específicos, diferencias en la configuración del servidor http (apache en este caso), etcétera, pero el base se encarga de la configuración genérica de ambas imágenes.

### Como montarlo
#### Configuración
1. Configurar paths. Abriremos el fichero `docker-compose.yml` y cambiaremos `<path_to_this_folder>` por la ruta de la carpeta donde tengamos almacenados los archivos.
2. Copiar el source. En el path `<path_to_this_folder>/source` se encuentran las carpetas api y web en las que introduciremos el código fuenta de nuestros proyectos
3. Reconfigurar contraseñas y nombre. Abriremos el fichero `docker-compose.yml` dónde se encuentran contenidas las contraseñas de MySQL tanto de root como del usuario de acceso, nombre de la base de datos e incluso los nombres de los contenedores si quereis cambiarlos.
4. Variables de entorno. Algunas variables de entorno ya están establecidas en este fichero, pero podeis agregar aqui las vuestras.

#### Lanzando scripts
He incluido unos scripts de construcción y lanzamiento para mayor comodidad (y para los que no conocieran la sintaxis de Docker y Docker Compose). Todos ellos tienen una versión `.bat` para windows y otra `.sh` para linux/mac.
1. *buildImages*. Este script genera en el motor de Docker las imágenes necesarias para poder montar y correr los contenedores.
2. *composeUp*. Utilizando la configuración del fichero `docker-compose.yml` el sistema lanzará y levantará tres contenedores docker_atsistemas-api_1, docker_atsistemas-web_1 y docker_atsistemas-databases_1 que quedarán usables.

#### Otros scripts
Además de los scripts de montaje, estos otros os ayudarán con el mantenimiento
- *composeStop*. Para los contenedores.
- *composeRm*. Elimina los contenedores.

*IMPORTANTE*: Estos scripts tienen que ser lanzados siempre desde el path donde tengamos todos los archivos, pues se alimentan de los dockerfiles y el docker-compose.yml.

### Volúmenes
El sistema de contenedores tiene configurados ciertos volúmenes de forma que refleja los archivos contenidos en ellos para que vosotros podais acceder a la información habitual sin tener que hacer ssh ni shell a los contenedores.

#### Logs
Las carpetas `api-log` y `client-log` contendrán todos los logs generados por vuestra aplicación, logs de apache, php y otros para poder consultar en cualquier momento.

#### Profiler
Contiene la salida de información de profiling del XDebug

#### Source
Los archivos del código fuente de vuestras aplicaciones. Podeis realizar modificaciones en tiempo real en ellos sin necesidad de reiniciar los contenedores.

#### Data
Contiene los archivos de base de datos y configuración de MySQL. No debeis preocuparos por perder configuracion ni datos al borrar los contenedores, al reiniciarlos seguirán ahí como si no lo hubieseis borrado.

### Consideraciones a tener en cuenta
- Api. La ruta del código en la api (dentro del container) es `/var/www/html`, mientras que el apache va a montar `/var/www/html/public` pues está pensado para frameworks como Laravel que tienen el punto de entrada dentro de la carpeta public.
- Web. La ruta del código es directamente `/var/www/html/public` y el apache monta esa misma ruta. Aunque esto no es necesario en la web, lo hice para mantener la consistencia.

Estos valores de montaje de apache pueden ser modificados en `/apache-default.conf`, mientras que la ruta dónde se copia se monta en el volumen del source, en el fichero `docker-compose.yml`.

### Conectando a XDebug
- API: puerto 9001.
- WEB: puerto 9000.

Este sería el launch.json de VS Code (api):
```javascript
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "XDebug Laravel",
            "type": "php",
            "request": "launch",
            "port": 9001,
            "pathMappings": {
                "/var/www/html": "${workspaceFolder}"
            },
            "ignore": [
                "**/vendor/**/*.php"
            ]
        }
    ]
}
```

Este sería un ejemplo para el launch.json de VS Code (web):
```javascript
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "XDebug Laravel",
            "type": "php",
            "request": "launch",
            "port": 9000,
            "pathMappings": {
                "/var/www/html/public": "${workspaceFolder}"
            },
            "ignore": [
                "**/vendor/**/*.php"
            ]
        }
    ]
}
```

### Conexión externa a MySQL
Podeis conectar cualquier tipo de cliente MySQL utilizando el host localhost y el puerto 33306.