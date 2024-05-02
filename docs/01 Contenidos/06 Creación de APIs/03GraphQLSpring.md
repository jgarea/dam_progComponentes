# GraphQL con Spring

## GraphQL
Como se ha visto, GraphQL es un nuevo paradigma para la realización de una API.

A la hora de implementar GraphQL es necesario tener en cuenta los siguientes aspectos:

1. Anotaciones utilizadas: GraphQL emplea muchas de las anotaciones que ya se han visto en la unidad. Sin embargo, añade algunas más para ofrecer más funcionalidades. Dentro de estas anotaciones, las más importantes son las siguientes:

    * ``@QueryMapping``: sirve para marcar que un método va a ser el encargado de responder una consulta. Similar a ``@PostMapping``, etc, en API REST.
    * ``@MutationMapping``: sirve para definir métodos que van a modificar datos de la base de datos, usaremos este tipo de anotación cuando definamos operaciones CRUD.
    * ``@Argument``: permite indicar que un parámetro de un método va a tomar su valor de uno de los campos que el usuario mandará en su petición de consulta. Es similar a ``@RequestBody`` o ``@PathVariable`` en API REST.

2. Creación del fichero ``schema.graphqls``:
   * Este fichero se creará en la ruta ``resources/graphql/``
   * Es el fichero principal de GraphQL ya que en él se deberán definir todas las consultas y mutuaciones. En él también deberán estar definidos los tipos de datos complejos que se utilizarán para el envío y recepción de información.

3. Mutation vs query:
   * **Mutation**:
        * Se marcarán en el Controller con la notación ``@MutationMapping``.
        * Serán aquellos métodos que afecten directamente sobre los datos mediante su modificación, actualización o eliminación.
        * Su estructura de definición en el fichero ``schema.graphqls`` sería la siguiente:
        ```graphql
        type Mutation{ 
            nombreFunciónMutation(
                param1 : type1,
                param2 : type2,
                ...
            ) : typeOutput
        } 
        ```
        * Un ejemplo de ejecución sería el siguiente:
        ```graphql
        mutation {
            nombreFunciónMutation (
                param1 : valor1,
                param2 : valor2,
                ...
            ){
                // Campos de typeOutput que se quieren devolver
            }
        }
        ```
        * **Query**
            * Se marcarán en el Controller con la notación ``@QueryMapping``.
            * Serán aquellos métodos o funciones que se utilizan para listar información, sin modificar los datos.
            * Su estructura de definición en el fichero ``schema.graphqls`` la siguiente: 
            ```graphql
            type Query{
                nombreFunciónQuery (
                    param1 : type1,
                    param2 : type2, 
                    ...
                ) : typeOutput,
            }
            ```
            * Un ejemplo de ejecución sería el siguiente:
            ```graphql
            query {
                nombreFunciónQuery (
                    param1 : valor1,
                    param2 : valor2,
                    ...
                )
            }
            ```
:::warning IMPORTANTE SOBRE MUTATION Y QUERY
Es importante tener claro que el nombre de las funciones y de los parámetros que aparecen en el fichero ``schema.graphqls`` deber ser **exactamente igual** al nombre de las funciones y de sus parámetros cuando se definan en el controlador en Java.

Por ejemplo, si se define la función: ``nombreFunciónQuery (param1 : valor1, param2 : valor2)`` en el fichero ``schema.graphqls`` significará que habrá un función en el controlador que esté marcada como ``@QueryMapping`` que se llamará ``nombreFunciónQuery`` y sus parámetros se llamarán ``param1`` y ``param2``.

En el caso de que no se llamen exactamente igual, **el sistema no funcionará**
:::

