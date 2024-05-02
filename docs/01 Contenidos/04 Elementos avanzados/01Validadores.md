# Validadores

:::tip Validadores
Los **validadores** son clases que se encargan de validar los datos que nos llegan y lanzar excepciones en caso de que no sean correctos.

:::
Existen dos posibilidades:

## 1. Crear una clase que se encargue de validar los datos
Por ejemplo, los datos de una raqueta:

```java
public class RaquetaValidator {

    public void validate(Raqueta raqueta) {
        if (raqueta.getMarca() == null || raqueta.getMarca().isBlank()) {
            throw new InvalidRaquetaException("La marca no puede ser nula o estar en blanco");
        }
        if (raqueta.getModelo() == null || raqueta.getModelo().isBlank()) {
            throw new InvalidRaquetaException("El modelo no puede ser nulo o estar en blanco");
        }
        if (raqueta.getPrecio() == null || raqueta.getPrecio() < 0) {
            throw new InvalidRaquetaException("El precio no puede ser nulo o negativo");
        }
    }
}

```

## 2. Utilizar el sistema de validación de Spring
Se puede usar el sistema de validación de Spring, que permite validar los datos de una forma más sencilla. Para ello, se deben añadir la dependencia de Spring Validation:

```java
<!-- Starter de Spring Validation -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
    <version>3.2.1</version>
</dependency>
```

De esta manera podemos usar las anotaciones de validación de Spring. Dentro de estas anotaciones destacamos las siguientes:

* ``@NotNull``: indica que el atributo no puede ser nulo.
* ``@Size``: indica el tamaño mínimo y/o máximo permitido para un atributo de tipo String o Collection.
* ``@Min`` y ``@Max``: indican el valor mínimo y/o máximo permitido para un atributo numérico.
* ``@Email``: indica que el atributo debe ser una dirección de correo electrónico válida.
* ``@Past`` y ``@Future``: indican que un atributo de tipo Date o Calendar debe ser una fecha en el pasado o en el futuro, respectivamente.
* ``@Pattern``: indica un patrón que debe cumplir un atributo de tipo String.
* ``@DecimalMin`` y ``@DecimalMax``: indican el valor mínimo y/o máximo permitido para un atributo de tipo BigDecimal.
* ``@NotEmpty``: indica que un atributo de tipo String, Collection o Map no puede ser vacío.

:::danger EJEMPLO
```java	
public class TenistaRequestDto {
    @NotBlank(message = "El nombre no puede estar vacío")
    private String nombre;
    @Min(value = 0, message = "El ranking no puede ser negativo")
    private Integer ranking;
    @NotBlank(message = "El país no puede estar vacío")
    private String pais;
    private String imagen;
    @Min(value = 0, message = "El id de la raqueta no puede ser negativo")
    private Long raquetaId; // Id de la raqueta, puede ser null
}
```
:::

Ahora si se quieren validar los datos de un DTO, se puede utilizar ``@Valid`` en el parámetro del método:

```java
@PostMapping("")
public ResponseEntity<TenistaResponseDto> postTenista(@Valid @RequestBody TenistaRequestDto tenista
) {
    log.info("addTenista");
    return ResponseEntity.created(null).body(
            tenistaMapper.toResponse(
                    tenistasService.save(tenistaMapper.toModel(tenista)))
    );
}
```

## Añadir el Handler
No se debe de olvidar añadir una clase handler anotada con @ExceptionHandler y el código de error que capturará. En este caso, se va a mostrar un ejemplo donde se captura el error cuando se produzca una mala solicitud, para ello utilizaremos la siguiente anotación @ResponseStatus(HttpStatus.BAD_REQUEST). De esta forma, el controlador capturará esta excepción y la procesará:

```java
 // Para capturar los errores de validación
@ResponseStatus(HttpStatus.BAD_REQUEST)
@ExceptionHandler(MethodArgumentNotValidException.class)
public Map<String, String> handleValidationExceptions(MethodArgumentNotValidException ex) {

    Map<String, String> errors = new HashMap<>();

    ex.getBindingResult().getAllErrors().forEach((error) -> {
        String fieldName = ((FieldError) error).getField();
        String errorMessage = error.getDefaultMessage();
        errors.put(fieldName, errorMessage);
    });

    return errors;
}
```

