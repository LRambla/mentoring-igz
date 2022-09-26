# mentoring-igz
Mentoring with Alejandro Aceituna


Recursos de aprendizaje
https://killercoda.com/playgrounds/scenario/kubernetes

https://killercoda.com/killer-shell-cka



# Apuntes

## 20222009

### IaC:
 
 - Inmutabilidad -> buenas practicas (si queremos hacer cualquier cosa como por ejemplo subir la versión de python => relanzamos la instancia entera en vez de cambiarlo a mano desde dentro del contenedor. Es + barato y fiable)
   - scripts a mano
   - comandos de forma manual
   - requests == 1.0 -> 2.0
   - server
   - docker.io/imagen:tag -> docker.io/konstellation/kdl-py:0.1.0
   - instacia:1.0 -> instacia:2.0
 
 - Idempotencia 
   - la idempotencia es la propiedad para realizar una acción determinada varias veces y aun así conseguir el mismo resultado que se obtendría si se realizase una sola vez.
   - apt install nginx && apt install nginx -> solamente va a instalar nginx 1 vez

#### Ansible:
   - Herramienta para configurar servidores
   - SSH
   - no es imperativo (apt install nginx) sino declarativo (apt: name=nginx state=present)
   - ansible primero consulta si nginx está presente
     - python, usando apt por debajo, consulta (apt info nginx | grep "is_installed") si lo está no hace nada
     - si no lo está -> apt install nginx
   - ansible por tanto es una herramienta perfecta para configurar servidores
   - también permite gestionar infraestructura
     - crear instancias
     - crear buckets
     - ...
 
#### Terraform:
   - Herramienta de IaC que se usa principalmente para desplegar infraestructura (por ejemplo, se pueden levantar servicios de AWS con TF de forma simplificada. Si queremos levantar una instancia de EC2, no es necesario crear todos los servicios necesarios antes de la instancia sino que con TF se crean automáticamente)
- Introduce un concepto interesante, el state -> tfstate (json) básicamente guarda el ultimo estado de la ultima ejecución de TF:
 
     1. En la primera ejecución:
 
       - El tfstate no existe -> el tfstate se crea (local, en s3, en gcs, azure blob storage, Terraform Cloud, etc)
       - almacena una declaración (JSON) de la infraestructura tal como estaba en el momento en que Terraform fue ejecutado por última vez.
       - esto podría considerarse "un snapshot" del estado de la infraestructura
 
     2. En la segunda ejecución…N ejecución:
       - Terraform se baja el tfstate
       - hace llamadas a la API (p.e AWS) y compara el estado actual con el estado definido en el tfstate anterior
       - Terraform consulta los ficheros .tf (escritos en HCL Hashichorp Configuration Language) y hace un 3-way merge entre:
         - estado actual
         - tfstate
         - ficheros .tf
       - si hay diferencias, Terraform aplica los cambios necesarios (elimina todo segun el orden del provider -> lo levanta de nuevo -> actualiza el TFSTATE)
 
   - Terraform establece el orden en el que los elementos de la infraestructura han de ser creados para que sea posible tener la "foto final" definida en los .tf
     - Declaro los siguientes elementos, en este mismo orden, en un fichero .tf
       - Obtener los metadatos de una AMI
       - crear un security group
       - crear una instancia
       - crear una vpc
   - Terraform se apoya en "plugins" (wrappers de las apis de != empresas tipo AWS, Google, K8s,etc) que en la jerga Terraform se llaman providers 
 
 
   - /etc/init.d/ansible.sh -> llamar a ansible-playbook