4. Definición de tipos compuestos en el fichero ``schema.graphqls``.
   * Si se van utilizar objetos es necesario definirlos en Java y en este fichero para ello se utiliza la siguiente anotación:
    ```graphql
        type nombreObjeto {
            param1 : String, // Definición de una cadena de caracteres
            param2 : Float, // Definición de un double o float
            param3 : Int, // Definición de un entero obligatorio
            param4 : Int!, // Definición de un entero opcional
            param5 : nombreObjeto2, // Definición de un parámetro de un tipo compuesto
            param6: [nombreObjeto2] // Definición de un array de tipo compuesto
        }
    ```

    * Si se supone que una Query o Mutation devuelven el tipo anterior, se pueden devolver datos individuales de la siguiente manera:
    ```graphql
    // Definición de la Query en cuestión que devuelve el objeto creado
    type Query{
        nombreFunciónQuery (
            param1 : type1,
            param2 : type2, 
            ...
        ) : nombreObjeto,
    }
    ```

    ```graphql
    // Ejecución de la consulta obteniendo ciertos valores
    query{
        nombreFunciónQuery (
            param1 : valor1, 
            param2 : valor2,
            ...
        ){
            param1, param3, param5 { // Param5 era otro objeto
                nombreObjeto2param1, nombreObjeto2param3 // Obtenemos ciertos parámetros del otro objeto.
            }
        }
    } 
    ```

