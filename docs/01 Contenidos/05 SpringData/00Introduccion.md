# Introducción
:::tip SPRING DATA
Spring Data es una capa de abstracción que permite a los desarrolladores interactuar con diferentes tipos de bases de datos de una manera coherente y sencilla, reduciendo la complejidad de la integración con la base de datos y acelerando el desarrollo de aplicaciones

:::

Spring Data proporciona soporte para una variedad de tecnologías de acceso a datos:

* Bases de datos relacionales
* Bases de datos NoSQL
* Bases de datos en memoria
* Sistemas de archivos.

Además, proporciona integración con otras tecnologías de Spring, como Spring MVC y Spring Boot, lo que permite a los desarrolladores construir aplicaciones web escalables y fáciles de mantener.

:::tip SPRING DATA JPA
**Spring Data JPA** proporciona una implementación de la API JPA estándar para la persistencia de datos en bases de datos relacionales y proporciona una capa de abstracción adicional que simplifica el trabajo con bases de datos relacionales en aplicaciones Java.

:::

JPA es una **especificación estándar de Java** para el mapeo objeto-relacional (ORM) y proporciona una forma fácil y consistente de interactuar con una base de datos utilizando objetos Java.

Spring Data JPA proporciona una **capa de abstracción adicional** en la parte superior de la API JPA, lo que hace que sea aún más fácil trabajar con bases de datos relacionales que usando Hibernate solamente.

Entre las principales **ventajas** de Spring Data JPA se encuentran:

* **Reduce el código boilerplate**: elimina gran parte del código repetitivo que normalmente se necesita para interactuar con una base de datos relacional, lo que hace que el código sea más limpio y fácil de mantener.
  
* **Abstracción de bases de datos**: permite a los desarrolladores escribir código que sea independiente de la base de datos subyacente. Esto significa que puede cambiar fácilmente de una base de datos a otra sin tener que cambiar su código.
  
* **Soporte para repositorios específicos, paginación y ordenamiento**: proporciona soportes con repositorios específicos, soporte para paginación y ordenamiento de resultados de consultas de forma fácil y sencilla, lo que facilita la implementación de características avanzadas en una aplicación.
  
* **Integración con otras tecnologías de Spring**: se integra perfectamente con otras tecnologías de Spring, como Spring MVC y Spring Boot, lo que facilita la construcción de aplicaciones web completas.

Para **configurar** Spring Data JPA en un proyecto, si no se ha añadido en el momento de crear el proyecto, se puede añadir agregando la siguiente dependencia en el archivo pom.xml:

```xml
 <!-- Starter de Spring Data JPA -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```
