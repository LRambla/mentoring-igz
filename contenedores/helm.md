# HELM

Gestor para empaquetar recursos que luego se van a desplegar en K8s. Puedes crear plantillas, controlar el ciclo de vida de la app, etc.

## Conceptos
- **Chart** = paquete formado por yamls con una estructura especifica. (~ docker image)
- **Config** = configuración de un svc/app/etc en `values.yml` 
- **Release** = Chart de helm desplegado en k8s ( chart - 1 paquete- = 1 release )
- **Repository** (de charts)

## Primeros pasos

Cuando ejecutamos `helm create myChart`, nos crea la siguiente estructura:

```
myChart/
	Chart.yaml		# Chart info
	LICENSE				
	README.md			
	crds/
	values.yaml		# Default values for variables
	charts/			# Other charts (dependencies of myChart; tgz)
	templates/		# To generate k8s manifest files (w/values)
		NOTES.txt	# (OPTIONAL) Short usage notes
```

* Dentro de `charts/` se incluyen las dependencias de `myChart` con otro chart. Esas dependencias son los charts empaquetados en formato tgz.

* Antes existia un fichero `requirements.yaml` donde se añadian las dependencias pero ahora se insertan dentro del `values.yaml`. Para añadir una dependencia el formato será:
	```
	dependencies:
	  - name: name
	    version: 1.2.3
		repository: https://url.to.k8s.chart
		alias: myChart-alias 		# Opcional
	```
	- Para añadir un repositorio: 
	  ```
	  helm repo add <name> <url>
	  helm repo update
	  ```
	  
	- Para sacar la URL de un repositorio y añadirla como dependencia tenemos que ejecutar: `helm repo list` ó 	`helm search -l <name>` (nos da la versión)
	
	- Cuando añadimos en `chart.yaml` una dependencia (como el ejemplo de arriba), cuando ya tenemos el yaml actualizado con las dependencias tenemos que ejecutar: `helm dependency update` (importante guardarlo primero). Esto nos genera en `charts/` el tar.gz del la dependencia. 
	
	- ALIAS: Se utiliza cuando utilizamos varias versiones del mismo chart en las dependencias. Por ejemplo: myChartDep en la version 0.1.0 y en la version 1.5.1. Para ello a cada version le añadimos un alias (por ejemplo): `0.1.0 => alias: myChartDep-0.1.0  / 1.5.1 => alias: myChartDep-1.5.1`

### IMPORTANTE!
`crds/` -> 
1. Sólo se despliegan al principio (la primera vez que se despliega el chart) => **LAS ACTUALIZACIONES SE TIENEN QUE HACER A MANO**
2. Cuando hagamos el upgrade de un chart:
	1. Update CRDs
	2. Upgrade chart

**Si tenemos un chart de traefik (ejemplo) del propio Traefik y otro de un tercero (ej, bitnami/traefik) debemos usar siempre el del propio producto**
	

### TEMPLATES AND VALUES
* Son plantillas escritas en GO con un monton de add-ons y funciones. 

* Se guardan en `templates/`

* Los valores de los templates se añaden desde `values.yaml` (donde van los default) o en runtime con `helm install`

* La idea de las templates es dejar un montaje lo más básico posible (Service, deployment, etc) porque no sabemos donde se va a ejecutar el chart 

* Para ejecutar las templates y ver si funcionan (compilan) o no, no es necesario tener un cluster sino que habría que ejecutar lo siguiente: `helm install --dry-run --debug ./myChart` ó `helm template myReleaseName -f <values_file> .` (para ver las template ya modificadas con los valores correspondientes)

	Ejemplo de service con valores de template:
	```
	apiVersion: v1
	kind: Service
	metadata:
	  name: {{ template "myChart.fullname" . }}
	  labels:
		app: {{ template "myChart.name" . }}
		chart: {{ template "myChart.chart" . }}
		release: {{ .Release.Name }}
		heritage: {{ .Release.Service }}
	spec:
	  type: {{ .Values.service.type }}
	  ports: 
		- port: {{ .Values.service.port }}
		  targetPort: http
		  protocol: TCP
		  name: http
	  selector:
		  app: {{ template "myChart.name" . }}
		  release: {{ .Release.Name }}

	```
	Los valores entre {{}} se toman del values, de la template o del mismo helm (.Release.xx)

* Para lanzar variables en runtime: `helm install --dry-run --debug ./myChart --set image.repository=apache` (ejemplo) o también se le puede pasar un yaml de configuración.

### SET VALUES
Para settear valores hay dos opciones:
1. (no recomendada) Lanzar comando con `--set`. Ejemplo: `helm template myRelease --set service.port=8080`
2. Tener varios ficheros de `values` pero custom (Ejemplo: `values_custom.yml`) y pasarlos a helm tal que así: `helm template myRelease -f values_custom.yaml .`

Un ejemplo de `values_custom.yml`, que sobrescribirá el valor por defecto del svc port de `values.yml`:
```
service:
	port: 8080
```
* Hay que tener cuidado con esto porque Helm no comprueba que los tipos sean correctos y a veces hace modificaciones (ejemplo: 123456789123456... -> 1.2345e+15)

## NOTAS
- Helm guarda las releases en el mismo cluster de k8s a nivel NS 
- Puedes añadir funciones en los yaml para añadir logica a la asignacion de valores (if, with, ...)
- Hay que estar pendiente de cuando actualizan un chart porque puede haber modificaciones en los valores por defecto que te pueden afectar. **NO SUELEN AVISAR**

# BUILDING COMPLEX HELM CHARTS
Enalce: https://drive.google.com/drive/folders/1JjihiB8XYJ10x2Z13AGcU-rN5OuYMzTT 

Cuando estamos en un cluster productivo pero queremos probar nuevas cosas:
1. Crear un nuevo instanceGroup (kops) asignando los recursos que queremos.
- Para que los recursos que despleguemos caigan en un nodo y NS especificos => nodeLabel (project) + taint (para los recursos que no tengan un nodeLabel o nodeSelector)
	![[Pasted image 20220421115841.png]]
2.  Leer el values.yml del chart que queramos usar (ej, gitlab)