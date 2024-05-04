import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Ejercicio 712

Una serie de personas tienen publicados una serie de libros. Cada uno de estas personas les gusta saber qué escribe la competencia para coger "inspiración", por lo tanto, se pide diseñar un sistema que permita gestionar los libros que cada una de las personas tiene publicados y cuáles de los libros de la competencia ha comprado cada uno. Para desarrollar el sistema se hará uso de la estructura de microservicios, de tal forma que se desarrollará un sistema formado por los siguientes microservicios:

* Microservicio de ``Autores``:

  * Funcionalidades del servicio: deberá implementar una API Rest que permita realizar las siguientes operaciones
    1. Agregar nuevo Autor.
    2. Modificar datos de un Autor.
    3. Dado un identificador devolver unicamente el nombre de un Autor.
    4. Dado un nombre de autor devolverá su identificador.
  * Características técnicas:
    * Utilizará una base de datos MySQL llamada ``autores712`` que tendrá una tabla llamada ``autores`` con la siguiente estructura:
    <details>
      <summary>autores712.sql</summary>

    ```sql
    drop database if exists autores712;
    create database autores712;
    
    use autores712; 
    
    CREATE TABLE autores (
        id INT PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR(255) NOT NULL,
        informacion_contacto VARCHAR(255)
    );
    
    INSERT INTO autores (nombre, informacion_contacto)
    VALUES
        ('Juan Pérez', 'juan.perez@example.com'),
        ('María García', 'maria.garcia@example.com'),
        ('Luis Martínez', 'luis.martinez@example.com'),
        ('Ana Rodríguez', 'ana.rodriguez@example.com'),
        ('Carlos Sánchez', 'carlos.sanchez@example.com'),
        ('Laura Fernández', 'laura.fernandez@example.com');
    ```
    </details>

        * El nombre de la aplicación será ``autores``
        * El puerto donde se ejecutará será el ``8713``

* Microservicio de ``Libros``:
    * Funcionalidades del servicio:
        1. Agregar nuevo libro
        2. Actualizar libros.
        3. Dado un identificador devolver únicamente el nombre del libro.
        4. Dado un nombre de un libro devolver el identificador
    * Características técnicas:
      * Utilizará una base de datos MySQL llamada ``libros712`` que tendrá una tabla llamada ``libros`` con la siguiente estructura:
        <details>
            <summary>libros712.sql</summary>
    
        ```sql
        drop database if exists libros712;
        create database libros712;

        use libros712; 

        CREATE TABLE libros (
            id INT PRIMARY KEY AUTO_INCREMENT,
            titulo VARCHAR(255) NOT NULL,
            isbn VARCHAR(20) NOT NULL,
            id_autor INT,
            anio_publicacion INT
        );

        -- Inserta 10 libros con títulos aleatorios, ISBNs simulados, autores y años        de publicación aleatorios
        INSERT INTO libros (titulo, isbn, id_autor, anio_publicacion)       
        VALUES      
            ('La Sombra del Viento', '9788408182813', 1, 2001),     
            ('Cien años de soledad', '9780141184999', 2, 1967),     
            ('1984', '9780451524935', 3, 1949),     
            ('El Señor de los Anillos', '9780345339706', 4, 1954),      
            ('Harry Potter y la Piedra Filosofal', '9788498388953', 5, 1997),       
            ('To Kill a Mockingbird', '9780061120084', 6, 1960),
            ('The Great Gatsby', '9780743273565', 7, 1925);
        ``` 
        </details>

        * El nombre de la aplicación será ``libros``
        * El puerto donde se ejecutará será el ``8714``

* Microservicios de Pedidos:

  * Funcionalidades del servicio:
    1. **Realizar pedido**: recibirá el nombre de un autor y una lista con el nombre de los libros y generará un nuevo pedido donde se almacenará los Id y no los nombres, de tal forma que el resultado en la BD será el siguiente:
    <details>
        <summary>Colección pedidos</summary>
    
    ```json
    {
        "_id": "65bcdbc3c5bed0494e10e920",
        "idAutor": "5",
        "librosIds": [ "6" , "7" ],
        "fechaPedido": "2024-02-01T23:00:00.000Z"
    }
    ```
    </details>
    2. **Obtener pedido**: a partir de un identificador devolverá el nombre del autor y una lista con los nombres de los libros de ese pedido

  * Características técnicas:
    * Utilizará una base de datos MongoDB llamada ``pedidos712`` que tendrá una colección llamada ``pedido`` con la estructura anterior:
    * **Para obtener los identificadores a partir de los nombres y viceversa, se tendrá que hacer uso de las APIs de los microservicios ``Autores`` y ``Libros``**.
    * El nombre de la aplicación será ``pedidos``
    * El puerto donde se ejecutará será el ``8715``

