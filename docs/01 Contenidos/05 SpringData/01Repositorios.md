# Repositorios

Aunque ya se ha mencionado como definirlos, a continuación, se mencionará un poco más en detalle qué son y los diferentes tipos que existen de repositorios.

:::tip Repositorios
Un repositorio (anotado con ``@Repository``) es una interfaz que define una colección de métodos para acceder y manipular datos en una base de datos relacional, permitiendo abstraer la capa de acceso a datos y facilita la implementación de operaciones CRUD (crear, leer, actualizar, eliminar) en la aplicación.
:::

Los métodos definidos en un repositorio son anotados con la anotación ``@Query`` que permite **definir consultas personalizadas** y personalizar las consultas generadas automáticamente. Además, Spring Data JPA proporciona una implementación predeterminada para los métodos CRUD básicos, lo que significa que no es necesario escribir código adicional para interactuar con la base de datos.

Existen diferentes ``tipos de repositorios`` en Spring Data JPA, algunos de los más comunes son:

* **CrudRepository**: es la interfaz más básica y proporciona las operaciones CRUD básicas, como guardar, eliminar, actualizar y buscar.
  
* **JpaRepository**: es una interfaz que extiende la interfaz ``CrudRepository`` y agrega funcionalidades específicas para JPA (guardar, eliminar, actualizar y buscar, además de soportar paginación y ordenamiento de los resultados).
  
* **PagingAndSortingRepository**: es una interfaz que extiende la interfaz ``CrudRepository`` y agrega soporte para paginación y ordenamiento de los resultados.
  
* **QueryDslPredicateExecutor**: es una interfaz que permite utilizar ``Querydsl`` para construir consultas dinámicas, lo que permite personalizar las consultas en tiempo de ejecución.

## Creando consultas para los repositorios
A la hora de crear consultas para un repositorio, Spring Data JPA ofrece diferentes opciones para personalizar las consultas generadas automáticamente y crear consultas personalizadas.
* **Consultas personalizadas**:
    * Se pueden crear consultas personalizadas utilizando la anotación ``@Query``.
    * Permite definir consultas personalizadas utilizando JPQL (Java Persistence Query Language) o SQL nativo.
    * Se pueden utilizar la anotación @Param para definir parámetros en la consulta.
  
* **Consultas generadas automáticamente**:
    * Genera automáticamente consultas para los métodos definidos en un repositorio.
    * Por defecto, Spring Data JPA genera consultas utilizando el **nombre del método** y los **parámetros definidos** en el método.
    * Se pueden personalizar estas consultas utilizando la anotación ``@Query``.

:::danger EJEMPLO
```java
public interface UserRepository extends JpaRepository<User, Long> {

    // Consulta personalizada utilizando JPQL
    @Query("SELECT u FROM User u WHERE u.email = ?1")
    User findByEmail(String email);

    // Consulta automática utilizando el nombre del método
    Optional<User> findByUsername(String username);
}
```
:::