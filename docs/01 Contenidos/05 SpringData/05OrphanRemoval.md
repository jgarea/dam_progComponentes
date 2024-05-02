# Opción OrphanRemoval

:::tip OPCIÓN ORPHANREMOVAL
La **opción orphanRemoval** es una característica que permite eliminar automáticamente las entidades relacionadas que ya no están asociadas con la entidad padre.
:::

Esta opción tiene sentido utilizarla cuando la entidad principal es la única que debe tener la referencia a la entidad secundaria, y cuando se elimina la referencia a la entidad secundaria desde la entidad principal, la entidad secundaria ya no tiene ninguna relación con ninguna otra entidad, por lo que se puede eliminar automáticamente.

Para **habilitar la opción orphanRemoval** en JPA, debes establecerla en ``true`` en la anotación ``@OneToMany`` o ``@OneToOne``.

:::danger EJEMPLO
Si se tiene una entidad ``Empleado`` que tiene una relación ``@OneToMany`` con la entidad ``Proyecto``, y se configura la opción ``orphanRemoval = true`` en la relación.

Cuando se elimine un ``proyecto`` de la lista de proyectos de un ``empleado``, también se eliminará automáticamente el ``proyecto`` de la base de datos si no hay otra relación existente entre ese ``proyecto`` y otro ``empleado``.

```java
@Entity
public class Empleado {
    
    @Id
    @GeneratedValue
    private Long id;
    
    private String nombre;
    
    @OneToMany(mappedBy = "empleado", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Proyecto> proyectos;
    
    // getters y setters
}
```
```java
@Entity
public class Proyecto {
    
    @Id
    @GeneratedValue
    private Long id;
    
    private String nombre;
    
    @ManyToOne
    private Empleado empleado;
    
    // getters y setters
}
```
:::