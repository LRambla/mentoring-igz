# Trabajar con VCS
A la hora de trabajar con cualquier control de versiones (VCS) debemos tener claros los siguientes conceptos básicos:


* Repositorio remoto: Repositorio creado en el VCS (Bitbucket, github,...)
* Repositorio local: Copia del repositorio remoto en nuestro local.
* Branch: Snapshot del repositorio en la que puede haber cambios. 
* Master: En ocasiones se suele llamar “main”. Se trata de la rama principal del proyecto. Esta rama suele tener la última release funcional del código del repositorio. 
* Pull: Traer o descargar cambios. 
* Pull Request: Petición para traer los cambios de una rama a otra. 
* Push: Subir cambios.
* Commit: Mensaje que resume los cambios realizados. 
* Merge: Unificar cambios de una rama o commit a otra rama o commit. 
* Checkout: Comando de git que sirve para cambiar de una rama a otra o para crear una rama nueva desde la rama en la que estamos. 

# Trabajar con ramas
Siempre que queramos realizar actualizaciones sobre cualquiera las ramas y/o entornos que estén conectados a estas tendremos que realizar los siguientes pasos:

Si no tenemos el repositorio de Bitbucket clonado en nuestro local, lo primero que tendremos que hacer es:
1. Acceder al repositorio correspondiente

2. Copiar el enlace de clonado del repositorio, asegurándonos de que el label sea “SSH”.

3. Una vez hecho esto, desde nuestro local, abrimos un terminal y ejecutamos:         
`git clone <enlace_que_hemos_copiado>`

4. Abrimos el editor de código que usemos (por ejemplo, Visual Code) y abrimos el proyecto que acabamos de clonar. 

5. Una vez tenemos el repositorio clonado en nuestro local, procedemos a la realización de los cambios. Para ello tenemos diferentes casos de uso.


