import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Ejercicio 701

Crea un programa en Spring que esté formado por:

* Un controlador formado por una API Rest que recibe el nombre del usuario como parámetro y devuelve un saludo.
* Se utilizará el método GET para enviar la información con el nombre del usuario al sistema.
* El método recibirá el nombre del usuario en la variable ``nombre``.
 
Además, se deberá tener en cuenta los siguientes aspectos de configuración:

* El programa Spring deberá estar corriendo en el puerto ``8701``.
* El nombre del programa será ``saludo``.
* La URL de la documentación estará en: ``/api-saludo``.
* La API responderá a la petición en la ruta ``/saludo``
  
En cuanto a las dependencias del proyecto, solo será necesario utilizar Spring Web y Lombok.

Si se envía una petición GET a localhost:8701/saludo?nombre=Jose debería devolverse un ``¡Hola, Jose!``

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
<TabItem value="2" label="SaludoController.java">
```java
package com.example1;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/saludo")
public class SaludoController {

    private final SaludoService saludoService;

    @Autowired
    public SaludoController(SaludoService saludoService) {
        this.saludoService = saludoService;
    }

    @GetMapping
    public ResponseEntity<String> saludar(@RequestParam String nombre) {
        String saludo = saludoService.saludarUsuario(nombre);
        return ResponseEntity.ok(saludo);
    }
}
```
</TabItem>
<TabItem value="3" label="SaludoService.java">
```java
package com.example1;

import org.springframework.stereotype.Service;

@Service
public class SaludoService {
    public String saludarUsuario(String nombre) {
        return "¡Hola, " + nombre + "!";
    }
}
```
</TabItem>
<TabItem value="4" label="application.properties">
```properties
server.port=8701
spring.application.name=saludo
springdoc.api-docs.path=/api-saludo
```
</TabItem>
</Tabs>
</details>