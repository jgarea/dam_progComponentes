import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Ejercicio 702

Modifica el programa anterior, de tal forma que se mantenga la funcionalidad anterior y además se añadan dos métodos que tengan las siguientes funcionalidades:

* Los métodos procesarán peticiones POST por la que recibirá el ``nombre`` y el ``idioma``.
* Uno de los métodos recibirá los valores por la URL y otro por el cuerpo del mensaje:
  * El método POST que reciba los parámetros por la URL se mantendrá en la URL original ``/saludo``.
  * El método POST que reciba los parámetros por le cuerpo escuchará consultas en la URL ``/saludo/cuerpo`` para evitar conflictos.
* Si el idioma es conocido traducirá el texto ``Hola``, si el idioma no es conocido responderá informando que el idioma no está soportado.
* Añade 3 o 4 idiomas y prueba el sistema.
  
Además, se modificará el puerto en el que se esté ejecutando el sistema al puerto ``8702``.

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
import org.springframework.web.bind.annotation.*;

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

    @PostMapping
    public ResponseEntity<String> saludar(@RequestParam String nombre, @RequestParam String idioma) {

        String saludo = saludoService.saludarUsuario(nombre, idioma);
        return ResponseEntity.ok(saludo);
    }
    @PostMapping("/cuerpo")
    public ResponseEntity<String> saludar(@RequestBody Info info) {

        String saludo = saludoService.saludarUsuario(info.getNombre(), info.getIdioma());
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

    public String saludarUsuario(String nombre, String idioma) {
        switch(idioma){
            case "ESPAÑOL" -> {
                return "¡Hola, " + nombre + "!";
            }
            case "INGLES" -> {
                return "Hello, " + nombre + "!";
            }
            case "FRANCES" -> {
                return "Bonjour, " + nombre + "!";
            }
            case "ITALIANO" -> {
                return "Ciao, " + nombre + "!";
            }
            default -> {
                return "Saludo no soportado para el idioma especificado";
            }
        }
    }
}

```
</TabItem>
<TabItem value="4" label="Info.java">
```java	
package com.example1;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Info {
    private String nombre;
    private String idioma;
}
```
</TabItem>
<TabItem value="5" label="application.properties">
```properties
server.port=8702
spring.application.name=saludo
springdoc.api-docs.path=/api-saludo
```
</TabItem>
</Tabs>
</details>
