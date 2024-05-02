# Inyección de dependencias

:::tip INVERSIÓN DE CONTROL (INVERSION OF CONTROL, IOC)

La **Inversión de control** (IoC) es un principio de diseño software en el que el flujo de ejecución de un programa se invierte respecto a los métodos de programación tradicionales.
:::
En la inversión de control se especifica la respuesta deseada a un suceso o a una solicitud de datos concreta.

Se deja que algún tipo de entidad o arquitectura externa lleve a cabo las acciones de control, de tal forma que no es necesario que el programador especifique la secuencia de decisiones y procedimientos mediante las llamadas a funciones.

:::tip INYECCIÓN DE DEPENDENCIAS (DI)

La **inyección de dependencias (DI)** es un patrón de diseño orientado a objetos, en el que se suministran objetos a una clase en lugar de ser la propia clase la que cree dichos objetos.

:::

Esos objetos cumplen ciertas características que son necesarias para que nuestras clases puedan funcionar (de ahí el concepto de dependencia).

Nuestras clases no crean los objetos que necesitan, sino que se los suministra otra clase contenedora que inyectará la implementación deseada a nuestro contrato.

:::tip CONTENEDOR DE SPRING


El **contenedor Spring IoC** es el encargado de leer elementos de configuración en tiempo de ejecución y de ensamblar los Beans a través de la configuración.

:::

La **inyección de dependencia** de Spring se lograr a través del constructor, el método Setter y el dominio de entidad. Podemos hacer uso de la anotación ``@Autowired`` para inyectar la dependencia en el contexto requerido.

El **contenedor** llamará al constructor con parámetros al instanciar el Bean, y cada parámetro representa la dependencia que queremos establecer. Spring analizará cada parámetro, primero lo analizará por tipo, pero cuando sea incierto, lo analizará de acuerdo con el nombre del parámetro (obtenga el nombre del parámetro a través de ParameterNameDiscoverer, implementado por ASM).

```java
public class ProductosRestController {
    private final ProductosRepository productosRepository;

    @Autowired
    public ProductosRestController(ProductosRepository productosRepository) {
        this.productosRepository = productosRepository;
    }
}
```

A nivel de setter Spring primero instancia el Bean y luego llama al método Setter que debe inyectarse para lograr la inyección de dependencia. No recomendado

```java

public class ProductosRestController {
    private ProductosRepository productosRepository;

    @Autowired
    public void setProductosRepository(ProductosRepository productosRepository) {
        this.productosRepository = productosRepository;
    }
}
```