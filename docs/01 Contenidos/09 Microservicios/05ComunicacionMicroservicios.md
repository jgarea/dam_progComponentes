import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Comunicación entre microservicios

Aunque la principal **filosofía de los microservicios** es la de crear **sistemas aislados** donde no exista acoplamiento entre los diferentes componentes, esto **no es lo general** ya que puede haber casos donde **un microservicio necesite** conocer cierta **información** que es gestionada y proporcionada **por otro**.

Hasta ahora se han diseñado microservicios donde la interacciones eran entre el usuario y el microservicio, sin embargo, **a continuación, se mostrará como un microservicio puede enviar solicitudes a otro microservicios.**

Dado un microservicio que tiene implementada una API Rest, si se quiere hacer consultas a ella desde otro servicio se hará uso de la clase ``RestTemplate``. Existen dos posibles casos:

* Que el microservicio al que se consulta reciba peticiones GET.
* Que el microservicio al que se consulta reciba peticiones POST.

:::danger EJEMPLO: CONSULTA USANDO GET
En este ejemplo se realiza una petición GET sin parámetros al servicio jugadores que corre en el puerto 8700
```java
RestTemplate restTemplate = new RestTemplate();
String urlServicio = "http://localhost:8700/jugadores/"
ResponseEntity<String> response = restTemplate.getForEntity(urlServicio, String.class);
System.out.println(response.getBody())
```
Si por el contrario, se quieren enviar parámetros la consulta se vería modificada de la siguiente forma:
```java	
RestTemplate restTemplate = new RestTemplate();
String urlServicio = "http://localhost:8700/jugadores/{id}"
ResponseEntity<String> response = restTemplate.getForEntity(urlServicio, String.class, 1L);
System.out.println(response.getBody())
```

De esta forma se estaría enviando el id ``1`` (como Long) para obtener la información almacenada de ese jugador. En ambos casos, el resultado de la consulta será un único String.

:::

:::danger EJEMPLO: CONSULTA USANDO POST ENVIANDO INFORMACIÓN EN EL CUERPO
A la hora de enviar información al servidor utilizando POST nos podemos encontrar con tres situaciones en dónde podemos inviar información:

* Enviar la información solo en el cuerpo del mensaje
* Enviar la información solo en la URL.
* Enviar la información en el cuerpo del mensajes y en la URL.
  
A continuación, se muestra un ejemplo de cada caso.
<Tabs>
<TabItem value="1" label="Información solo en el cuerpo" default>
Envío de la información en una clase ``Cancion`` al servicio de canciones. La respuesta del servidor será otra clase ``Canción``.

```java
RestTemplate restTemplate = new RestTemplate();

Cancion cancion = new Cancion(1, "Cancion 1");
ResponseEntity<Cancion> responseEntity1 = restTemplate.postForEntity(urlServicio, cancion, Cancion.class);
Cancion resultado = (Cancion) responseEntity1.getBody();
```
</TabItem>
<TabItem value="2" label="Información solo URL">
Envío de la información del nombre del artista (en la URL del mensaje) al servicio de canciones. La respuesta del servidor será otra clase ``Canción``.


```java	
RestTemplate restTemplate = new RestTemplate();

String urlServicio = "http://localhost:8701/canciones/{artista}";
String artista = "Artista 1";
ResponseEntity<Cancion> responseEntity1 = restTemplate.postForEntity(urlServicio, null, Cancion.class, artista);
Cancion resultado = (Cancion) responseEntity1.getBody();
```
</TabItem>
<TabItem value="3" label="Información cuerpo y URL">
Envío de la información en una clase ``Cancion`` (en el cuerpo del mensaje) y el nombre del artista (en la URL del mensaje) al servicio de canciones. La respuesta del servidor será otra clase ``Canción``

```java	
RestTemplate restTemplate = new RestTemplate();

String urlServicio = "http://localhost:8701/canciones/{artista}";
Cancion cancion = new Cancion(1, "Cancion 1");
String artista = "Artista 1";
ResponseEntity<Cancion> responseEntity1 = restTemplate.postForEntity(urlServicio, cancion, Cancion.class, artista);
Cancion resultado = (Cancion) responseEntity1.getBody();
```
</TabItem>
</Tabs>

:::