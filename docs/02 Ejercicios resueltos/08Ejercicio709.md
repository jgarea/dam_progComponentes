import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Ejercicio 709

Se pide desarrollar una aplicación utilizando Spring que permite gestionar una base de datos MongoDB denominada ``estudiantes709``. Esta base de datos estará formada por dos colecciones:

* ``Estudiantes``: la cual tendrá la siguiente estructura:
```json
{
  "_id": ObjectId("5f5b4e3806b9a556b943121a"),
  "nombre": "Juan Perez",
  "edad": 20,
  "email": "juan@example.com",
  "cursos": [
    ObjectId("5f5b4e3806b9a556b943121b"),
    ObjectId("5f5b4e3806b9a556b943121c")
  ],
  "notas": {
    "5f5b4e3806b9a556b943121b": 90,  // Puntuación en el curso 1
    "5f5b4e3806b9a556b943121c": 85   // Puntuación en el curso 2
  },
  "direccion": {
    "ciudad": "Ciudad de México",
    "calle": "Avenida Principal",
    "codigo_postal": "12345"
  }
}
```

* Cursos: la cual tendrá la siguiente estructura:
```json
{
  "_id": ObjectId("5f5b4e3806b9a556b943121b"),
  "titulo": "Introducción a la Programación",
  "profesor": "Ana Rodriguez",
  "estudiantes": [
    {
      "idEstudiante": ObjectId("5f5b4e3806b9a556b943121a"),
      "nota": 90
    },
    {
      "studentId": ObjectId("5f5b4e3806b9a556b943121d"),
      "nota": 88
    }
  ],
  "horario": {
    "dia": "Lunes",
    "hora": "10:00 AM - 12:00 PM"
  }
}
```

Además, se deberá tener en cuenta los siguientes aspectos de configuración:

* El programa Spring deberá estar corriendo en el puerto ``8709``.
* La base de datos utilizada se llamará ``estudiantes709``
* El nombre del programa será ``estudiantesMongoDB``.
* La URL de la documentación estará en: ``/api-estudiantes709``.
* La API responderá a la petición en la ruta ``/estudiantes709``
  
En cuanto a las dependencias del proyecto, será necesario utilizar:

* Spring Web
* Lombok
* Spring Data MongoDB.

En cuanto a las tareas a realizar, el programa deber ser capaz de:

* Crear, modificar y eliminar un Estudiante y un Curso.
* Matricular un Estudiante en un Curso.
* Asignar una calificación a un Estudiante en un Curso.

<details>
<summary>Solución</summary>
<Tabs>
<TabItem value="DTO">
<Tabs>
 <TabItem value="CursoDTO">
 ```java
 package com.example.MongoDB.DTO;

import com.example.MongoDB.Modelos.Horario;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;


@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class CursoDTO {
    private String titulo;
    private String profesor;
    private String dia;
    private String hora;
}

 ```
 </TabItem>
 <TabItem value="CursoIDDTO">
 ```java
 package com.example.MongoDB.DTO;

import com.example.MongoDB.Modelos.Horario;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;


@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class CursoIDDTO extends CursoDTO{
    private String id;
}

 ```
 </TabItem>
 <TabItem value="EstudianteCursoDTO">
 ```java
 package com.example.MongoDB.DTO;

import lombok.*;
import lombok.experimental.SuperBuilder;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class EstudianteCursoDTO {
    private String idEstudiante;
    private String idCurso;
}

 ```
 </TabItem>
 <TabItem value="EstudianteCursoNotaDTO">
 ```java
 package com.example.MongoDB.DTO;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class EstudianteCursoNotaDTO extends EstudianteCursoDTO{
    private int nota;
}

 ```
 </TabItem>
 <TabItem value="EstudianteDTO">
 ```java
 package com.example.MongoDB.DTO;

import lombok.*;
import lombok.experimental.SuperBuilder;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class EstudianteDTO {
    private String nombre;
    private int edad;
    private String email;
    private String ciudad;
    private String calle;
    private String codigoPostal;
}

 ```
 </TabItem>
 <TabItem value="EstudianteIDDTO">
 ```java
 package com.example.MongoDB.DTO;

import lombok.*;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
public class EstudianteIDDTO extends EstudianteDTO{
    private String id;
}

 ```
 </TabItem>
