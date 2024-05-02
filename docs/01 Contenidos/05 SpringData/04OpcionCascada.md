# Opción cascada

:::tip CASCADA
La opción **cascada** permite propagar una acción desde una entidad a otra relacionada.
:::

Por ejemplo, si tienes una entidad ``Libro`` y una entidad ``Autor`` y estableces una relación Uno a Varios, si configuras la cascada en la relación, cuando elimines un ``libro``, también se eliminarán todos los ``autores`` asociados.

Para configurar la cascada en una relación, debes utilizar la anotación ``CascadeType``. Por defecto, la cascada no se habilita, pero puedes agregar opciones según tus necesidades.

Algunas de las **opciones de cascada** disponibles son:

* **CascadeType.ALL**: Propaga todas las acciones (persistir, actualizar, eliminar, refrescar, fusionar y eliminar todo) a las entidades relacionadas.
* **CascadeType.PERSIST**: Propaga la acción de persistencia a las entidades relacionadas.
* **CascadeType.MERGE**: Propaga la acción de fusión a las entidades relacionadas.
* **CascadeType.REMOVE**: Propaga la acción de eliminación a las entidades relacionadas.
* **CascadeType.REFRESH**: Propaga la acción de refresco a las entidades relacionadas.
* **CascadeType.DETACH**: Propaga la acción de desconexión a las entidades relacionadas.

:::danger EJEMPLO
Si queremos configurar la cascada en una relación Uno a Muchos entre las entidades ``Equipo`` y ``Jugador``, podemos hacerlo de la siguiente manera:

```java
@Entity
public class Team {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    @OneToMany(mappedBy = "team", cascade = CascadeType.ALL)
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
    
    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "team_id")
    private Team team;

    // getters and setters
}

```
En este ejemplo, se ha establecido la opción de cascada CascadeType.ALL en ambas direcciones de la relación Uno a Muchos, lo que significa que cualquier acción realizada en una entidad se propagará automáticamente a la entidad relacionada.

:::