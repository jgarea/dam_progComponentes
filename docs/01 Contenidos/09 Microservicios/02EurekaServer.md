# Eureka Server
La configuración de Eureka Server es muy sencilla. Lo que habría que tener en cuenta es que el Servidor de Eureka debería ser un Microservicio en sí, encargado del registro del resto de microservicios.

Crearemos un nuevo proyecto Spring con la dependencia: Eureka Server.

También podríamos añadir a un nuevo proyecto la siguiente dependencia Maven:

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>
```

A continuación, es necesario modificar el fichero ``application.properties`` para configurar ciertos parámetros:
```properties
server.port=8099
eureka.instance.hostname=localhost
eureka.client.registerWithEureka=false
eureka.client.fetchRegistry=false
eureka.client.serviceUrl.defaultZone=http://${eureka.instance.hostname}:${server.port}/eureka/
```

Donde:
* server.port: Indica el puerto sobre el que estará corriendo el servicio
* eureka.instance.hostname: Indica la IP sobre la que corre el servicio, en este caso, localhost
* eureka.client.registerWithEureka: determina si el microservicio debe registrarse automáticamente en el servidor, en este caso, al ser el propio servidor hay que indicarle que no se registre
* eureka.client.fetchRegistry: determina si el microservicio debe consultar el registro de Eureka para obtener información sobre otros microservicios registrados en el mismo.
* eureka.client.serviceUrl.defaultZone: define la URL del servidor.

Una vez realizada la configuración, es necesario realizar una pequeña modificación en la clase Main (aquella que tenga la anotación ``@SpringBootApplication``). Esta modificación consiste en añadir la anotación ``@EnableEurekaServer``, justo debajo o encima de la anotación ``@SpringBootApplication``.

```java
package com.example.registerservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@EnableEurekaServer
@SpringBootApplication
public class RegisterServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(RegisterServiceApplication.class, args);
	}
}
```

De esta forma ya tendríamos configurado nuestro servidor Eureka.

Si se han realizado todos los pasos, se puede ejecutar el sistema. Si todo está correcto se debería poder acceder a la siguiente URL: ``localhost:8099/`` en donde se muestra el panel de configuración.