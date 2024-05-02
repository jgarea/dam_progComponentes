# Definición de un repositorio
Lo siguiente que hay que hacer es crear la interfaz repositorio, la cual será marcada con la interfaz ``@Repository``.

:::tip REPOSITORIO


Básicamente, un repositorio reúne todas las operaciones de datos para un tipo de dominio determinado en un solo lugar.

:::
La aplicación se comunica con el repositorio en el lenguaje de dominio y el repositorio, a su vez, se comunica con el almacén de datos mediante una consulta.

Sin Spring Data tendríamos que escribir la traducción a mano. Sin embargo, Spring Data ya ofrece los medios para leer los metadatos de la información almacenada y crear una consulta.

Para definir un repositorio es necesario crear una interfaz en Java que extienda la interfaz ``JpaRepository`` la cual recibirá dos parámetros:

* La entidad o dominio que se va a utilizar.
* El tipo de dato del Id.

Una de las ventajas de extender la interfaz ``JpaRepository`` es que esta viene con un conjunto de funciones CRUD que evita que tengamos que ser nosotros los que las definamos.

Una vez creado el repositorio la siguiente pregunta que uno se puede estar haciendo es: ¿quién va a implementar este repositorio? Aquí es donde está la magia que ofrece utilizar Spring Data ya que nos ofrece la posibilidad de definir el repositorio solo con la interfaz ya que esta será implementada automáticamente en tiempo de ejecución cuando la aplicación se ejecute. Para que esto se realice utilizaremos la anotación ``@Autowired``.

:::danger CONTINUACIÓN EJEMPLO

Vamos a crear el repositorio que se llamará ``ReadingListRepository`` la cual tendrá la siguiente estructura:

```java title="ReadingListRepository.java"	
package com.jose.proyecto1;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

@Repository
public interface ReadingListRepository extends JpaRepository<Book, Long> {
    List<Book> findByReader(String reader);
}

```
Como se puede observar la interfaz ``ReadingListRepository`` extiendo de ``JpaRepository`` indicando dos valores:

``Book``: haciendo referencia a la entidad o al dominio creado anteriormente
``Long``: haciendo referencia al tipo de dato del Id

Además, se ha creado un nuevo método ``findByReader`` para buscar un libro por su lector. Al haber asignado el nombre en inglés, Spring Boot detecta que es un método ``findBy`` que busca el atributo ``Reader`` por lo que internamente se hará la siguiente traducción:

```sql
select book.* from Book book where book.reader = ?1
```

Además, esta traducción ya se encarga de evitar posibles inyecciones SQL y pasea todas las líneas recibidas a objetos del tipo Book.
:::