
# INGRESS
ENLACES:
- https://desarrollofront.medium.com/ingress-en-kubernetes-desmitificado-qu%C3%A9-lo-diferencia-de-un-nodeport-o-un-loadbalancer-b0cf060a6f8a 
- https://www.youtube.com/watch?v=GhZi4DxaxxE

En Kubernetes existen 4 tipos de Servicios:

#### **ClusterIP (default)**: 
Proporciona una IP estable a un grupo de PODS. (target=app, port=donde se expone el svc)
	![[Pasted image 20211117155855.png]]

#### **NodePort**: 
Kubernetes reserve un puerto en todos sus Nodos (el mismo puerto en todos ellos) y dirige todas las conexiones entrantes a los Pods que sean parte del servicio. (target=app, port=svc y nodePort=que puerto del cluster se expone al exterior)
	![[Pasted image 20211117160003.png]]
		Desventajas:
		- Nos obliga a tener un solo svc por puerto
		- IP de los nodos pueden cambiar con lo cual hay que monitorizarlos por si cambiasen
		- Puertos ext limitados.
		
#### **LoadBalancer**:
LB externo al cluster que nos proporciona una IP para acceder a nuestros svcs. Kubernetes se sincroniza con la API del proveedor Cloud que estemos usando. Por cada servicio que creamos se aprovisiona un balanceador de carga diferente y si lo eliminamos se elimina su LB asociado. 
	![[Pasted image 20211117160407.png]]
	
#### **Ingress**: 
**Ingress vs. LB:**
- Por cada svc LB se necesita aprovisionar un LB (sobrecoste)
- Cada LB necesita 1 IP. Con Ingress solo hay 1 IP para todo. 
- Ingress opera en la 7a capa de red (*MODELO OSI* - https://en.wikipedia.org/wiki/OSI_model)

Ingress, al contrario que los otros svcs de K8s, necesita tener un **CONTROLADOR**: "*POD o conjunto de PODs que se ejecutan en el cluster para asegurarse de que el tráfico entrante se administra como nosotros hayamos especificado*" (TRAEFIK, NGINX, KONG,...)

**Componentes de Ingress:**
- Controlador
- Configuración de Ingress (objeto de k8s para describir donde dirigir el trafico entrante)

**Cómo funciona Ingress:**
![[Pasted image 20211117161725.png]]

![[ingress.svg]]
![[ingress_2.svg]]



# VIRTUAL HOSTs

1. Queremos acceder a una web (web2, por ejemplo) pero tenemos varias webs alojadas en el mismo servidor (web1, web2. web3) y accedemos a ellas usando el mismo puerto y la misma IP.

	![[virtualHosts.svg]]

2. Para que el usuario pueda acceder a **web2/index.html**, la ruta a la que accederá será así:

		http://1.1.1.1:80/docroot/web2/index.html

	Siendo:
	- http: schema
	- 1.1.1.1: IP del servidor
	- :80: Puerto
	- /docroot: Path
	- /web2/index.html: Recurso al que queremos acceder. Si quisieramos acceder a otra web u otro recurso, tendríamos que modificarlo.

	* Para el  usuario, la ruta a la web está bajo un DNS (por ejemplo; www.example.com)
	* De cara al usuario esto es transparente, ya que se encunetra enmascarado enrutado de un Host > VirtualHost

3. La configuración del Host sería así:
	HOST: www.example.com 
	Docroot: /docroot/web2/
	Index: index.html

4. Si quisieramos montar un virtualHost en vez de un Host, la configuración sería tal que:
	VHOST
	  HOST: www.example.com
	  ReverseProxy*
	  Index: index.html
	
	
## Reverse Proxy
https://www.cloudflare.com/es-es/learning/cdn/glossary/reverse-proxy/ 

#### 1. Proxy / proxy server / forward proxy
Actúan de forma similar a un middleman. Es un servidor, que se sitúa entre los clientes y el servidor final, que intercepta las requests de los clientes y se las comunica al servidor final correspondiente.

![[Pasted image 20211117122948.png]]

#### 2. Reverse Proxy
La diferencia entre un proxy normal y un reverse proxy es:
- Un **proxy** se sitúa en la parte del cliente y asegura que ningún servidor de origen se comunique directamente con un cliente específico.
- Un **reverse proxy** se sitúa en la parte de los servidores de origen y se asegura de que ningún cliente se comunique nunca directamente con el servidor de origen.

![[Pasted image 20211117122919.png]]

Algunos de los beneficios de reverse proxy:
- **Load Balancing**
- **Protección frente ataques**; la web/servicio nunca necesita revelar la IP del servidor de origen. 
- **Global Server Load Balancing (GSLB)**; load balancing pero en servidores de distintas partes del mundo. En este caso, reverse proxy redirige la req del cliente al servidor más cercano a su posicion geografica.
- **SSL Encryption (o TLS)**