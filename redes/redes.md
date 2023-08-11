# Subnetting

## Network traffic methods
- Unicast: 1 device to 1 device (dentro de la misma LAN; pasando por el switch)
- Multicast: 1 device to N devices (dentro de la misma LAN pasando por el switch)
- Broadcast: 1 device to all devices (desde una LAN a todos los devices de la LAN + router + switch)

### Capas OSI
![[Pasted image 20220428112333.png]]
(Ejemplo pizza)
* Capa 5-7: Aplication (telefono - pagina web), presentation (idioma), session (saludo)
* Capa 4: Transport; firewall (QA - se aseguran de que el pedido de la pizza es el que se ha realizado)
* Capa 3: Network (GPS para encontrar la mejor ruta a tu casa)
* Capa 2: Data Link (La pizzeria necesita tu direccion completa para poder llevarte la pizza)
* Capa 1: Physical connectivity (Las rutas para llevarte la pizza)

### TCP/IP
![[Pasted image 20220428113101.png]]
User data >> app data >> ip data >> frame data
* TCP Header: port to port
* IP Header: IP address to IP address
* Frame header: MAC address to MAC address

## Addressing
* IPv4 -> 192.168.1.101 (32 bits = 4 nº x 8 bits/num)

* IPv6 -> muy largas y en hexadecimal (128bits = 8 secciones x 16bits/num). Primera mitad Network y segunda mitad Host y viene desde la MAC address 

ARP (Address Resolution Protocol): Protocolo para mapear una IP a una MAC. 
1. El PC lanza una BROADCAST Request al server para pedir su MAC. 
2. El server devuelve la IP+MAC por UNICAST.

## Network Masks
EXAMPLE IP: 
192.168.001.101
'---------''----'
  network	host

MASK:
![[Pasted image 20220428160935.png]]

RANGE: 192.168.001.0 (network IP) - 192.168.001.255 (broadcast IP) --> 
- IPs = 256-2 = 254 IPs (sin las dos reservadas: 0 y 255)
- HOSTS = Determinados por la porcion del host. 

![[Pasted image 20220428161319.png]]

### Subnetting calc
#### Nº de hosts

Nº HOSTS = 2^(bits de host)-2

Se eliminan 2 bits para la IP de network y la de broadcast.

Ejemplo:
192.168.001.0 y mac: 255.255.255.0

host = 2⁸ -2 = 256-2 = 254 hosts.
192.168.001.0 y mac: 255.255.240.0

Mac = 11111111.11111111.11110000.00000000 => 12 ceros = 12 bits de host

host = 2¹²-2 = 4096-2= 4094 hosts

#### Rango de subnets

1. Pasar la IP y la MAC a binario y hacer IP AND MAC.

2. Nº de host de la MAC (contando los 0s de la mac en binario y aplicando formula de hosts sin restar)

3. El resultado de (1) pasarlo a decimal = NETWORK ADDRESS

4. Resultado (1) + resultado (2) -1 = BROADCAST ADDRESS

![[Pasted image 20220428162854.png]]

#### Nº de subnets

SUBNETS = 2^b / (n+2)

b -> nº bits de host
n -> nº de host x subnet

Ejemplo:
IP: 192.168.100.0
Mask: 255.255.255.0 (8bits host)
host/subnet: 6

SUBNETS = 2⁸ / (6+2) = 256/8= 32 subnets con 6 hosts IPs por subnet.


## Classful Networking
- Class A: 0.0.0.0 - 127.255.255.255 // 255.0.0.0 (/8) 
- Class B: 128.0.0.0 - 191.255.255.255 //255.255.0.0 (/16)
- Class C: 192.0.0.0 - 223.255.255.255 // 255.255.255.0 (/32)
- Claas D: [MULTICAST] 224.0.0.0-239.255.255.255
- Class E: [EXPERIMENTAL USE] 240.0.0.0-255.255.255.255 

## CIDR
- No usan clases y las masks no están limitadas a 255.0.0.0, 255.255.0.0, 255.255.255.0
- Mas facil que classful
![[Pasted image 20220504131617.png]]

Ejemplo de calculos: 172.100.129.147/21 

1. **IP en binario** =
10101100 11001000 10000001 10010011

2. **/21 en binario** = (255.255.248.0)
11111111 11111111 11111000 00000000
* Para sacar el binario de /21 se ponen 21 unos de izquierda a derecha y se rellena con ceros.

3. **IP AND 21** = 
10101100 11001000 10000000 00000000 =
**172.100.128.0 -> Primera IP (Network ID Address)**

4. **Numero de hosts disponibles** = 2¹¹ = 2048 hosts

5. **172.100.128.0 + 2048** = 
	1. Calculamos el incremento del 3er octeto porque 2048 > 256 = 2048/256 = 8
	2. Añadimos 8 al tercer octeto: = 128+8=136
	3. **La IP de broadcast = 172.100.135.255**


## FLSM & VLSM
-> como asignar subnets en una infra y si envian/no la mascara de subred
-> FLSM deprecado

### FLSM
- Fixed Length Subnet Mask
- Todas las redes tienen el mismo tamaño (el de la subred mas grande)
- 1 mascara de subred para todas las interfaces de los routers
- NO se envia la mascara de subred
- Ejemplo:
![[Pasted image 20220504130910.png]]


### VLSM
- Variable Length Subnet Mask
- Distintos tamaños de mascara de subred
- Usan CIDR
- Ejemplo:
![[Pasted image 20220504130840.png]]