</Tabs>
</TabItem>
<TabItem value="Entidades">
<Tabs>
 <TabItem value="Curso">
 ```java
 package com.example.MongoDB.Modelos;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Document(collection = "curso")
public class Curso {
    @Id
    private String id;
    private String titulo;
    private String profesor;
    private List<Notas> estudiantes = new ArrayList<>();
    private Horario horario;
}
 ```
 </TabItem>
 <TabItem value="Direccion">
 ```java
 package com.example.MongoDB.Modelos;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Direccion {
    private String ciudad;
    private String calle;
    private String codigo_postal;
}
 ```
 </TabItem>
 <TabItem value="Estudiante">
 ```java
 package com.example.MongoDB.Modelos;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Document(collection = "estudiante")
public class Estudiante {
    @Id
    private String id;
    private String nombre;
    private int edad;
    private String email;

    private List<String> cursos = new ArrayList<>();
    private Map<String, Integer> notas = new HashMap<>();
    private Direccion direccion;
}
 ```
 </TabItem>
 <TabItem value="Horario">
 ```java
 package com.example.MongoDB.Modelos;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Horario {
    private String dia;
    private String hora;
}
 ```
 </TabItem>
 <TabItem value="Notas">
 ```java
 package com.example.MongoDB.Modelos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notas {
    private String idEstudiante;
    private int nota;
}
 ```
 </TabItem>
 
</Tabs>
 
</TabItem>
<TabItem value="Repositorios">
<Tabs>
 <TabItem value="CursoRepositorio">
 ```java
 package com.example.MongoDB.Repositorio;

import com.example.MongoDB.Modelos.Curso;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface CursoRepositorio extends MongoRepository<Curso, String> {
}

 ```
 </TabItem>
 <TabItem value="EstudianteRepositorio">
 ```java
 package com.example.MongoDB.Repositorio;

import com.example.MongoDB.Modelos.Estudiante;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface EstudianteRepositorio extends MongoRepository<Estudiante, String> {
}

 ```
 </TabItem>
