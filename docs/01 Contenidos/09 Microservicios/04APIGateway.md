# API Gateway

Todo sistema que hace uso de los microservicios debe disponer de una API Gateway que funcione de intermediario entre los clientes/usuarios y los microservicios.

Configurar un API Gateway es un proceso bastante sencillo.

En primer lugar crearíamos un nuevo proyecto de Spring con las siguientes dependencias:

* Eureka Client: para conectarnos a un servidor Eureka y descubrir los servicios
* Reactive Gateway: API de Spring para gestionar el Gateway.
  
Una vez creado el proyecto, debemos modificar el fichero ``application.properties``:

```properties
eureka.client.serviceUrl.defaultZone=http://localhost:8099/eureka/
spring.application.name=gateway
spring.cloud.gateway.discovery.locator.enabled=true
server.port=8080
```

Donde:

* ``eureka.client.serviceUrl.defaultZone``: indica la URL donde está recibiendo peticiones el servidor Eureka
* ``spring.application.name``: nombre de la aplicación para modificar el nombre en el servidor Eureka
* ``spring.cloud.gateway.discovery.locator.enabled``: permite habilitar la capacidad de descubrimiento de servicios mediante el servidor Eureka, permitiéndole a la API buscar y enrutar servicios a través del servidor.
* ``server.port``: puerto donde está atendiendo peticiones la API Gateway


Una vez configurado este fichero es necesario establecer los comandos para establecer las reglas de enrutado y poder acceder a los microservicios desde la API. Para ello debemos modificar el fichero main de la aplicación y hacer uso de las clases ``RouteLocator`` y ``RouteLocatorBuilder``.

Dentro de la clase ``RouteLocatorBuilder`` el método interesa usar es ``routes()`` que permite configurar ``route()`` donde se va indicando hacia qué servicio se deben desviar ciertas rutas.

Dentro del método Main añadiríamos el siguiente Bean:

```java
@Bean
public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
            // adding 2 rotes to first microservice as we need to log request body if method is POST
    return builder.routes()
            .route("primer-microservicio",r -> r.path("/primer")
                    .and().method("POST")
                    .and().readBody(Student.class, s -> true).filters(f -> f.filters(requestFilter, authFilter))
                    .uri("http://localhost:8081"))
            .route("primer-microservicio",r -> r.path("/primer")
                    .and().method("GET").filters(f-> f.filters(authFilter))
                    .uri("http://localhost:8081"))
            .route("segundo-microservicio",r -> r.path("/segundo")
                    .and().method("POST")
                    .and().readBody(Company.class, s -> true).filters(f -> f.filters(requestFilter, authFilter))
                    .uri("http://localhost:8082"))
            .route("servidor-autenticacion",r -> r.path("/login")
                    .uri("http://localhost:8088"))
            .build();
}
```

Donde:

* route:
    * el primer parámetro (``primer-microservicio``, ``segundo-microservicio``, o ``servidor-autenticacion``) indica el nombre del microservicio en Eureka service al cual se ve a desviar una ruta.
    * ``r.path``: indica la ruta recibida en el Gateway que se va a desviar
    * ``method``: indica el tipo de petición recibida
    * ``readBody``: permite establecer a ``true`` la opción de lectura del cuerpo del mensaje para poder añadirlo en la caché. Esta opción es útil si después se compagina con filters creando clases especializadas de filtrado.
    * ``filters``: permite establecer filtros personalizados de formato o autenticación. Para ello habría que crear clases personalizadas que heredaran de ``GatewayFilter``.
    * ``uri``: indica la URL a la que se desvía, generalmente es la URL donde está el ejecutándose el microservicio en cuestión. Podría usarse el propio servidor Eureka para encaminar indicando la URI con el siguiente formato: ``lb://{nombre-microservicio}:{puerto-microservicio}``

:::danger EJEMPLO PRÁCTICO
En este ejemplo se va a crear una API Gateway que permita accede a la API Rest. Teniendo en cuenta que en el microservicio de la API Rest se ha configurado:

* La propia API Rest en la URL: ``/person``
* La dirección de la Documentación de la API Rest en la URL: ``/api-docs``
* Swagger para un acceso más user friendly en la URL: ``/swagger-ui``
  
La configuración de la API Gateway quedaría configurada de la siguiente forma:

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class ApiGatewayApplication {

	public static void main(String[] args) {
		SpringApplication.run(ApiGatewayApplication.class, args);
	}

	@Bean
	public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
		return builder.routes()
				// Permitir el acceso a swagger
				.route("api-rest", r -> r.path("/swagger-ui/**")
						.uri("lb://api-rest:8081"))
				// Permitir el acceso a la ruta de la api
				.route("api-rest", r -> r.path("/api-docs/**")
						.uri("lb://api-rest:8081"))
				// Permitir el acceso al uso de la API
				.route("api-rest", r -> r.path("/person/**")
						.uri("lb://api-rest:8081"))
				.build();
	}
}
```
:::

## API Gateway y GraphQL
Debido al propio funcionamiento de GraphQL y a la posibilidad que dispone este para poder ejecutar las consultas sobre el mismo servidor, es necesario que el API Gateway haga dos encaminamientos:

1. El que permita acceder a la página para probar las consultas.
2. El que permita encaminar desde la página de consultas hacia el microservicio que da respuesta a esa consulta.
   
Para ello, es necesario hacer una modificación en el proyecto que ejecuta GraphQL añadiendo al fichero application.properties la siguiente información:
```properties
spring.application.name=nombreAplicacion
spring.graphql.graphiql.enabled=true
spring.graphql.path=/nombreAplicacionQL
```
Donde ``spring.graphql.path`` permite modificar el nombre de la ruta a la que se accede para hacer las peticiones. El resto de líneas deberían estar ya añadidas.

A continuación, se modifica el código de la API Gateway de la siguiente forma:

```java
package com.apigateway.Gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class GatewayApplication {

	public static void main(String[] args) {
		SpringApplication.run(GatewayApplication.class, args);
	}

	@Bean
	public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
		return builder.routes()
			// Acceso al servicio de calificación
			.route("nombreAplicacion", r -> r.path("/nombreAplicacion/**")
				.filters(f -> f.rewritePath("/nombreAplicacion/(?<segment>.*)", "/${segment}"))
				.uri("lb://nombreAplicacion:8701"))
			.route("nombreAplicacionGraph", r -> r.path("/nombreAplicacionQL")
				.uri("lb://nombreAplicacion:8701/nombreAplicacionQL"))

			.build();
	}
}

```

De esta forma, deberíamos poder acceder a la página de realización de consultas través de la API Gateway y obtener la solución del propio microservicio de GraphQL.

