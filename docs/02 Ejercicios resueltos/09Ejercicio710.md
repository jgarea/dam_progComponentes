import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Ejercicio 710
Se pide desarrollar una aplicación utilizando Spring que permite gestionar una base de datos MongoDB denominada ``peliculas710``. Esta base de datos estará formada por dos colecciones:

* ``Actores``: la cual tendrá la siguiente estructura:
```json
{
  "_id": ObjectId("actor_id_1"),
  "nombre": "Nombre del Actor 1",
  "fecha_nacimiento": "1990-01-01",
  "nacionalidad": "País del Actor 1",
  "filmografia": [
    {
      "movie_id": ObjectId("movie_id_1"),
      "titulo": "Película 1",
      "año_estreno": 2010,
      "papel": "Papel en Película 1"
    },
    {
      "movie_id": ObjectId("movie_id_2"),
      "titulo": "Película 2",
      "año_estreno": 2015,
      "papel": "Papel en Película 2"
    }
    // Puedes agregar más películas si es necesario
  ]
}
```	

* ``Películas``: la cual tendrá la siguiente estructura:
```json
{
  "_id": ObjectId("movie_id_1"),
  "titulo": "Película 1",
  "año_estreno": 2010,
  "director": "Director de Película 1",
  "actores": [
    {
      "actor_id": ObjectId("actor_id_1"),
      "papel": "Papel del Actor 1"
    }
  ]
}

```

Además, se deberá tener en cuenta los siguientes aspectos de configuración:

* El programa Spring deberá estar corriendo en el puerto ``8710``.
* La base de datos utilizada se llamará ``peliculas710``
* El nombre del programa será ``peliculasMongoDB``.
* La URL de la documentación estará en: ``/api-peliculas710``.
* La API responderá a la petición en la ruta ``/peliculas710``
  
En cuanto a las dependencias del proyecto, será necesario utilizar:

* Spring Web
* Lombok
* Spring Data MongoDB.
  
Para la ejecución de las tareas de esta actividad se ofrece los siguientes ficheros JSON con datos para cargar la base de datos:

<details>
<sumary>Datos de prueba</sumary>

<Tabs>
<TabItem value="Peliculas.json">
```json
[
  {
    "_id": {"$oid": "65b770bae27e1a88c647617d"},
    "titulo": "Película 1",
    "año_estreno": 2010,
    "director": "Director de Película 1",
    "actores": [
      {"actor_id": {"$oid": "65b77087c247323b63113437"}, "papel": "Papel del Actor 1"},
      {"actor_id": {"$oid": "65b770b34cc76b138eaaa877"}, "papel": "Papel del Actor 3"}
    ]
  },
  {
    "_id": {"$oid": "65b770c1c7075199c3c6946b"},
    "titulo": "Película 2",
    "año_estreno": 2015,
    "director": "Director de Película 2",
    "actores": [
      {"actor_id": {"$oid": "65b77087c247323b63113437"}, "papel": "Papel del Actor 1"},
      {"actor_id": {"$oid": "65b770a3e760b6a0054f7643"}, "papel": "Papel del Actor 2"}
    ]
  },
  {
    "_id": {"$oid": "65b770cd5f55901d32eaf60c"},
    "titulo": "Película 3",
    "año_estreno": 2012,
    "director": "Director de Película 3",
    "actores": [
      {"actor_id": {"$oid": "65b770a3e760b6a0054f7643"}, "papel": "Papel del Actor 2"},
      {"actor_id": {"$oid": "65b770b34cc76b138eaaa877"}, "papel": "Papel del Actor 3"}
    ]
  }
]
```
</TabItem>
<TabItem value="Actores.json">
```json
[
  {
    "_id": {"$oid": "65b77087c247323b63113437"},
    "nombre": "Nombre del Actor 1",
    "fecha_nacimiento": "1990-01-01",
    "nacionalidad": "País del Actor 1",
    "filmografia": [
      {"movie_id": {"$oid": "65b770bae27e1a88c647617d"}, "papel": "Papel en Película 1"},
      {"movie_id": {"$oid": "65b770c1c7075199c3c6946b"}, "papel": "Papel en Película 2"}
    ]
  },
  {
    "_id": {"$oid": "65b770a3e760b6a0054f7643"},
    "nombre": "Nombre del Actor 2",
    "fecha_nacimiento": "1985-03-15",
    "nacionalidad": "País del Actor 2",
    "filmografia": [
      {"movie_id": {"$oid": "65b770c1c7075199c3c6946b"}, "papel": "Papel en Película 2"},
      {"movie_id": {"$oid": "65b770cd5f55901d32eaf60c"}, "papel": "Papel en Película 3"}
    ]
  },
  {
    "_id": {"$oid": "65b770b34cc76b138eaaa877"},
    "nombre": "Nombre del Actor 3",
    "fecha_nacimiento": "1988-07-20",
    "nacionalidad": "País del Actor 3",
    "filmografia": [
      {"movie_id": {"$oid": "65b770bae27e1a88c647617d"}, "papel": "Papel en Película 1"},
      {"movie_id": {"$oid": "65b770cd5f55901d32eaf60c"}, "papel": "Papel en Película 3"}
    ]
  }
]
```
</TabItem>
</Tabs>

