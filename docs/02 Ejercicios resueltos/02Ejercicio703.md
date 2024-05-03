import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Ejercicio 703

Crea un proyecto en Spring que permita manejar una lista de objetos. Para ello se pide:

* crear una entidad llamada ``Producto`` con atributos como ``id``, ``nombre``, y ``precio``.
* implementar un servicio y un controlador que permitan:
    * Agregar productos a una lista,
    * Recuperar todos los productos,
    * Obtener detalles de un producto específico por su ID.
    * Eliminar producto de la lidata
  
Además, se deberá tener en cuenta los siguientes aspectos de configuración:

* El programa Spring deberá estar corriendo en el puerto ``8703``.
* El nombre del programa será ``productos``.
* La URL de la documentación estará en: ``/api-productos``.
* La API responderá a la petición en la ruta ``/productos``
  
En cuanto a las dependencias del proyecto, solo será necesario utilizar Spring Web y Lombok.

<details>
  <summary>Resultado</summary>
  
<Tabs>
<TabItem value="1" label="Application.java" default>
```java
package com.example1;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

}
```
</TabItem>
<TabItem value="2" label="Producto.java">
```java
package com.example1;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Producto {
    private Long id;
    private String nombre;
    private double precio;

}
```
</TabItem>
<TabItem value="3" label="ProductoController.java">
```java
package com.example1;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/productos")
public class ProductoController {

    private final ProductoService productoService;

    @Autowired
    public ProductoController(ProductoService productoService) {
        this.productoService = productoService;
    }

    @GetMapping
    public ResponseEntity<List<Producto>> obtenerTodosLosProductos() {
        List<Producto> productos = productoService.obtenerTodosLosProductos();
        return ResponseEntity.ok(productos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Producto> obtenerProductoPorId(@PathVariable Long id) {
        Producto producto = productoService.obtenerProductoPorId(id);
        if (producto != null) {
            return ResponseEntity.ok(producto);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping
    public ResponseEntity<String> agregarProducto(@RequestBody Producto producto) {
        productoService.agregarProducto(producto);
        return ResponseEntity.ok().body("Producto añadido");
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarProducto(@PathVariable Long id) {
        Producto producto = productoService.obtenerProductoPorId(id);
        if (producto != null) {
            productoService.eliminarProducto(id);
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
```
</TabItem>
<TabItem value="4" label="ProductoService.java">
```java
package com.example1;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Service
public class ProductoService {
    private final List<Producto> productos = new ArrayList<>();
    private Long idCounter = 1L;

    public List<Producto> obtenerTodosLosProductos() {
        return productos;
    }

    public Producto obtenerProductoPorId(Long id) {
        return productos.stream()
                .filter(producto -> producto.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    public void agregarProducto(Producto producto) {
        producto.setId(idCounter++);
        productos.add(producto);
    }

    public void eliminarProducto(Long id) {
        Iterator<Producto> iterator = productos.iterator();
        while (iterator.hasNext()) {
            Producto producto = iterator.next();
            if (producto.getId().equals(id)) {
                iterator.remove();
                break;
            }
        }
    }
}

```
</TabItem>
<TabItem value="5" label="application.properties">
```properties
server.port=8703
spring.application.name=productos
springdoc.api-docs.path=/api-productos
```
</TabItem>
</Tabs>
</details>

