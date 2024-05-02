# Main y ejecución
Una vez se haya generado el proyecto y se haya descomprimido, el archivo de ejecución que debemos utilizar es el que viene en la ruta ``src/main/java/paquete/`` donde, si se ha seguido los pasos anteriores paquete tendrá la forma com.nombre. Dentro de esa ruta nos interesa el fichero que finaliza con Application.java ya que este será nuestro fichero "main".

La estructura de este fichero será similar a la siguiente:

```java

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

}

```

Dentro de este fichero lo más importante es la anotación ``@SpringBootApplication`` ya que es la que le indica a Spring cual es el código que arranca la ejecución de la aplicación.

Esta simple anotación se utiliza para habilitar tres funciones:
* ``@EnableAutoConfiguration``: habilita el mecanismo de configuración automática de Spring.
* ``@ComponentScan``: habilita el escaneo de ``@Component`` en el paquete en el que está situada la aplicación.
* ``@Configuration``: permite registrar Beans adicionales en el contexto o importar clases de configuración adicionales.

De tal forma que la anotación ``@SpringBootApplication`` es equivalente a utilizar ``@Configuration``, ``@EnableAutoConfiguration`` y ``@ComponentScan`` con sus atributos predeterminados.

## Ejecución de código previo a la ejecución de la aplicación
Spring define dos interfaces que permiten ejecutar cierto bloque de código antes de la propia ejecución del programa.

Esto es realmente realmente útil para:

- Realizar tareas de inicialización
- Realizar tareas de configuración
- Realizar tareas de carga de datos en una base de datos
- Realizar tareas de comprobación o validación.
  
Estas interfaces son ``CommandLineRunner`` y ``ApplicationRunner`` ambas disponen de un único método que se debe implementar.

### CommandLineRunner
Para la creación de un ``CommandLineRunner`` simplemente es necesario crear una clase que implemente es interfaz y sobreescribir el método ``run()``
```java
@Component
@Order(2)
public class CommandLineAppStartupRunner implements CommandLineRunner {
    private static final Logger logger = LoggerFactory.getLogger(CommandLineAppStartupRunner.class);

    @Override
    public void run(String...args) throws Exception {
        String strArgs = Arrays.stream(args).collect(Collectors.joining("|"));
        logger.info("Inicio del CommandLineRunner con los siguientes argumentos: " + strArgs);
    }
}
```

### ApplicationRunner
Para la creación de un ``ApplicationRunner`` simplemente es necesario crear una clase que implemente es interfaz y sobreescribir el método ``run()``
```java
@Component
@Order(1)
public class AppStartupRunner implements ApplicationRunner {
    private static final Logger logger = LoggerFactory.getLogger(AppStartupRunner.class);

    @Override
    public void run(ApplicationArguments args) throws Exception {
        logger.info("Aplicación iniciada con los siguientes valores de los argumentos: " + args.getOptionValues());
    }
}
```

ApplicationRunner envuelve los argumentos sin procesar de la aplicación y expone la interfaz ApplicationArguments la cual tienen métodos interesantes como:

* ``getOptionNames()``: devuelve el nombre de los parámetros
* ``getOptionValues()``: devuelve el valor de los parámetros
* ``getSourceArgs()``: devuelve el origen de los argumentos

:::warning Ordenacion

En el caso de disponer de varios elementos CommandLineRunner o ApplicationRunner podemos establecer un orden de ejecución entre ellos utilizando la anotación ``@Order(posición)`` donde posición es un entero que indica en qué posición se ejecutarán

Para los ejemplos anteriores, primero se ejecutará ``AppStartupRunner`` y después ``CommandLineAppStartupRunner``
:::