</details>

En cuanto a las tareas a realizar, el programa deber ser capaz de realizar las siguientes consultas:

* **Consulta 1**: Obtener todos los actores.
* **Consulta 2**: Obtener todas las películas dirigidas por un director en particular.
* **Consulta 3**: Obtener la cantidad de películas dirigidas por cada director.
* **Consulta 4**: Obtener todas las películas de un actor en particular.
* **Consulta 5**: Obtener la filmografía completa de una película en particular.
* **Consulta 6**: Obtener la lista de actores que participaron en películas estrenadas después de 2012.
* **Consulta 7**: Obtener la cantidad de películas en las que cada actor ha participado.

<details>
<summary>Solución</summary>
<Tabs>
<TabItem value="DTO">
<Tabs>
<TabItem value="ActorCuentaDTO">
```java
package com.example.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ActorCuentaDTO {

    private String actorId;
    private long count;

}

```
</TabItem>
<TabItem value="ActorDTO">
```java
package com.example.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ActorDTO {

    private String nombre;
    private List<String> listaPeliculas = new ArrayList<>();

}

```
</TabItem>
<TabItem value="PeliculaDTO">
```java
package com.example.DTO;

import com.example.Modelos.Pelicula;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PeliculaDTO {
    @Id
    private String id;
    private String titulo;
    private int anhoEstreno;

    public PeliculaDTO(Pelicula pelicula) {
        this.id = pelicula.getId();
        this.titulo = pelicula.getTitulo();
        this.anhoEstreno = pelicula.getAño_estreno();
    }
}

```
</TabItem>
</Tabs>
</TabItem>
<TabItem value="Modelos">
<Tabs>
<TabItem value="Actor">
```java
package com.example.Modelos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Document(collection = "actores")
public class Actor {
    @Id
    private String id;
    private String nombre;
    private String fecha_nacimiento;
    private String nacionalidad;
    private List<FilmografiaItem> filmografia;
}

```
</TabItem>
<TabItem value="ActorEnPelicula">
```java
package com.example.Modelos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ActorEnPelicula {

    private String actor_id;
    private String papel;

}

```
</TabItem>
<TabItem value="FilmografiaItem">
```java
package com.example.Modelos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FilmografiaItem {

    private String movie_id;
    private String papel;

}

```
</TabItem>
<TabItem value="Pelicula">
```java
package com.example.Modelos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Document(collection = "peliculas")
public class Pelicula {

    @Id
    private String id;
    private String titulo;
    private int año_estreno;
    private String director;
    private List<ActorEnPelicula> actores;  // idActores - papel

}

```
</TabItem>
</Tabs>
</TabItem>
<TabItem value="Repositorio">
<Tabs>
<TabItem value="ActorRepositorio">
```java
package com.example.Repositorio;

import com.example.Modelos.Actor;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.util.List;

public interface ActorRepositorio extends MongoRepository<Actor, String> {
    List<Actor> findByNombre(String nombreActor);

    @Query("{'filmografia.movie_id': { $in: ?0 }}")
    List<Actor> findAllByFilmografiaMovieIdIn(List<String> movieIds);

    List<Actor> findByIdIn(List<String> listasIds);
}

```
</TabItem>
<TabItem value="PeliculaRepositorio">
```java
package com.example.Repositorio;

import com.example.Modelos.Pelicula;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.util.List;

public interface PeliculaRepositorio extends MongoRepository<Pelicula, String> {
    List<Pelicula> findByDirector(String nombreDirector);

    List<Pelicula> findByTitulo(String nombrePelicula);

    @Query("{ 'año_estreno': { $gt: 2012 } }")
    List<Pelicula> findPeliculasEstrenadasDespuesDe2010();

    List<Pelicula> findByIdIn(List<String> listaIds);
}

```
</TabItem>
</Tabs>
</TabItem>
<TabItem value="Servicio">
<Tabs>
<TabItem value="ActorServicio">
```java
package com.example.Servicios;

import com.example.Modelos.Actor;
import com.example.Repositorio.ActorRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActorServicio {
    @Autowired
    private ActorRepositorio actorRepositorio;

    public List<Actor> findAll() {
        return actorRepositorio.findAll();
    }

    public List<Actor> findByNombre(String nombreActor) {
        return actorRepositorio.findByNombre(nombreActor);
    }

    public List<Actor> findAllByFilmografiaMovieIdIn(List<String> movieIds) {
        return actorRepositorio.findAllByFilmografiaMovieIdIn(movieIds);
    }

    public List<Actor> findAllByIdIn(List<String> listasIds) {
        return actorRepositorio.findByIdIn(listasIds);
    }
}

```
</TabItem>
<TabItem value="PeliculaServicio">
```java
package com.example.Servicios;

import com.example.DTO.PeliculaDTO;
import com.example.Modelos.Pelicula;
import com.example.Repositorio.PeliculaRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class PeliculaServicio {

    @Autowired
    private PeliculaRepositorio peliculaRepositorio;

    public List<PeliculaDTO> findByDirector(String nombreDirector) {
        return peliculaRepositorio.findByDirector(nombreDirector)
                .stream()
                .map(PeliculaDTO::new)
                .collect(Collectors.toList());
    }

    public List<Pelicula> findAll() {
        return peliculaRepositorio.findAll();
    }

    public List<Pelicula> findByTitulo(String nombrePelicula) {
        return peliculaRepositorio.findByTitulo(nombrePelicula);
    }

    public List<Pelicula> findPeliculasEstrenadasDespuesDe2010() {
        return peliculaRepositorio.findPeliculasEstrenadasDespuesDe2010();
    }

    public List<Pelicula> findPeliculasByActorId(List<String> ids) {
        return peliculaRepositorio.findByIdIn(ids);
    }
}

```
</TabItem>
</Tabs>
</TabItem>
<TabItem value="Controlador">
```java
package com.example;

import com.example.DTO.*;
import com.example.Modelos.*;
import com.example.Servicios.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/peliculas710")
public class Controlador {

    @Autowired
    private ActorServicio actorServicio;
    @Autowired
    private PeliculaServicio peliculaServicio;

    @GetMapping("/consulta1")
    public ResponseEntity<List<Actor>> consulta1(){
        List<Actor> listasActores = actorServicio.findAll();
        return ResponseEntity.ok(listasActores);
    }

    @GetMapping("/consulta2/{nombreDirector}")
    public ResponseEntity<List<PeliculaDTO>> consulta2(@PathVariable String nombreDirector){
        List<PeliculaDTO> listaPeliculas = peliculaServicio.findByDirector(nombreDirector);
        return ResponseEntity.ok(listaPeliculas);
    }

    @GetMapping("/consulta3")
    public ResponseEntity<List<ActorDTO>> consulta3(){
        List<ActorDTO> listaDirectores = new ArrayList<>();
        List<String> listaNombreDirectores = peliculaServicio.findAll()
                .stream()
                .map(Pelicula::getDirector)
                .toList();

        for (String nombre : listaNombreDirectores){
            List<String> listaPeliculas = peliculaServicio.findByDirector(nombre)
                    .stream()
                    .map(PeliculaDTO::getTitulo)
                    .collect(Collectors.toList());

            listaDirectores.add(new ActorDTO(nombre, listaPeliculas));
        }
        return ResponseEntity.ok(listaDirectores);
    }

    @GetMapping("/consulta4/{nombreActor}")
    public ResponseEntity<List<PeliculaDTO>> consulta4(@PathVariable String nombreActor){
        Actor actor = actorServicio.findByNombre(nombreActor).get(0);
        List<PeliculaDTO> listaPelicuals = peliculaServicio.findPeliculasByActorId(
                actor.getFilmografia()
                        .stream()
                        .map(peli -> peli.getMovie_id())
                        .toList()
                )
                .stream()
                .map(PeliculaDTO::new)
                .collect(Collectors.toList());
        return ResponseEntity.ok(listaPelicuals);
        // TODO modificar
    }

    @GetMapping("/consulta5/{nombrePelicula}")
    public ResponseEntity<List<PeliculaDTO>> consulta5(@PathVariable String nombrePelicula){
        List<PeliculaDTO> listaPeliculas = peliculaServicio.findByTitulo(nombrePelicula)
                .stream()
                .map(PeliculaDTO::new)
                .collect(Collectors.toList());
        return ResponseEntity.ok(listaPeliculas);
    }

    @GetMapping("/consulta6")
    public List<Actor> consulta6(){
        List<Pelicula> peliculas = peliculaServicio.findPeliculasEstrenadasDespuesDe2010();

        List<String> listasIds = new ArrayList<>();
        for (Pelicula pelicula : peliculas){
            for (ActorEnPelicula actor : pelicula.getActores()){
                if (!listasIds.contains(actor.getActor_id()))
                    listasIds.add(actor.getActor_id());
            }
        }

        // Obtener actores de las películas
        return actorServicio.findAllByIdIn(listasIds);
    }

    @GetMapping("/consulta7")
    public ResponseEntity<List<ActorCuentaDTO>> consulta7(){
        List<ActorCuentaDTO> listaActoresYCuenta = actorServicio.findAll()
                .stream()
                .map(actor -> new ActorCuentaDTO(actor.getNombre(), actor.getFilmografia().size()))
                .toList();
        return ResponseEntity.ok(listaActoresYCuenta);
    }
}

```	
</TabItem>
<TabItem value="Application">
```java
package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

}
```
</TabItem>
<TabItem value="application.properties">
```properties
spring.data.mongodb.uri=mongodb://localhost:27017/peliculas710
spring.data.mongodb.host=localhost
spring.data.mongodb.port=27017
server.port=8710
spring.application.name=peliculas710
springdoc.api-docs.path=/api-peliculas710
```
</TabItem>
</Tabs>
</details>