Además, se configurará un servidor Eureka (en el puerto ``8712``) con sus respectivos clientes Eureka.

También se desarrollará una API Gateway que estará ejecutándose en el puerto ``8080`` y le permitirá a un usuario acceder a los servicios ofrecidos por el sistemas sin acceder directamente a cada uno de ellos.

<details>
    <summary>Solucion</summary>

<Tabs>
<TabItem value="Autores">
<Tabs>
<TabItem value="Autor">
```java
package com.example.autores;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "autores")
public class Autor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nombre;
    private String informacion_contacto;
}

```
</TabItem>
<TabItem value="AutorController">
```java
package com.example.autores;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/autor")
public class AutorController {
    @Autowired
    private AutorService autorService;

    @GetMapping("/{id}")
    public ResponseEntity<String> obtenerNombreAutor(@PathVariable Long id) {
        return ResponseEntity.ok(autorService.obtenerAutorPorId(id).getNombre());
    }

    @GetMapping("/porNombre/{nombre}")
    public ResponseEntity<Long> obtenerAutoresPorNombre(@PathVariable String nombre) {
        return ResponseEntity.ok(autorService.obtenerAutoresPorNombre(nombre).getId());
    }


    @PostMapping
    public ResponseEntity<Autor> agregarAutor(@RequestBody Autor nuevoAutor) {
        return ResponseEntity.ok(autorService.agregarAutor(nuevoAutor));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Autor> actualizarAutor(@PathVariable Long id, @RequestBody Autor autorActualizado) {
        return ResponseEntity.ok(autorService.actualizarAutor(id, autorActualizado));
    }
}

```
</TabItem>
<TabItem value="AutoresApplication">
```java
package com.example.autores;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class AutoresApplication {

	public static void main(String[] args) {
		SpringApplication.run(AutoresApplication.class, args);
	}

}
```
</TabItem>
<TabItem value="AutorRepository">
```java
package com.example.autores;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AutorRepository extends JpaRepository<Autor, Long> {
    Autor findByNombre(String nombre);
}

```
</TabItem>
<TabItem value="AutorService">
```java
package com.example.autores;

import com.netflix.discovery.converters.Auto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AutorService {

    @Autowired
    private AutorRepository autorRepository;
    public Autor agregarAutor(Autor nuevoAutor) {
        return autorRepository.save(nuevoAutor);
    }

    public Autor obtenerAutoresPorNombre(String nombre) {
        return autorRepository.findByNombre(nombre);
    }

    public Autor actualizarAutor(Long id, Autor autorActualizado) {
        autorActualizado.setId(id);
        return autorRepository.save(autorActualizado);
    }

    public Autor obtenerAutorPorId(Long id) {
        return autorRepository.findById(id).orElse(null);
    }
}

```
</TabItem>
<TabItem value="application.properties">
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/autores712?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=abc123.
spring.jpa.hibernate.ddl-auto=update
server.port=8713
spring.application.name=autores
springdoc.api-docs.path=/api-autores
eureka.client.serviceUrl.defaultZone=http://localhost:8712/eureka/
```
</TabItem>
</Tabs>
</TabItem>
<TabItem value="Libros">
<Tabs>
<TabItem value="Libro">
```java
package com.example.libros;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "libros")
public class Libro {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String titulo;
    private String isbn;
    private Integer idautor;
    private Integer anio_publicacion;
}

```
</TabItem>
<TabItem value="LibroController">
```java
package com.example.libros;

import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/libro")
public class LibroController {
    @Autowired
    private LibroService libroService;

    @GetMapping("/{id}")
    public String obtenerNombreLibro(@PathVariable Long id) {
        return libroService.obtenerLibroPorId(id).getTitulo();
    }

    @GetMapping("/porTitulo/{titulo}")
    public ResponseEntity<Long> obtenerLibro(@PathVariable String titulo) {
        return ResponseEntity.ok(libroService.obtenerLibroPorTitulo(titulo).getId());
    }