</Tabs>
</TabItem>
<TabItem value="Servicios">
 <Tabs>
  <TabItem value="CursoService">
  ```java
  package com.example.MongoDB.Service;

import com.example.MongoDB.DTO.CursoDTO;
import com.example.MongoDB.DTO.CursoIDDTO;
import com.example.MongoDB.Modelos.Curso;
import com.example.MongoDB.Modelos.Horario;
import com.example.MongoDB.Repositorio.CursoRespositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CursoService {

    @Autowired
    private CursoRespositorio cursoRespositorio;

    public void guardar(CursoDTO cursoDTO) {
        Horario horario = Horario.builder()
                .dia(cursoDTO.getDia())
                .hora(cursoDTO.getHora())
                .build();
        Curso curso = Curso.builder()
                .titulo(cursoDTO.getTitulo())
                .profesor(cursoDTO.getProfesor())
                .horario(horario).build();
        cursoRespositorio.save(curso);
    }

    public void actualizar(CursoIDDTO cursoIDDTO) {
        Horario horario = Horario.builder()
                .dia(cursoIDDTO.getDia())
                .hora(cursoIDDTO.getHora())
                .build();
        Curso curso = Curso.builder()
                .id(cursoIDDTO.getId())
                .titulo(cursoIDDTO.getTitulo())
                .profesor(cursoIDDTO.getProfesor())
                .horario(horario).build();
        cursoRespositorio.save(curso);
    }

    public void deleteById(String id) {
        cursoRespositorio.deleteById(id);
    }

    public Curso findById(String idCurso) {
        return cursoRespositorio.findById(idCurso).orElse(null);
    }

    public void guardar(Curso curso) {
        cursoRespositorio.save(curso);
    }
}

  ```
  </TabItem>
  <TabItem value="EstudianteService">
  ```java
  package com.example.MongoDB.Service;

import com.example.MongoDB.DTO.EstudianteDTO;
import com.example.MongoDB.DTO.EstudianteIDDTO;
import com.example.MongoDB.Modelos.Direccion;
import com.example.MongoDB.Modelos.Estudiante;
import com.example.MongoDB.Repositorio.EstudianteRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EstudianteService {

    @Autowired
    EstudianteRepositorio estudianteRepositorio;

    public void guardar(EstudianteDTO estudianteDTO) {
        Direccion direccion = Direccion.builder().calle(estudianteDTO.getCalle())
                .ciudad(estudianteDTO.getCiudad())
                .codigo_postal(estudianteDTO.getCodigoPostal())
                .build();
        Estudiante estudiante = Estudiante.builder()
                .nombre(estudianteDTO.getNombre())
                .edad(estudianteDTO.getEdad())
                .email(estudianteDTO.getEmail())
                .direccion(direccion)
                .build();
        estudianteRepositorio.save(estudiante);
    }

    public void guardar(Estudiante estudiante) {
        estudianteRepositorio.save(estudiante);
    }

    public void actualizar(EstudianteIDDTO estudianteIDDTO) {
        Direccion direccion = Direccion.builder().calle(estudianteIDDTO.getCalle())
                .ciudad(estudianteIDDTO.getCiudad())
                .codigo_postal(estudianteIDDTO.getCodigoPostal())
                .build();
        Estudiante estudiante = Estudiante.builder()
                .id(estudianteIDDTO.getId())
                .nombre(estudianteIDDTO.getNombre())
                .edad(estudianteIDDTO.getEdad())
                .email(estudianteIDDTO.getEmail())
                .direccion(direccion)
                .build();
        estudianteRepositorio.save(estudiante);
    }

    public void deleteById(String id) {
        estudianteRepositorio.deleteById(id);
    }

    public Estudiante findById(String idEstudiante) {
        return estudianteRepositorio.findById(idEstudiante).orElse(null);
    }
}

  ```
  </TabItem>
 </Tabs>
