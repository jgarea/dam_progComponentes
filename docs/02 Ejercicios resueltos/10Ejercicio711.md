import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Ejercicio 711

Configura un servidor Eureka server que permita registrar las actividades realizadas en las actividades anteriores:

* Nombre del host: ``localhost``
* Puerto de actuación: ``8700``

A continuación, modifica las actividades anteriores para que se registren ante el servidor Eureka configurado previamente.

Finalmente, configura una API Gateway que descubra y utilice los servicios anteriores mediante el uso del servidor Eureka..

<details>
<summary>Solución</summary>

**Configuración de Eureka Server**

Para la configuración del servidor es neceario:

* Crear el proyecto que tenga la dependencia de Eureka Server
* Configurar el fichero application.properties
* Configurar el fichero main donde se ejecute el servidor.

Un ejemplo de configuración sería la siguiente:

<Tabs>
<TabItem value="application.properties">
```properties
server.port=8700
eureka.instance.hostname=localhost
eureka.client.registerWithEureka=false
eureka.client.fetchRegistry=false
eureka.client.serviceUrl.defaultZone=http://${eureka.instance.hostname}:${server.port}/eureka/
```
</TabItem>
<TabItem value="EurekaServerApplication.java">
```java
package com.example.EurekaServer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@EnableEurekaServer
@SpringBootApplication
public class EurekaServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(EurekaServerApplication.class, args);
	}

}
```
</TabItem>
</Tabs>

**Configuración de los Eureka Client**
En cuanto a la configuración de los clientes, habría que añadir la dependencia de Eureka Client a cada uno de ellos:

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
    <version>4.1.0</version>
</dependency>
```

Además, hay que modificar el fichero application.properties de la siguiente forma:

```properties
eureka.client.serviceUrl.defaultZone=http://localhost:8700/eureka/
```

Si se ha configurado correctamente los nombres de cada actividad en las actividades anteriores no sería necesario añadir nada más a los ficheros. Si por el contrario, no se ha configurado el nombre de la aplicación, habría que añadir que la siguiente línea:

```properties
spring.application.name=nombreActividad
```

**Modificación de los proyectos con GraphQL**
Para poder redirigir las peticiones hechas con GraphQL y seguir utilizando GraphiQL es neceario apadir al fichero application.properties de cada proyecto la siguiente línea:

```properties
spring.graphql.path=/nombreProyecto
```

Por defecto, cuando se accede a GraphiQL y este hace una petición redirige las peticiones a /graphql. Sin embargo, al tener más de un proyecto se genera un conflicto porque no se va a saber hacia qué sistema hay que redirigir esta petición. Añadiendo la línea anterior haremos que GraphiQL no use la ruta por defecto si no una personalizada, lo que facilitará la redirección en el API Gateway

**Creación de la API Gateway**

En cuanto a la configuración del API Gateway será necesario crea un proyecto que disponga de la dependencia API Gateway y modificar y crear los siguientes ficheros:

<Tabs>
<TabItem value="application.properties">
```properties
eureka.client.serviceUrl.defaultZone=http://localhost:8700/eureka/
spring.application.name=gateway
spring.cloud.gateway.discovery.locator.enabled=true
server.port=8080
```
</TabItem>
<TabItem value="ApiGatewayApplication.java">
```java
package com.example.APIGateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@SpringBootApplication
public class ApiGatewayApplication {

	public static void main(String[] args) {
		SpringApplication.run(ApiGatewayApplication.class, args);
	}

	private Mono<Boolean> handleInvalidReferer(ServerWebExchange exchange) {
		// Realizar acciones específicas para el caso de 'Referer' no válido
		// Por ejemplo, puedes devolver un código de estado FORBIDDEN o redirigir a una página de error
		exchange.getResponse().setStatusCode(HttpStatus.FORBIDDEN);
		return Mono.just(false);
	}

	@Bean
	public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
		return builder.routes()
				// Acceso ejercicio 701
				/*.route("saludo", r -> r.path("/api-saludo", "/saludo/**")
						.uri("lb://saludo:8701"))*/

				// Acceso ejercicio 702
				.route("saludo", r -> r.path("/api-saludo", "/saludo/**")
						.uri("lb://saludo:8702"))

				// Acceso ejercicio 703
				.route("productos", r -> r.path("/api-productos", "/productos/**")
						.uri("lb://productos:8703"))

				// Acceso ejercicio 704
				.route("empleados", r -> r.path("/api-empleados", "/empleados/**")
						.uri("lb://empleados:8704"))

				// Acceso ejercicio 705
				.route("libros", r -> r.path("/api-libros", "/libros/**")
					.uri("lb://libros:8705"))

				// Acceso ejercicio 706
				.route("empleadosQLRoute", r -> r.path("/empleadosQL/**")
						.filters(f -> f.rewritePath("/empleadosQL/(?<segment>.*)", "/${segment}"))
						.uri("lb://empleadosQL:8706"))
				.route("empleadosQLGraph", r -> r.path("/empleadosQL706")
						.uri("lb://empleadosQL:8706/empleadosQL706"))

				// Acceso ejercicio 707
				.route("librosQLRoute", r -> r.path("/librosQL/**")
						.filters(f -> f.rewritePath("/librosQL/(?<segment>.*)", "/${segment}"))
						.uri("lb://librosQL:8707"))
				.route("librosQLGraph", r -> r.path("/librosQL707")
						.uri("lb://librosQL:8707/librosQL707"))

				// Acceso ejercicio 709
				.route("estudiantes709", r -> r.path("/api-estudiantes709", "/estudiantes709/**")
						.uri("lb://estudiantes709:8709"))

				// Acceso ejercicio 710
				.route("peliculas710", r -> r.path("/api-peliculas710", "/peliculas710/**")
						.uri("lb://peliculas710:8710"))
			.build();
	}
}
```
</TabItem>
</Tabs>

</details>