    @PostMapping
    public Libro agregarLibro(@RequestBody Libro nuevoLibro) {
        return libroService.agregarLibro(nuevoLibro);
    }

    @GetMapping("/porAutor/{idAutor}")
    public List<Libro> obtenerLibrosPorAutor(@PathVariable String idAutor) {
        return libroService.obtenerLibrosPorAutor(Integer.parseInt(idAutor));
    }

    // Endpoint para actualizar información de un libro
    @PutMapping("/{id}")
    public Libro actualizarLibro(@PathVariable Long id, @RequestBody Libro libroActualizado) {
        return libroService.actualizarLibro(id, libroActualizado);
    }
}

```
</TabItem>
<TabItem value="LibrosApplication">
```java
package com.example.libros;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class LibrosApplication {

	public static void main(String[] args) {
		SpringApplication.run(LibrosApplication.class, args);
	}

}
```
</TabItem>
<TabItem value="LibroRepository">
```java
package com.example.libros;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface LibroRepository extends JpaRepository<Libro, Long> {

    List<Libro> findByIdautor(Integer autor);

   Libro findByTitulo(String titulo);
}

```
</TabItem>
<TabItem value="LibroService">
```java
package com.example.libros;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LibroService {
    @Autowired
    private LibroRepository libroRepository;

    // Método para agregar un nuevo libro
    public Libro agregarLibro(Libro nuevoLibro) {
        // Puedes realizar validaciones o lógica de negocio aquí
        return libroRepository.save(nuevoLibro);
    }

    public List<Libro> obtenerLibrosPorAutor(Integer autor) {
        return libroRepository.findByIdautor(autor);
    }

    // Método para actualizar información de un libro
    public Libro actualizarLibro(Long id, Libro libroActualizado) {
        // Puedes realizar validaciones o lógica de negocio aquí
        libroActualizado.setId(id);
        return libroRepository.save(libroActualizado);
    }

    public Libro obtenerLibroPorId(Long id) {
        return libroRepository.findById(id).orElse(null);
    }

    public Libro obtenerLibroPorTitulo(String titulo) {
        return libroRepository.findByTitulo(titulo);
    }
}

```
</TabItem>
<TabItem value="application.properties">
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/libros712?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=abc123.
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
spring.jpa.hibernate.ddl-auto=update
server.port=8714
spring.application.name=libros
springdoc.api-docs.path=/api-libros
eureka.client.serviceUrl.defaultZone=http://localhost:8712/eureka/

```
</TabItem>
</Tabs>
</TabItem>
<TabItem value="Pedidos">
<Tabs>
<TabItem value="Pedido">
```java
package com.example.pedido;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@RequiredArgsConstructor
@Document(collection = "pedido")
public class Pedido {
    @Id
    private String id;
    @NonNull
    private Long idAutor;
    @NonNull
    private List<Long> librosIds;
    @NonNull
    private LocalDate fechaPedido;
}

```
</TabItem>
<TabItem value="PedidoController">
```java
package com.example.pedido;

import com.example.pedido.DTO.AutorLibros;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/pedido")
public class PedidoController {

    @Autowired
    private PedidoService pedidoService;

    // Endpoint para realizar un nuevo pedido
    @PostMapping
    public Pedido realizarPedido(@RequestBody AutorLibros autorLibros) {

        return pedidoService.realizarPedido(autorLibros);
    }

    // Endpoint para obtener información de un pedido por su ID
    @GetMapping("/{id}")
    public AutorLibros obtenerPedido(@PathVariable String id) {
        return pedidoService.obtenerPedido(id);
    }
}

```
</TabItem>
<TabItem value="PedidosApplication">
```java
package com.example.pedido;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class PedidosApplication {

	public static void main(String[] args) {
		SpringApplication.run(PedidosApplication.class, args);
	}

}
```
</TabItem>
<TabItem value="PedidoRepository">
```java
package com.example.pedido;

import org.springframework.data.mongodb.repository.MongoRepository;

public interface PedidoRepository extends MongoRepository<Pedido, String> {
}

```

