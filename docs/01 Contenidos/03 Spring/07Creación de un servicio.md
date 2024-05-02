# Creación de un servicio
Otra de las partes importantes de un microservicio es el **Servicio**. Un servicio se encarga de conectar varios respositorios y agrupar la lógica del sistema y su funcionalidad.

Para la creación de un servicio se necesitará:
* Definir una clase en Java
* Utilizar la anotación ``@Service``
* Establecer la variable de conexión con los distintos repositorios.
* Definir los métodos que permitan recibir la información del controlador, procesarla, hacer las peticiones correspondientes a los repositorio y devolver la solución al controlador.

:::danger CONTINUACIÓN EJEMPLO


Continuando con nuestro ejemplo de ``books`` se muestra un ejemplo de posible servicio.

```java
package com.example.books;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReadingListService {

	@Autowired
	private ReadingListRepository readingListRepository;

	public List<Book> findByReader(String reader) {
		return readingListRepository.findByReader(reader);
	}

	public void save(Book book) {
		readingListRepository.save(book);
	}
}

```
:::

:::warning POSIBLE OMISIÓN



No es recomendable la omisión de los servicios ya que permiten establecer una correcta organización de la información y de la estructura de los microservicios. Sin embargo, en ejemplos muy sencillos estos podrían ser omitidos conectando directamente el Controlador y el Repositorio. Como podría ser el ejemplo anterior.

:::
