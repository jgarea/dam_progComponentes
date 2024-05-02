# Relaciones entre entidades

:::tip RELACION
Una **relación** es una asociación entre dos o más entidades.
:::

Hay varios tipos de relaciones que se pueden establecer entre entidades, entre los cuales se encuentran:

## Relación Uno a Uno (OneToOne):
Esta relación se establece cuando una entidad se asocia con exactamente otra entidad.

Por ejemplo, una entidad ``Persona`` podría tener una relación Uno a Uno con otra entidad ``Dirección``.

```java
@Entity
public class Person {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    // Hace referencia al nombre del atributo de la clase Address
    @OneToOne(mappedBy = "person") 
    private Address address;

    // getters and setters
}
```

```java
@Entity
public class Address {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String street;
    
    private String city;
    
    @OneToOne
    @JoinColumn(name = "person_id") // Nombre de la columna en la BD
    private Person person;

    // getters and setters
}
```

## Relación Uno a Muchos (OneToMany)
Esta relación se establece cuando una entidad se asocia con varias instancias de otra entidad.

Por ejemplo, una entidad ``Equipo`` podría tener una relación Uno a Muchos con una entidad ``Jugador``.

```java
@Entity
public class Team {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    @OneToMany(mappedBy = "team")
    private List<Player> players;

    // getters and setters
}
```

```java
@Entity
public class Player {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    private int number;
    
    @ManyToOne
    @JoinColumn(name = "team_id")
    private Team team;

    // getters and setters
}
```

## Relación Muchos a Muchos (ManyToMany)
Esta relación se establece cuando una entidad se asocia con varias instancias de otra entidad y viceversa.

Por ejemplo, una entidad ``Estudiante`` podría tener una relación Muchos a Muchos con una entidad ``Curso``.

```java	
@Entity
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    @ManyToMany(mappedBy = "students")
    private List<Course> courses;

    // getters and setters
}
```

```java
@Entity
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    @ManyToMany
    @JoinTable(
        name = "course_student",
        joinColumns = @JoinColumn(name = "course_id"),
        inverseJoinColumns = @JoinColumn(name = "student_id")
    )
    private List<Student> students;

    // getters and setters
}
```

## Relaciones de composición
Podemos usar las anotaciones ``@Embedded`` y ``@Embeddable`` para definir una relación de composición entre entidades. De esta forma, se evita crear una entidad individual.

Por ejemplo, una entidad ``Persona`` podría tener una relación de composición con una entidad ``Dirección``. Para ello, en la entidad ``Persona`` podemos agregar la anotación ``@Embedded`` de tipo ``Dirección`` y en la entidad ``Dirección`` la anotación ``@Embeddable`` (se va a embeber en otra entidad y no necesita una tabla propia ni un identificador propio)

```java
@Embeddable
public class Address {
    private String street;
    
    private String city;

    // getters and setters
}
```

```java
@Entity
public class Person {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    @Embedded
    private Address address;

    // getters and setters
}
```