</TabItem>
<TabItem value="PedidoService">
```java
package com.example.pedido;

import com.example.pedido.DTO.AutorLibros;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class PedidoService {
    @Autowired
    private PedidoRepository pedidoRepository;
    private final String URLAUTOR = "http://localhost:8713/autor";
    private final String URLLIBRO = "http://localhost:8714/libro";

    public Pedido realizarPedido(AutorLibros autorLibros) {
        RestTemplate restTemplate = new RestTemplate();
        List<Long> idsLibros = new ArrayList<>();
        String urlAutor = URLAUTOR + "/porNombre/{nombre}";
        String urlLibros = URLLIBRO + "/porTitulo/{titulo}";

        ResponseEntity<Long> responseEntity = restTemplate.getForEntity(urlAutor, Long.class, autorLibros.getNombreAutor());

        for (String libro : autorLibros.getNombreLibros()){
            ResponseEntity<Long> responseLibro = restTemplate.getForEntity(urlLibros, Long.class, libro);
            idsLibros.add(responseLibro.getBody());
        }

        Long idAutor = responseEntity.getBody();

        Pedido pedido = new Pedido(idAutor, idsLibros, LocalDate.now());

        // Puedes realizar lógica adicional, como verificar la disponibilidad de los libros, calcular el total, etc.

        return pedidoRepository.save(pedido);
    }

    // Método para obtener información de un pedido por su ID
    public AutorLibros obtenerPedido(String id) {
        RestTemplate restTemplate = new RestTemplate();
        Pedido pedido = pedidoRepository.findById(id).orElse(null);
        AutorLibros autorLibros = new AutorLibros();
        List<String> nombreLibros = new ArrayList<>();
        String urlAutor = URLAUTOR + "/{id}";
        String urlLibros = URLLIBRO + "/{id}";

        ResponseEntity<String> responseEntity = restTemplate.getForEntity(urlAutor, String.class, pedido.getIdAutor());

        for (Long libro : pedido.getLibrosIds()){
            ResponseEntity<String> responseLibro = restTemplate.getForEntity(urlLibros, String.class, libro);
            nombreLibros.add(responseLibro.getBody());
        }

        autorLibros.setNombreAutor(responseEntity.getBody());
        autorLibros.setNombreLibros(nombreLibros);

        return autorLibros;
    }
}

```
</TabItem>
<TabItem value="AutorLibros">
```java
package com.example.pedido.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@AllArgsConstructor
@Data
@NoArgsConstructor
public class AutorLibros {
    private String nombreAutor;
    private List<String> nombreLibros;
}

```
</TabItem>
<TabItem value="application.properties">
```properties
spring.data.mongodb.uri=mongodb://localhost:27017/pedidos712
spring.data.mongodb.host=localhost
spring.data.mongodb.port=27017
server.port=8715
spring.application.name=pedidos
springdoc.api-docs.path=/api-pedidos
eureka.client.serviceUrl.defaultZone=http://localhost:8712/eureka/
```
</TabItem>
</Tabs>
</TabItem>
<TabItem value="Servidor Eureka">
<Tabs>
<TabItem value="ServidorApplication">
```java
package com.example.Servidor;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@EnableEurekaServer
@SpringBootApplication
public class ServidorApplication {

	public static void main(String[] args) {
		SpringApplication.run(ServidorApplication.class, args);
	}

}
```
</TabItem>
<TabItem value="application.properties">
```properties
server.port=8712
eureka.instance.hostname=localhost
eureka.client.registerWithEureka=false
eureka.client.fetchRegistry=false
eureka.client.serviceUrl.defaultZone=http://${eureka.instance.hostname}:${server.port}/eureka/
```
</TabItem>
</Tabs>
</TabItem>
<TabItem value="API Gateway">
<Tabs>
<TabItem value="APIGatewayApplication">
```java
package com.example.APIGateway;

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
				.route("autores", r -> r.path("/autor/**")
						.uri("lb://autores:8713"))
				// Permitir el acceso a la ruta de la api
				.route("libros", r -> r.path("/libro/**")
						.uri("lb://libros:8714"))
				// Permitir el acceso al uso de la API
				.route("pedido", r -> r.path("/pedidos/**")
						.uri("lb://pedidos:8715"))
				.build();
	}
}
```
</TabItem>
<TabItem value="application.properties">
```properties
eureka.client.serviceUrl.defaultZone=http://localhost:8712/eureka/
spring.application.name=gateway
spring.cloud.gateway.discovery.locator.enabled=true
server.port=8080
```
</TabItem>
</Tabs>
</TabItem>
</Tabs>
</details>