:::info INFORMACIÓN A MAYORES
Si se quiere investigar en profundidad sobre este nuevo lenguaje de consultas, se puede consultar la siguiente [guía oficial](https://graphql.org/learn/)
:::

5. Interfaz gráfica para la realización y prueba de consultas GraphQL en Spring. Modificando el fichero ``application.properties`` añadiéndole la siguiente línea:
```
spring.graphql.graphiql.enabled=true
```
Spring desplega una URL en donde hay una interfaz gráfica en dónde se pueden probar las consultas y sus resultados. Esta URL es la siguiente: localhost:8080/graphiql


## Creación de la API GraphQL con Spring
Para realizar la explicación de estos conceptos, se buscará crear una API GraphQL que permita realizar un CRUD básico sobre una base de datos con dos tablas ``Productos`` y ``Categoría``.

En primer lugar, se crea un proyecto nuevo de Spring Initializr con las siguientes dependencias:

* MySQL Driver
* Spring Data JPA
* Spring for GraphQL
* Spring Web
* Rest Repositories
* Lombok

:::info EJEMPLO DE PROYECTO VACÍO
[Aquí](assets\inventario-graphql-70f71810fe313d00dedfe13e02bad04f.zip) puedes descargar el proyecto vacío con las dependencias cargadas con el que se comienza la explicación.

:::

1. **Creamos las entidades** de la base de datos y la relación que se establece entre ellas (Una relación una a varios):
<details>
<summary>Producto.java</summary>

```java
package com.example.graphql.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Producto {

    @Id
    private String id;

    private String nombre;
    private double precio;
    private int cantidad;

    @ManyToOne
    private Categoria categoria;
}

```
</details>

<details>
<summary>Categoria.java</summary>

```java
package com.example.graphql.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Categoria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nombre;

    @OneToMany(mappedBy = "categoria")
    private List<Producto> productos;
}

```
</details>

2. **Creamos los repositorios**:
<details>
<summary>CategoriaRepository.java</summary>

```java
package com.example.graphql.repository;

import com.example.graphql.entities.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoriaRepository extends JpaRepository<Categoria, Long> {
}


```
</details>

<details>
<summary>ProductoRepository.java</summary>

```java
package com.example.graphql.repository;

import com.example.graphql.entities.Producto;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductoRepository extends JpaRepository<Producto, String> {
}


```
</details>

3. ``Modificamos el fichero de configuración`` de Spring para crear una base de datos ``graphqlbd`` y habilitar la interfaz gráfica para probar las consultas GraphQL.
<details>
<summary>application.properties</summary>

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/graphqlbd?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=abc123.
spring.jpa.database-platform=org.hibernate.dialect.MySQLDialect
spring.jpa.hibernate.ddl-auto=update
spring.graphql.graphiql.enabled=true
```
</details>

El parámetro ``spring.graphql.graphiql.enabled=true`` permite habilitar una interfaz en la ruta ``/graphiql`` una vez se ejecute el proyecto.

4. **Añadimos datos aleatorios** para poder probar el sistema. Para ello utilizaremos la propia clase ``Main`` del proyecto.
<details>
<summary>GraphqlApplication.java</summary>

```java
package com.example.graphql;

import com.example.graphql.entities.Categoria;
import com.example.graphql.entities.Producto;
import com.example.graphql.repository.CategoriaRepository;
import com.example.graphql.repository.ProductoRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.List;
import java.util.UUID;

@SpringBootApplication
public class GraphqlApplication {

	public static void main(String[] args) {
		SpringApplication.run(GraphqlApplication.class, args);
	}

	// Creamos categorias y productos aleatorios para hacer pruebas
	@Bean
	CommandLineRunner commadnLineRunner(CategoriaRepository categoriaRepository, ProductoRepository productoRepository){
		return  args -> {
			List.of("Ordenador", "Impresoras", "SmartPhones").forEach(cat ->{
				Categoria categoria = Categoria.builder().nombre(cat).build();
				categoriaRepository.save(categoria);
			});
			categoriaRepository.findAll().forEach(categoria -> {
				for(int i = 0; i < 10; i++){
					Producto producto = Producto.builder().id(UUID.randomUUID().toString())
							.nombre("Ordenador" + i)
							.precio(100 + Math.random() * 500)
							.cantidad((int)(Math.random() * 100) + 1)
							.categoria(categoria)
							.build();
					productoRepository.save(producto);
				}
			});
		};
	}
}
```
</details>

5. **Creación de una clase para manejar la actualización** de todos los parámetros del ``Producto`` y el ``id`` de ``Categoria``
<details>
<summary>ProductoyCategoriaRequest.java</summary>

```java
package com.example.graphql.entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductoyCategoriaRequest{
    private String id;
    private String nombre;
    private double precio;
    private int cantidad;
    private Long categoriaId;
}

```
</details>

:::warning PORQUÉ ES NECESARIA LA ENTIDAD PRODUCTOYCATEGORIAREQUEST

Como se verá a la hora de crear los métodos en el controlador (siguiente paso) se han creado dos métodos para guardar: ``guardarProducto`` y ``guardarProductoyCategoria``.

Con el primero se añade un producto pero el ``id`` de la categoría aparecerá a null. La segunda opción contempla recibir el ``id`` de categoría en la base de datos, por lo tanto, ya no aparecerá a null si no al valor introducido.
:::

:::info SOBRE LA ENTIDAD PRODUCTOYCATEGORIAREQUEST
La clase anterior, podría o bien ser una clase, tal y como se ha definido o bien podríamos usar un ``record`` de Java. De tal forma que el resultado sería el siguiente:
<details>
<summary>ProductoyCategoriaRequest.java</summary>

```java
package com.example.graphql.entities;

public record ProductoyCategoriaRequest(
        String id,
        String nombre,
        double precio,
        int cantidad,
        Long categoriaId
) {
}

```
</details>

Ambas opciones serían válidas. No obstante, elegir una u otra cambiará la forma en la que se accede a las variables de la clase/record.

:::

6. **Creamos el Controller**
<details>
<summary>ProductoGrpahQLController.java</summary>

```java
package com.example.graphql.controllers;

import com.example.graphql.entities.Categoria;
import com.example.graphql.entities.Producto;
import com.example.graphql.entities.ProductoyCategoriaRequest;
import com.example.graphql.repository.CategoriaRepository;
import com.example.graphql.repository.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;

@Controller
public class ProductoGrpahQLController {

    @Autowired
    private ProductoRepository productoRepository;

    @Autowired
    private CategoriaRepository categoriaRepository;

    @QueryMapping
    public List<Producto> listarProductos(){
        return productoRepository.findAll();
    }

    @QueryMapping
    public Producto listarProductoPorId(@Argument String id){
        return productoRepository.findById(id).orElseThrow(
                () -> new RuntimeException(String.format("Producto %s no encontrado", id))
        );
    }

    @QueryMapping
    public List<Categoria> listarCategorias(){
        return categoriaRepository.findAll();
    }

    @QueryMapping
    public Categoria listarCategoriaPorId(@Argument Long id){
        return categoriaRepository.findById(id).orElseThrow(
                () -> new RuntimeException(String.format("Categoria %s no encontrado", id))
        );
    }

    @MutationMapping
    public Producto guardarProducto(@Argument Producto producto){
        producto.setId(UUID.randomUUID().toString());
        return productoRepository.save(producto);
    }

    @MutationMapping
    public Producto guardarProductoyCategoria(@Argument ProductoyCategoriaRequest productoRequest){
        Categoria categoria = categoriaRepository.findById(productoRequest.getCategoriaId()).orElse(null);
        Producto producto = new Producto();
        producto.setId(UUID.randomUUID().toString());
        producto.setNombre(productoRequest.getNombre());
        producto.setPrecio(productoRequest.getPrecio());
        producto.setCantidad(productoRequest.getCantidad());
        producto.setCategoria(categoria);

        return productoRepository.save(producto);
    }

    @MutationMapping
    public Producto actualizarProducto(@Argument String id, @Argument ProductoyCategoriaRequest productoRequest){
        Categoria categoria = categoriaRepository.findById(productoRequest.getCategoriaId()).orElse(null);
        Producto producto = new Producto();
        producto.setId(id);
        producto.setNombre(productoRequest.getNombre());
        producto.setPrecio(productoRequest.getPrecio());
        producto.setCantidad(productoRequest.getCantidad());
        producto.setCategoria(categoria);

        return productoRepository.save(producto);
    }

    @MutationMapping
    public void eliminarProducto(@Argument String id){
        productoRepository.deleteById(id);
    }
}
```
</details>

Con la anotación ``@QueryMapping`` indicamos que vamos a crear una consulta y con ``@MutationMapping`` indicamos que es una mutación.

7. ``Creamos el schema``: Por defecto, si se importa la dependencia GraphQL (a la hora de crear el proyecto de Spring) se crea dentro de la carpeta ``resources`` una carpeta llamada ``graphql``. Dentro de esta carpeta es dónde se definen los esquemas a realizar.
   * En este caso se creará un schema que permita utilizar la función ``listarProductos`` para ello el schema se definirá de la siguiente forma
    <details>
    <summary>schema.graphqls</summary>

    ```graphql
    type Mutation{
        guardarProducto(producto: ProductoRequest) : Producto
        guardarProductoyCategoria(productoRequest : ProductoyCategoriaRequest) : Producto
        actualizarProducto(id : String, productoRequest: ProductoyCategoriaRequest) : Producto
        eliminarProducto(id : String) : String
    }

    type Query{
        listarProductos : [Producto],
        listarProductoPorId(id : String) : Producto,
        listarCategorias : [Categoria],
        listarCategoriaPorId(id : Float): Categoria
    }

    type Producto {
        id: String,
        nombre : String,
        precio : Float,
        cantidad : Int,
        categoria: Categoria
    }

    type Categoria{
        id : Float,
        nombre : String
        productos : [Producto]
    }

    input ProductoRequest{
        nombre : String,
        precio : Float,
        cantidad: Int
    }

    input ProductoyCategoriaRequest{
        nombre : String,
        precio : Float,
        cantidad: Int,
        categoriaId : Float
    }
    ```
    </details>
   * El esquema anterior procesa de la siguiente forma:
        * Vamos a crear una consulta, para ello es necesario crear un tipo ``Query``. Dentro de ese Query tenemos una consulta creada llamada ``listarProductos`` este nombre debe ser exactamente el mismo qeu el que hay en el Controller.
        * La consulta va a devolver un array de elementos de tipo ``Producto``.
        * Creamos el tipo producto con todas las opciones de datos que puede devolver junto con su tipo.
        * Como devuelve un tipo ``Categoria`` es necesario crear el tipo ``Categoria`` con los atributos de la que esta dispone.

8. **Prueba de la consulta**. Para ello como hemos habilitado la interfaz gráfica, podemos acceder a localhost:8080/graphiql. En ella podemos realizar consultas de prueba. A continuación, se realizarán algunas consultas de ejemplo

    1. Listar el ``id`` y ``nombre`` de los productos:
    ```graphql
    query{
        listarProductos{
            id, nombre
        }
    }
    ```

    2. Listar el ``id`` y ``nombre`` de los producto y de su categoria:
    ```graphql
    query{
        listarProductos{
            id, nombre, categoria {
            id, nombre
            }
        }
    }
    ```

    3. Mostrar el ``nombre``, ``precio`` de un producto por su ``id``
    ```graphql
    query{
        listarProductoPorId (id : "01e70d98-db14-431a-a468-a35e239ab9d7"){
            id, nombre
        }
    } 
    ```

    4. Guardar un nuevo producto y devolver el ``id``, ``nombre``, ``precio`` y ``cantidad`` del producto creado
    ```graphql
    mutation{
        guardarProducto(
            producto :{
            nombre:"P12",
            precio :200,
            cantidad : 4
        }){
            id, nombre, precio, cantidad
        }
    }
    ```

    5. Guardar producto y categoria y devolver el ``id``, ``nombre``, ``precio`` y ``cantidad`` del producto creado y el ``id`` y ``nombre`` de su categoria
    ```graphql
    mutation{
        guardarProductoyCategoria(
            productoRequest :{
            nombre:"P20",
            precio :400,
            cantidad : 4,
            categoriaId :1,
        }){
            id, nombre, precio, cantidad, categoria{
                id, nombre
            }
        }
    }
    ```
    6. Actualizar un producto por su id y mostrar el id, nombre, precio y cantidad del producto creado y el id y nombre de su categoria
    ```graphql
    mutation{
        actualizarProducto(id :"ae7ec3b0-803a-4e2d-ae19-d2ba95874a0e",
        productoRequest: {
            nombre:"Ordenador 123",
            precio : 543,
            cantidad:2,
            categoriaId :3
        }){
            id, nombre, precio, cantidad, categoria{
            nombre
            }
        }
    }
    ```
    7. Eliminar producto por id.
    ```graphql
    mutation{
        eliminarProducto(id:"ae7ec3b0-803a-4e2d-ae19-d2ba95874a0e")
    }
    ```

## Gestión de errores
En el caso de que una consulta genere un error y se quiera personalizar el mensaje de error devuelto lo que podemos hacer es crear un paquete ``exceptions`` dentro del cual crearemos una clase llamada ``GraphQLExceptionHandler`` que será una clase definida como componente (``@Component``) que extenderá de ``DataFetcherExceptionResolverAdapter``.

A continuación se muestra un ejemplo:
<details>
<summary>GraphQLExceptionHandler.java</summary>

```java
package com.example.graphql.exceptions;

import graphql.ErrorClassification;
import graphql.GraphQLError;
import graphql.language.SourceLocation;
import graphql.schema.DataFetchingEnvironment;
import org.springframework.graphql.execution.DataFetcherExceptionResolverAdapter;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class GraphQLExceptionHandler extends DataFetcherExceptionResolverAdapter {

    @Override
    protected GraphQLError resolveToSingleError(Throwable ex, DataFetchingEnvironment env) {
        return new GraphQLError() {
            @Override
            public String getMessage() {
                return ex.getMessage();
            }

            @Override
            public List<SourceLocation> getLocations() {
                return null;
            }

            @Override
            public ErrorClassification getErrorType() {
                return null;
            }
        };
    }
}
```
</details>

De esta forma cuando se genere un nuevo error, por ejemplo, que en las consultas anteriores el id no sea el correcto, se mostrará el mensaje personalizado que se hubiera añadido en la cláusula ``orElseThrow``.

:::danger VIDEO EXPLICATIVO
Toda la información de este tutorial fue obtenido del siguiente vídeo donde se explica de forma clara y concisa todo el proceso en detalle.

<iframe width="560" height="315" src="https://www.youtube.com/embed/k9MnNurpNlc?si=pv7nrPnv4SOWJwm9" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

:::
