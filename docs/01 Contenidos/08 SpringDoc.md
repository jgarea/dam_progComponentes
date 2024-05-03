# SpringDoc

Uno de los pasos importantes al trabajar con APIs es la creación de documentación que ofrezca una visión clara de las interfaces de las que dispone un componente o microservicio para su uso.

En este punto se va a utilizar **SpringDoc** el cual simplifica la generación y mantenimiento de la documentación de las APIs.

En primer lugar, se debe añadir la dependencia a Maven para su uso (siempre y cuando no se haya añadido en el momento de creación del proyecto).

```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.3.0</version>
</dependency>
```

Una vez añadida la dependencia y ejecutado el programa, por defecto, se mostrará la descripción de OpenAI en la ruta localhost:8080/v3/api-docs. No obstante, esta ruta puede ser personaliza modificando el fichero ``application.properties`` de la siguiente forma:

```properties
springdoc.api-docs.path=/api-docs
```

En este caso, la nueva ruta será ``localhost:8080/api-docs``

## Integración con Swagger UI
El formato mostrado hasta el momento en las URL anteriores no es el más fácil para entender por un humano, por consiguiente, sería muy útil añadir la integración con Swagger UI.

Para realizar esta integración basta con modificar el fichero ``application.properties`` de la siguiente forma:
```properties
springdoc.swagger-ui.path=/swagger-ui-custom.html
springdoc.swagger-ui.operationsSorter=method
```

De esta forma si accedemos a la siguiente ruta: ``localhost:8080/swagger-ui-custom.html`` veremos que la aplicación es más vistosa y ofrece mas funcionalidades como la posibilidad de ejecutar las consultas a la API.

## Añadiendo descripciones a la documentación
Para añadir un extra de información descriptiva de la API se pueden utilizar las anotaciones ``@Operation`` y ``@ApiResponses``. Estas anotaciones se colocan en el ``@RestController``.

:::danger EJEMPLO
```java
@RestController
@RequestMapping("/person")
@RequiredArgsConstructor
public class PersonController {

    private final PersonService personService;

    @Operation(summary = "Función de eliminación de los datos de una Persona")
    @ApiResponses(
            value = {
                    @ApiResponse(responseCode = "200", description = "Persona eliminada",
                            content = @Content)
            }
    )
    @DeleteMapping("/{id}")
    public void deletePerson(@Parameter(description = "id de la persona a eliminar") @PathVariable Integer id){
        personService.delete(id);
    }


    @Operation(summary = "Función de actualización de los datos de una Persona")
    @ApiResponses(
            value = {
                    @ApiResponse(responseCode = "200", description = "Persona encontrada y datos modificados",
                    content = {@Content(mediaType = "application/json",
                    schema = @Schema(implementation = Person.class))})
            }
    )
    @PostMapping("/update")
    public ResponseEntity<Person> updatePerson(@Valid @RequestBody Person person){
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(personService.updatePerson(person));
    }
}
```

Aquí os dejo un ejemplo del proyecto finalizado.

[Proyecto finalizado](assets\apirest_con_springDoc-197db0de262d0059da57807bf90db6e6.zip)
:::