## Caso 1 - Subir cambios a pre-producción (develop)
![image](https://user-images.githubusercontent.com/22979757/197194497-a58453fa-853a-465b-81f9-18938b896714.png)

1. Abrimos un terminal en el proyecto que queramos realizar los cambios y ejecutamos los siguientes comandos para traernos los últimos cambios de la rama develop y crear una nueva rama para trabajar:
```
//lista las ramas existentes
git branch
// Nos movemos a la rama develop	        
git checkout develop
// Nos bajamos los ultimos cambios de develop      
git pull origin develop      
//Creamos una nueva rama “feat/<nombre_identificativo_del_desarrollo>" 
// a partir de develop
git checkout -b feat/<nombre_identificativo_del_desarrollo>
```
2. Una vez tenemos creada nuestra rama a partir de develop ya podemos realizar los cambios en el código.

3. Cuando tenemos los cambios, realizamos los siguientes comandos para preparar y subir nuestros cambios al repositorio:        
```
//Listado de los ficheros afectados en los cambios realizados
// Verde = ficheros añadidos/actualizados. Rojo = ficheros eliminados
git status
//Indicamos qué ficheros con cambios queremos subir:
git add <nombre_ficheros>
//Si queremos añadir todos los cambios listados en el git status ->
git add .
//Damos un nombre al paquete de cambios que vamos a subir:     
git commit -m “<resumen_cambios>”      
//Subimos los cambios de nuestra rama local a una rama con el mismo nombre en Bitbucket: 
git push origin feat/<nombre_identificativo_del_desarrollo> 
```
4. Tras esto, si accedemos al repositorio en el VCS, podremos ver que en el listado de ramas aparece la nuestra (Ejemplo: feat/automate-cf )
5. Creamos una Pull Request de nuestra rama ( feat/automate-cf ) a develop desde el UI del VCS.
6. Creamos una nueva PR y seleccionamos en qué rama tenemos subidos los nuevos cambios y a qué rama queremos subirlos. 
7. Seleccionamos “Continue” y aparece una nueva sección en la que podremos añadir, si queremos, una descripción de los cambios realizados y añadir revisores a la Pull Request (buena práctica). 
(!) Si añadimos revisores, la PR no podrá ser mergeada a la rama destino hasta que el revisor o revisores no acepten esos cambios. 
8. Seleccionamos “Create” y ya tendríamos creada la Pull Request.
9. Una vez esté validada por los revisores, en caso de que los hubiera, y hemos verificado que el DIFF de la Pull Request cuenta con los cambios que queremos, ya podemos seleccionar “Merge” para subir los cambios de nuestra rama “feat/automate-cf” a develop. 


## Caso 2 - Subir cambios a master
![image](https://user-images.githubusercontent.com/22979757/197194637-3c5452a4-8e86-4410-b6a2-fb15a199d0ea.png)

1. Abrimos un terminal en el proyecto que queramos realizar los cambios y ejecutamos los siguientes comandos para traernos los últimos cambios de la rama master y crear una nueva rama para trabajar:
```
//lista las ramas existentes
git branch
// Nos movemos a la rama develop	        
git checkout master
// Nos bajamos los ultimos cambios de develop      
git pull origin master      
//Creamos una nueva rama “feat/<nombre_identificativo_del_desarrollo>" 
// a partir de master
git checkout -b feat/<nombre_identificativo_del_desarrollo> 
``` 
2. Una vez tenemos creada nuestra rama a partir de master ya podemos realizar los cambios en el código.
3. Cuando tenemos los cambios, realizamos los siguientes comandos para preparar y subir nuestros cambios al repositorio:        
```
//Listado de los ficheros afectados en los cambios realizados
// Verde = ficheros añadidos/actualizados. Rojo = ficheros eliminados
git status
//Indicamos qué ficheros con cambios queremos subir:
git add <nombre_ficheros>
//Si queremos añadir todos los cambios listados en el git status ->
git add .
//Damos un nombre al paquete de cambios que vamos a subir:     
git commit -m “<resumen_cambios>”      
//Subimos los cambios de nuestra rama local a una rama con el mismo nombre en Bitbucket: 
git push origin feat/<nombre_identificativo_del_desarrollo> 
```
4. Tras esto, si accedemos al repositorio en Bitbucket, podremos ver que en el listado de ramas aparece la nuestra (Ejemplo: feat/automate-cf ):
5. Creamos una Pull Request de nuestra rama ( feat/automate-cf ) a master. Para ello, debemos seleccionar el icono de Pull Request  de la barra lateral izquierda.
6. Creamos una nueva PR y seleccionamos en qué rama tenemos subidos los nuevos cambios y a qué rama queremos subirlos. En nuestro ejemplo:
7. Seleccionamos “Continue” y aparece una nueva sección en la que podremos añadir, si queremos, una descripción de los cambios realizados y añadir revisores a la Pull Request (buena práctica). 
(!) Si añadimos revisores, la PR no podrá ser mergeada a la rama destino hasta que el revisor o revisores no acepten esos cambios. 
8. Seleccionamos “Create” y ya tendríamos creada la Pull Request.
9. Una vez esté validada por los revisores, en caso de que los hubiera, y hemos verificado que el DIFF de la Pull Request cuenta con los cambios que queremos, ya podemos seleccionar “Merge” para subir los cambios de nuestra rama “feat/automate-cf” a master. 


## Caso 3 - Subir los cambios de develop a master o viceversa
En ocasiones querremos actualizar la rama master (producción) con los cambios de la rama develop (pre-producción) o viceversa. Para ello, simplemente debemos generar una PR de develop a master o de master a develop en función del cambio que queramos realizar. 
Para ello, es tan sencillo como seleccionar desde Bitbucket el icono de Pull Request  de la barra lateral izquierda e indicamos las ramas origen/destino:

# Resolver conflictos entre ramas

A la hora de hacer una Pull Request, pueden surgir dos supuestos. Para explicarlos usaremos un ejemplo en el que la rama origen será develop y la rama destino será master:

1. Que no haya conflictos entre los ficheros de las ramas. Es decir, que en la rama que hemos modificado (rama origen) vaya por detrás de la rama destino. 
![image](https://user-images.githubusercontent.com/22979757/197194936-8b3b4649-67e9-4f65-a143-c3d517f8bcdb.png)

2. Que la rama destino vaya por delante de la rama origen de la Pull Request. Esto suele ocurrir cuando hay varios desarrolladores trabajando sobre el mismo repositorio. 
![CICD  Guía Advanced Analytics  (5)](https://user-images.githubusercontent.com/22979757/197194083-f0d0adb9-5505-49c1-8c04-5f05b917753f.jpg)

2.1. (*) Del paso 3 al 4, debemos ejecutar los siguientes comandos para subir el código sin conflictos antes de hacer la PR a develop (4):
```
git add <ficheros>
git commit -m “mensaje”
git push origin fix/conflicts
```

# Comandos útiles (variados)
	
* Commit vacio para actualizar nombre de PR: `git commit --allow-empty -m "Empty message"`

* NO ACTUALIZAR RAMA DESDE GITHUB (UI) HASTA ANTES DE HACER EL MERGE!!!!!!!!!!!!!!!!!!!!!:
	```
	git checkout <rama>
	git pull origin <rama> (por si hay cambios)
	git merge upstream/master (te traes lo ultimo de master a la rama donde estes)
	git push origin <rama>
	```
* Actualizar un fork con los cambios del repo original: Dentro de tu fork, en la rama master, ejecutas:
``` 
	git remote -v --> Aseguramos que tenemos origin (nuestro) y upstream (original)
	git fetch upstream --> Traer los cambios de upstream
	git checkout master --> Nos aseguramos de que estamos en master
	git rebase upstream/master --> Obtenemos toda la actualizacion de upstream (ya lo tenemos en local).
	git push -f origin master --> Subir los cambios de nuestro master local al fork. Si miramos los commits de nuestro fork, podemos ver los nuevos cambios. 
```
Otra opcion:
	1. Hacer los cambios
	2. `git pull --rebase upstream master` --> Nos traemos los cambios de master (upstream) y los rebaseamos a la rama
	3. `git status` y `git log` para comprobar que este todo ok
	4. `git push -f origin nombre_rama` 
	
## HACER UN CHERRY-PICK 

1. Hacer las modificaciones en nuestra rama (flujo normal) + pull a nuestro fork + pull request. 
2. Cuando la PR esté aprobada, vamos al proyecto en local y hacemos lo siguiente:
```
  git pull origin <rama donde estabamos haciendo el cambio> -> comprobamos que estamos actualizados
  git log 						    -> cogemos el hash del commit que hemos usado para la PR
  git checkout master + git pull upstream master	    -> Nos vamos a master y actualizamos. 
  git checkout -b <rama>				    -> Creamos una nueva rama desde master para dejar ahi el cherry-pick y hacer una PR
  git cherry-pick <hash del commit>
  git push origin <rama que hemos creado desde master>	    -> Creamos la nueva PR con el cherry-pick a master de upstream desde nuestro fork
 ```

(NOTA PARA LA PR: It's good practice to mention the original PR for cherry picks. This would happen automatically if you were cherry-picking from the merged branch instead of cherry-picking from your original branch (which you shouldn't generally do, because you might diverge))

# Recursos útiles
* Comandos de git: https://www.atlassian.com/git/tutorials/atlassian-git-cheatsheet 
* Workflows:  https://www.atlassian.com/git/tutorials/comparing-workflows 
* Using branches: https://www.atlassian.com/git/tutorials/using-branches 
* Pull Requests: https://www.atlassian.com/git/tutorials/making-a-pull-request 