</TabItem>
<TabItem value="Controlador">
```java
package com.example.MongoDB.Controller;

import com.example.MongoDB.DTO.*;
import com.example.MongoDB.Modelos.Curso;
import com.example.MongoDB.Modelos.Estudiante;
import com.example.MongoDB.Modelos.Notas;
import com.example.MongoDB.Service.CursoService;
import com.example.MongoDB.Service.EstudianteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/estudiantes709")
public class Controlador {

    @Autowired
    private CursoService cursoService;
    @Autowired
    private EstudianteService estudianteService;

    @PostMapping("/estudiante")
    public ResponseEntity<String> anhadirEstudiante(@RequestBody EstudianteDTO estudianteDTO){
        estudianteService.guardar(estudianteDTO);
        return ResponseEntity.ok("Estudiante añadido con éxito");
    }

    @PatchMapping("/estudiante")
    public ResponseEntity<String> modificarEstudiante(@RequestBody EstudianteIDDTO estudianteIDDTO){
        estudianteService.actualizar(estudianteIDDTO);
        return ResponseEntity.ok("Estudiante modificado con éxito");
    }

    @DeleteMapping("/estudiante/{id}")
    public ResponseEntity<String> eliminarEstudiante(@PathVariable String id){
        estudianteService.deleteById(id);
        return ResponseEntity.ok("Estudiante eliminado con éxito");
    }

    @PostMapping("/curso")
    public ResponseEntity<String> anhadirCurso(@RequestBody CursoDTO cursoDTO){
        cursoService.guardar(cursoDTO);
        return ResponseEntity.ok("Curso añadido con éxito");
    }

    @PatchMapping("/curso")
    public ResponseEntity<String> modificarCurso(@RequestBody CursoIDDTO cursoIDDTO){
        cursoService.actualizar(cursoIDDTO);
        return ResponseEntity.ok("Curso modificado con éxito");
    }

    @DeleteMapping("/curso/{id}")
    public ResponseEntity<String> eliminarCurso(@PathVariable String id){
        cursoService.deleteById(id);
        return ResponseEntity.ok("Curso eliminado con éxito");
    }

    @PostMapping("/asignar")
    public ResponseEntity<String> asignarEstudianteCurso(@RequestBody EstudianteCursoDTO estudianteCursoDTO){
        try {
            Estudiante estudiante = estudianteService.findById(estudianteCursoDTO.getIdEstudiante());
            Curso curso = cursoService.findById(estudianteCursoDTO.getIdCurso());

            // Verificar si el estudiante ya está asignado al curso
            if (curso.getEstudiantes().stream().anyMatch(e -> e.getIdEstudiante().equals(estudiante.getId()))) {
                return new ResponseEntity<>("El estudiante ya está asignado al curso.", HttpStatus.BAD_REQUEST);
            }

            // Asignar el estudiante al curso

            curso.getEstudiantes().add(new Notas(estudiante.getId(), 0));  // La nota inicial puede ser 0
            // Actualizar el curso en la base de datos
            cursoService.guardar(curso);
            estudiante.getCursos().add(curso.getId());
            estudiante.getNotas().put(curso.getId(), 0);
            estudianteService.guardar(estudiante);

            return new ResponseEntity<>("Estudiante asignado al curso correctamente.", HttpStatus.OK);

        } catch (Exception e) {
            System.out.println(e.getStackTrace());
            return new ResponseEntity<>("Error interno del servidor", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/calificar")
    public ResponseEntity<String> asignarCalificacionEstudianteCurso(@RequestBody EstudianteCursoNotaDTO estudianteCursoNotaDTO){
        try {
            Estudiante estudiante = estudianteService.findById(estudianteCursoNotaDTO.getIdEstudiante());
            Curso curso = cursoService.findById(estudianteCursoNotaDTO.getIdCurso());

            // Verificar si el estudiante está asignado al curso
            Notas notas = curso.getEstudiantes().stream()
                    .filter(e -> e.getIdEstudiante().equals(estudiante.getId()))
                    .findFirst()
                    .orElse(null);

            if (notas == null) {
                return new ResponseEntity<>("El estudiante no está asignado al curso.", HttpStatus.BAD_REQUEST);
            }

            // Asignar una calificación (aquí se asigna una calificación aleatoria entre 0 y 100)
            notas.setNota(estudianteCursoNotaDTO.getNota());

            // Actualizar el curso en la base de datos
            cursoService.guardar(curso);
            estudiante.getNotas().put(curso.getId(), estudianteCursoNotaDTO.getNota());
            estudianteService.guardar(estudiante);
            return new ResponseEntity<>("Calificación asignada correctamente.", HttpStatus.OK);

        } catch (Exception e) {
            return new ResponseEntity<>("Error interno del servidor", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}

```
</TabItem>
<TabItem value="Ficheros generales">
<Tabs>
 <TabItem value="Application.java">
 ```java
 package com.example.MongoDB;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MongoDbApplication {

	public static void main(String[] args) {
		SpringApplication.run(MongoDbApplication.class, args);
	}

}
 ```
 </TabItem>
 <TabItem value="application.properties">
 ```properties
 spring.data.mongodb.uri=mongodb://localhost:27017/estudiantes709
spring.data.mongodb.host=localhost
spring.data.mongodb.port=27017
server.port=8709
spring.application.name=estudiantes709
springdoc.api-docs.path=/api-estudiantes709
 ```
 </TabItem>
</Tabs>
</TabItem>
</Tabs>

</details>