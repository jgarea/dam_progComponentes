# Entidades y Modelos
Al haber trabajado con Hibernate, mucho de los siguientes conceptos ya los conocemos, no obstante, por si se han olvidado, se hará un repaso sobre ellos.

:::tip ENTIDAD
Una entidad es una clase Java que se mapea a una tabla en una base de datos relacional.
:::

Para definir una entidad en JPA, se deben seguir los siguientes pasos:

1. **Anotar la clase Java con la anotación** ``@Entity``: Esto indica que la clase Java es una entidad que se debe mapear a una tabla en la base de datos.

2. **Especificar el nombre de la tabla en la base de datos**: se puede especificar el nombre de la tabla usando la anotación ``@Table``. Si la clase Java se llama ``Person``, por ejemplo, y se quiere mapear a una tabla llamada ``personas``, se debería usar la siguiente anotación:

```java
@Entity
@Table(name = "personas")
public class Person {
    //...
}
```

3. **Especificar el identificador de la entidad:**
   
    * Cada entidad debe tener un identificador único que se utiliza para acceder y manipular la entidad.
    * El identificador se puede especificar usando la anotación ``@Id``.
    * Es posible especificar el tipo de identificador usando otras anotaciones, como ``@GeneratedValue`` si se quiere que el identificador se genere automáticamente.

```java
@Entity
@Table(name = "personas")
public class Person {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    //...
}
```

4. **Definir los atributos de la entidad:**
    * Los atributos de la entidad corresponden a las columnas en la tabla de la base de datos.
    * Se puede especificar el nombre de la columna utilizando la anotación ``@Column``.
  
```java
@Entity
@Table(name = "personas")
public class Person {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    
    @Column(name = "nombre")
    private String name;
    
    @Column(name = "edad")
    private int age;

    //...
}
```