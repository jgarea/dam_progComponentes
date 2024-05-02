# Manejo de excepciones y errores
Desde la versión 5 de Spring, se pueden gestionar los errores utilizando ``ResponseStatusException``. De esta forma, se puede lanzar una excepción y Spring se encarga de convertirla en un error HTTP en base al contenido que se le indica, dando la respuesta adecuada.

```java
public class RaquetaValidator {

    public void validate(Raqueta raqueta) {
        // las distintas condiciones
        if (raqueta.getMarca() == null || raqueta.getMarca().isEmpty()) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "La marca no puede estar vacía");
        }
        if (raqueta.getModelo() == null || raqueta.getModelo().isEmpty()) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "El modelo no puede estar vacío");
        }
        if (raqueta.getPrecio() == null || raqueta.getPrecio() < 0) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "El precio no puede ser negativo");
        }
    }

}
```

```java
 @Override
public Raqueta findById(Long id) {
    log.info("findById");
    return raquetasRepository.findById(id).orElseThrow(
            () -> new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "No se ha encontrado la raqueta con id: " + id)
    );
}
```

Para mostrar los errores de forma correcta debemos añadir en nuestro fichero de propiedades la siguiente configuración:

```properties
#Para que muestre el mensaje de error de excepciones

server.error.include-message=always
```