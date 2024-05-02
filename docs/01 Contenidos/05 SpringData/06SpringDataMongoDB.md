import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Spring Data MongoDB

Spring Data también permite utilizar base de datos MongoDB de una forma fácil y similar a cómo se emplea en MySQL.

Para la explicación se utilizará el siguiente documento que será almacenado en una colección denominada ``libros`` en MongoDB:
```json
{
  "_id": ObjectId("5f4b6de35e02b3fe72b7d83f"),
  "titulo": "Introducción a MongoDB",
  "autor": "John Doe",
  "anio_publicacion": 2020,
  "editorial": {
    "nombre": "TechBooks",
    "ubicacion": "Ciudad Tech",
    "anio_fundacion": 2005
  }
}
```

Si quisiéramos utilizarlo con Spring, lo primero que tendríamos que hacer añadir la dependencia de Spring Data MogoDB la cual puede añadirse a cualquier proyecto añadiendo al pom.xml las siguientes líneas:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-mongodb</artifactId>
</dependency>
```
Además, también será necesario establecer las configuraciones básicas en el fichero application.properties para enlazar con la base de datos Mongodb.

```properties
spring.data.mongodb.uri=mongodb://localhost:27017/nombreBd

```

De esta forma le estaremos indicando la URL de conexión y el nombre de la base de datos que se utilizará.

Acto seguido, se tendrían que crear las clases y entidades que permita describir y crear la estructura de los documentos.

Aquella clase que sería considerada Entidad en MySQL llevará la anotación ``@Document`` pudiendo añadirle a esta el nombre que tendrá la colección donde se almacenará de la siguiente forEditorialma @Document(collection = "libros").

Una vez definida la clase, se definirán las propiedades ``id``, la cual estará marcada con la anotación ``@Id``, ``titulo``, ``autor``, ``anio_publicación``. En el caso de editorial como es un elemento compuesto tendremos que crear una nueva clase denominada ``Editorial`` donde almacenaremos las propiedades: ``nombre``, ``ubicacion`` y ``anio_fundacion``.

:::warning SOBRE LOS NOMBRES DE LOS ATRIBUTOS
Si se está mapeando una colección que ya tiene documentos guardados, es importante que las propiedades se llamen exactamente igual que los campos del documento si no el mapeado no se realizará de forma automática y será necesario que hacer uso de la anotación ``@Field("nombreAtributo")`` para establecer el mapeado.

Esta anotación será ubicada justo encima de la definición de la propiedad en Java.
:::

De tal forma que el resultado de estas dos clases sería el siguiente:
<Tabs>
  <TabItem value="editorial" label="Editorial" default>
```java
package com.example.Ejemplo.Entidades;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Editorial {
    private String nombre;
    private String ubicacion;
    private int anio_fundacion;
}
    
    ```
  </TabItem>
  <TabItem value="libro" label="Libro">
  ```java	
  package com.example.Ejemplo.Entidades;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Document(collection = "libros")
public class Libro {
    @Id
    private String id;
    private String titulo;
    private String autor;
    private int anhio_publicacion;
    private Editorial editorial;
}
  ```
    </TabItem>
</Tabs>

Una vez creada las clases crearemos el repositorio. En este caso, como solo existe una clase Document, solo será necesario crear un repositorio. El respositorio que se creará se denominará LibroRepositorio y será una interfaz que extenderá de ``MongoRepository<ClaseEntidad, tipoId>`` donde:

* ClaseEntidad: define el nombre de la Entidad o Documento, en este caso, Libro
* tipoId: define el tipo de dato del atributo Id, en este caso, String.
* 
La interfaz MongoRepository es similar al funcionamiento de JpaRepository. Los métodos dentro del repositorio pueden definirse de dos formas:

* Haciendo uso de la anotación y auto construcción de métodos tal y como pasaba con Jpa.
* Haciendo uso de la anotación ``@Query``.

A continuación se muestra un ejemplo de cómo sería la implementación de este repositorio.
```java
package com.example.Ejemplo.Repositorio;

import com.example.Ejemplo.Entidades.Libro;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.util.List;
public interface LibroRepositorio extends MongoRepository<Libro, String> {

    // Método autodefinido para buscar libros por autor
    List<Libro> findByAutor(String autor);

    // Método utilizando la anotación @Query para buscar libros por año de publicación
    @Query("{ 'anio_publicacion' : ?0 }")
    List<Libro> buscarPorAnioPublicacion(int anioPublicacion);
}
```

A partir de aquí la forma de utilizar este repositorio es similar a Jpa. Sería aconsejable crear un Servicio anotado con ``@Service`` que fuera el encargado de utilizar el respositorio. A su vez, desde el controlador se implementaría el servicio.