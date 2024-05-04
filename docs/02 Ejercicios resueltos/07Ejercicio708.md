import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Ejercicio 708

En los ejercicios anteriores se ha desarrollado un método que era llamado desde la API para cargar los datos iniciales.

Realiza las modificaciones pertinentes para que, en lugar de usar un método que sea necesario llamar desde la API, se ejecute y cargue los datos antes de la ejecución del programa principal.

<details>
  <summary>Details</summary>
Para conseguir que los datos se carguen justo antes de la ejecución del programa es necesario utilizar la clase ``CommandLineRunner``. Para la utilización de esta clase, solo es necesario modificar el fichero de ejecución y eliminar el método que permita la carga de los datos a partir de la consulta.

De tal forma que el fichero de ejecución quedaría de la siguiente manera:

<Tabs>
<TabItem value="Application.java" label="Application.java">
    
```java
package com.example1;

import com.example1.entities.Libro;
import com.example1.entities.Prestamo;
import com.example1.entities.Socio;
import com.example1.service.LibroService;
import com.example1.service.PrestamoService;
import com.example1.service.SocioService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.time.LocalDate;
import java.util.ArrayList;

@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

	@Bean
	CommandLineRunner commadnLineRunner(LibroService libroService, PrestamoService prestamoService, SocioService socioService){
		return  args -> {
			ArrayList<Libro> datos = (ArrayList<Libro>) libroService.findAll();
			if (datos.size() > 0 ) {
				System.out.println("La base de datos ya estaba inicializada");
				return;
			}

			ArrayList<Libro> listaLibros = new ArrayList<>();
			ArrayList<Prestamo> listaPrestamos = new ArrayList<>();
			ArrayList<Socio> listaSocios = new ArrayList<>();

			listaLibros.add(new Libro("El Señor de los Anillos", "J.R.R. Tolkien", 1954));
			listaLibros.add(new Libro("Cien años de soledad", "Gabriel García Márquez", 1967));
			listaLibros.add(new Libro("Harry Potter y la piedra filosofal", "J.K. Rowling", 1997));
			listaLibros.add(new Libro("Libro X", "Autor X", 2002));
			listaLibros.add(new Libro("Libro Y", "Autora Y", 2007));

			for (Libro libro: listaLibros)
				libroService.guardar(libro);

			listaSocios.add(new Socio("Ana García", "Calle 321, Ciudad X", LocalDate.of(2022, 1, 1)));
			listaSocios.add(new Socio("Carlos Martínez", "Avenida 654, Ciudad Y", LocalDate.of(2022, 12, 15)));
			listaSocios.add(new Socio("Elena Pérez", "Calle 987, Ciudad Z", LocalDate.of(2022, 2, 10)));

			for (Socio socio: listaSocios)
				socioService.guardar(socio);

			listaPrestamos.add(new Prestamo(LocalDate.of(2022, 2, 1), LocalDate.of(2022, 3, 1)));
			listaPrestamos.add(new Prestamo(LocalDate.of(2022, 1, 15), LocalDate.of(2022, 2, 15)));
			listaPrestamos.add(new Prestamo(LocalDate.of(2022, 3, 10), LocalDate.of(2022, 4, 10)));
			listaPrestamos.add(new Prestamo(LocalDate.of(2022, 3, 10)));

			listaPrestamos.get(0).anhadirLibro(listaLibros.get(0));
			listaPrestamos.get(0).anhadirSocio(listaSocios.get(0));
			listaPrestamos.get(1).anhadirLibro(listaLibros.get(1));
			listaPrestamos.get(1).anhadirSocio(listaSocios.get(1));
			listaPrestamos.get(2).anhadirLibro(listaLibros.get(2));
			listaPrestamos.get(2).anhadirSocio(listaSocios.get(2));
			listaPrestamos.get(3).anhadirLibro(listaLibros.get(4));
			listaPrestamos.get(3).anhadirSocio(listaSocios.get(2));

			for (Prestamo prestamo: listaPrestamos)
				prestamoService.guardar(prestamo);

			System.out.println("Datos cargados correctamente");
		};
	}

}
```
</TabItem>
</Tabs>
</details>