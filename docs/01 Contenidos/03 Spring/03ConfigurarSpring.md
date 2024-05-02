# Configurar Spring
Para ilustrar mejor los contenidos que se van a ver vamos a comenzar con la creación de un nuevo proyecto en Spring y la instalación del módulo Spring Data JPA, H2 Database y Spring Web.

El propósito del ejemplo será la creación de una lista de libros que leer

La creación del proyecto dependerá del IDE utilizado:

* Si se utiliza **Visual Studio Code**:

    * Instalar la extensión de Java: [Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack)
    * Instalar la extensión de Spring Boot Extension Pack: [Spring Boot Extension Pack](https://marketplace.visualstudio.com/items?itemName=vmware.vscode-boot-dev-pack)
    * Presionar ``Ctrl`` + ``Shift`` + ``P``: Spring Initializr: Create a Maven Project
        * Seleccionar la version: 3.2.1, por ejemplo
        * El lenguaje de programación: Java
        * El nombre de la compañía: poner tu nombre
        * Nombre del proyecto
        * Tipo de paquetes: Jar
        * Versión de Java: 17
        * Elección de dependencias:
            * Spring Data JPA (SQL)
            * Spring Web
            * MySQL Driver
            * Thymeleaf
* Si se utiliza Intellij Idea:
    * Si se dispone de la versión Ultimate ya trae incorporada la opción de creación de poyectos de Spring.
    * En caso de disponer otra versión: utilizaremos la página [Spring Initializer](https://start.spring.io/) con los siguientes parámetros:
    * Poject: Maven
    * Language: Java
    * Spring Boot: 3.2.1
    * Group: podéis poner vuestro nombre: com.nombre
    * Artifact: nombre del proyecto
    * Name: nombre del proyecto
    * Description: lo que queráis
    * Package name: com.example.nombre
    * Packaging: Jar
    * Java: 17
    * Elección de dependencias:
        * Spring Data JPA (SQL)
        * Spring Web
        * MySQL Driver
        * Thymeleaf
  * Una vez puesto todos los parámetros anteriores, generamos el proyecto: Generate
  * Movemos el archivo descargado a la ruta donde queramos almacenar el proyecto, lo descomprimimos y lo abrimos con Intellij.

:::danger EJEMPLO

Una vez creado el proyecto de Spring Boot vamos a configurar una conexión con la base de datos MySQL.

Para ello, tendremos que ir al fichero ``application.properties`` dentro de ``src/main/resources`` y añadir el siguiente contenido:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/books
spring.datasource.username=root
spring.datasource.password=abc123.
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
spring.jpa.hibernate.ddl-auto=update
```

A continuación, deberéis descargar [aquí](assets\book-a78199bfd08c71d639aeec07ce8abf25.sql) e importar en MySQL la base de datos llamada books.

En cuanto al proyecto Maven que deberíais tener creado debería ser similar a [este](assets\books_ptopartida-0e6c81b08ccb1e47fe43f2816211afca.zip)
:::
 