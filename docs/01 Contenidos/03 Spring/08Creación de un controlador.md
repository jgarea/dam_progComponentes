# Creación de un controlador

Una vez definido la entidad de la aplicación y el repositorio para la persistencia de los objetos vamos a crear la página que mostrará la información. Para ello vamos a realizar un controlador MVC usando Spring que permita manejar consultas HTTP.

Para definir un controlador definiremos una clase en Java que tendrá la anotación ``@Controller``. Esto permite que Spring automáticamente lo detecte y cree un Bean de la clase en el contexto de aplicación Spring. Además, se usará la anotación ``@RequestMapping`` para indicar la URL base de la aplicación.

## Creación de métodos
Los métodos del controlador podrán recibir y procesar valores mediante los métodos utilizado en HTTP que se mencionaron en apartados anteriores.

Para indicar qué método se va a utilizar así como indicar los parámetros de entrada se utilizará la anotación ``@RequestMapping``, el cual tendrá la siguiente estructura:
```java
@RequestMapping(value="/{reader}", method= RequestMethod.GET)

@RequestMapping(value="/{reader}", method= RequestMethod.POST)
```

Por otro lado, para coger el valor ``/{reader}`` y parsearlo a una variable del método se utilizará la anotación ``@PathVariable("reader")``.

Veamos lo anterior, siguiendo con nuestro ejemplo.

:::danger CONTINUACIÓN EJEMPLO


Para ello vamos a crear el controlador que se llamará ReadingListController el cual tendrá la siguiente estructura:
<details>
<summary>ReadingListController.java</summary>
```java title="ReadingListController.java"

package com.jose.proyecto1;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.List;

@Controller
@RequestMapping("/")
public class ReadingListController {

    @Autowired
    private ReadingListRepository readingListRepository;

    public ReadingListController(ReadingListRepository readingListRepository) {
        this.readingListRepository = readingListRepository;
    }

    @RequestMapping(value="/{reader}", method= RequestMethod.GET)
    public String readersBooks(@PathVariable("reader") String reader, Model model) {
        List<Book> readingList = readingListRepository.findByReader(reader);
        if (readingList != null) {
            model.addAttribute("books", readingList);
        }
        return "readingList";
    }

    @RequestMapping(value="/{reader}", method=RequestMethod.POST)
    public String addToReadingList(@PathVariable("reader") String reader, Book book) {
        book.setReader(reader);
        readingListRepository.save(book);
        return "redirect:/{reader}";
    }
}

```
</details>

Como se puede observar usamos las anotaciones ``@Controller`` para indicar que es un controlador y ``@RequestMapping("/")`` para indicar que la ruta raíz será ``/``.

Además, el controlador tiene dos métodos:

* ``readersBook()``: maneja peticiones GET donde recibirá un lector en ``/{reader}`` hará un parseo del valor recibido como parámetro de la función y buscará el libro en cuestión.
* ``addToReadingList()``: maneja peticiones POST parseando el lector recibido en ``/{reader}`` a la variable del método y almacenando el lector.

El método ``readersBook`` devuelve ``readingList`` lo cual es el nombre de una vista lógica. Por consiguiente, es necesario crear dicha vista. Para facilitar el desarrollo vamos a utilizar ``Thymeleaf`` para la definición de vistas.

Este podía haberse añadido en la creación del proyecto en Spring Initializr o bien añadiendo la siguiente dependencia en el ``pom.xml`` de Maven y actualizando:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
    <version>3.2.1</version>
</dependency>
```
Para ello crearemos el fichero ``readingList.html`` en la carpeta ``src/main/resources/templates`` con el siguiente contenido:
<details>
<summary>readingList.html</summary>

```html
<html>
    <head>
        <title>Reading List</title>
        <link rel="stylesheet" th:href="@{/css/style.css}"/>
    </head>
    <body>
        <h2>Your Reading List</h2>
        <div th:unless="${#lists.isEmpty(books)}">
            <dl th:each="book : ${books}">
                <dt class="bookHeadline">
                    <span th:text="${book.title}">Title</span> by
                    <span th:text="${book.author}">Author</span>
                    (ISBN: <span th:text="${book.isbn}">ISBN</span>)
                </dt>
                <dd class="bookDescription">
                    <span th:if="${book.description}" th:text="${book.description}">Description</span>
                    <span th:if="${book.description eq null}">No description available</span>
                </dd>
            </dl>
        </div>
        <div th:if="${#lists.isEmpty(books)}">
            <p>You have no books in your book list</p>
        </div>
        <hr/>
        <h3>Add a book</h3>
        <form method="POST">
            <label for="title">Title:</label>
            <input type="text" name="title" size="50"/><br/>
            <label for="author">Author:</label>
            <input type="text" name="author" size="50"/><br/>
            <label for="isbn">ISBN:</label>
            <input type="text" name="isbn" size="15"/><br/>
            <label for="description">Description:</label><br/>
            <textarea name="description" cols="80" rows="5"></textarea><br/>
            <input type="submit"/>
        </form>
    </body>
</html>
```
</details>

También se podría crear un css llamado ``style.css`` para darle formato que habría que guardar dentro de ``resources/static/css``.
<details>
<summary>style.css</summary>
```css
body {
    background-color: #cccccc;
    font-family: arial, helvetica, sans-serif;
}
.bookHeadline {
    font-size: 12pt;
    font-weight: bold;
}
.bookDescription {
    font-size: 10pt;
}
label {
    font-weight: bold;
}
```
</details>

Una vez añadido se ejecutará el sistema y se accederá a la URL localhost:8080/Reader 1

Si alguien se perdió en algún paso [aquí](assets\books_final_con_servicio-42cbf31b0c675acbd87fe5cc5a5776c5.zip) podéis descargar un ejemplo del proyecto finalizado utilizando un servicio o bien esta [versión](assets\books_final-03f40c4119b42d5feef4db83429ca2f2.zip) donde se omite la creación del servicio.

:::



