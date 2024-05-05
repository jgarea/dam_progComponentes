import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Lombok

:::success LOMBOK
**Lombok** es una librería utilizada para el desarrollo en Java cuyo objetivo es evitar la escritura de código técnico repetitivo (el famoso boilerplate).
:::

Para el uso de Lombok solo será necesario añadir al pom.xml de maven la siguiente dependencia:

```xml	
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.30</version>
    <scope>provided</scope>
</dependency>
```

Su funcionamiento consiste en utilizar ciertas anotaciones a la hora de definir las clases que inyectarán código en la fase de compilación.

Dentro de las anotaciones más utilizadas están las siguientes:

* ``@Data``: usando esta anotación se genera en tiempo de compilación:

    * Los getters y setters para todos los campos,
    * El método ``toString``,
    * El método ``hashCode``,
    * El método ``equals``
    * Un constructor.

* ``@AllArgsConstructor``: permite generar en tiempo de compilación un constructor con todos los parámetros.

* ``@NoArgsConstructor``: permite generar en tiempo de compilación un constructor sin parámetros.

* ``@RequiredArgsConstructor``: permite generar un constructor personalizado con todos aquellos marcados como ``final`` o que tengan la anotación ``@NotNull``.

* ``@Builder``: permite una nueva forma de crear nuevos objetos diferente al típico ``new``.

* ``@SuperBuilder``: es la alternativa a ``@Builder`` cuando se quiere establecer una relación de herencia entre clases. Toda superclase debe tener esta anotación para que no se generen problemas a la hora de generar relaciones de herencia.

:::danger EJEMPLO BÁSICO
Se pide crear una clase Persona que tenga las siguientes propiedades: ``id``, ``nombre``, ``edad`` y ``direccion``. Se deberán implementar getters, setters, el constructor vacío, el constructor con todos los parámetros y un constructor con los tres últimos parámetros

<details>
<summary>Solución</summary>

<Tabs>
<TabItem value="Usando Lombok">
```java
import lombok.RequiredArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@RequiredArgsConstructor
public class Persona {

  private int id;
  @NonNull
  private String nombre;
  @NonNull
  private int edad;
  @NonNull
  private String direccion;

}
```
</TabItem>
<TabItem value="Sin usar Lombok">
```java
public class Persona {

  private int id;
  private String nombre;
  private int edad;
  private String direccion;

  public Persona() {
  }

  public Persona(String nombre, int edad, String direccion) {
      this.nombre = nombre;
      this.edad = edad;
      this.direccion = direccion;
  }

  public Persona(int id, String nombre, int edad, String direccion) {
      this.id = id;
      this.nombre = nombre;
      this.edad = edad;
      this.direccion = direccion;
  }

  public int getId() {
      return id;
  }

  public void setId(int id) {
      this.id = id;
  }

  public String getNombre() {
      return nombre;
  }

  public void setNombre(String nombre) {
      this.nombre = nombre;
  }

  public int getEdad() {
      return edad;
  }

  public void setEdad(int edad) {
      this.edad = edad;
  }

  public String getDireccion() {
      return direccion;
  }

  public void setDireccion(String direccion) {
      this.direccion = direccion;
  }
}

```
</TabItem>
</Tabs>
</details>

:::

:::danger EJEMPLO DE HERENCIA USANDO LOMBOK
Si se quiere establecer una relación de herencia entre dos clases usando Lombok se haría de la siguiente forma


<details>
<summary>Herencia</summary>

<Tabs>
<TabItem value="Clase padre">
```java
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@RequiredArgsConstructor
@SuperBuilder
public class Persona {

  private int id;
  @NonNull
  private String nombre;
  @NonNull
  private int edad;
  @NonNull
  private String direccion;

}
```
</TabItem>
<TabItem value="Clase Hijo">
```java
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Estudiante extends Persona{
  private String curso;
}
```
</TabItem>

</Tabs>
</details>

:::

:::danger EJEMPLO DE USO DE @BUILDER
El uso de la anotación ``@Builder`` ofrece otra forma de crear los objetos diferente al tradicional ``new``.

La principales ventajas de usar esta anotación son:

* No es necesario introducir los valores de los atributos en el mismo orden en el que están definidos en el constructor.
* Queda más claro a qué atributo de la clase se le está asignado qué valor.

<details>
<summary>Crear un objeto vacio</summary>

<Tabs>
<TabItem value="Crear un objeto vacio">
<Tabs>
<TabItem value="Usando Lombok">
```java
Persona persona = Persona.builder().build();
```
</TabItem>
<TabItem value="Sin usar Lombok">
```java
Persona persona = new Persona();
```
</TabItem>
</Tabs>
</TabItem>
<TabItem value="Crear un objeto con parámetros">
<Tabs>
<TabItem value="Usando Lombok">
```java
Persona persona = Persona.builder()
                    .id(1)
                    .nombre("Persona 1")
                    .direccion("Direccion 1")
                    .edad(45)
                    .build();
```
</TabItem>
<TabItem value="Sin Lombok.">
```java
Persona persona = new Persona(1, "Persona 1", "Direccion 1", 45);
```
</TabItem>
</Tabs>
</TabItem>
</Tabs>
</details>
:::

:::danger EJEMPLO DE @REQUIREDARGSCONSTRUCTOR
Sin ``@RequiredArgsConstructor`` el siguiente ejemplo daría error, con él funcionaría sin problema

<details>
<summary>Ejemplo.java</summary>

```java
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class Ejemplo {

    private final Persona persona;
    // Sin @RequiredArgsConstructor se genera un error en la línea anterior porque requiere inicialización

    public void createPersona(Casa casa){

    }

}
```
</details>
:::