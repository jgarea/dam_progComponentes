# Creación de Entidades
Cuando escribimos código para consultar datos de una base de datos, la clase donde terminan nuestros datos es comúnmente llamada **entidad**.

Este concepto se convirtió en un estándar cuando se lanzó JPA.

:::tip ENTIDAD
**Entidad**

Literalmente, cada clase involucrada con el almacenamiento y recuperación de datos se denomina **entidad** y se identificará a través de JPA usando la anotación ``@Entity``.
:::

Pero el concepto de entidades no se limita a JPA. Clases utilizadas para transportar datos dentro y fuera de MongoDB, aunque no requieren tal anotación, también pueden considerarse entidades.

:::warning USO DEL INGLÉS
**USO DEL INGLÉS**

Para la creación de proyectos de Spring es recomendable el uso del inglés a la hora de definir métodos y clases ya que este hace ciertas comprobaciones y asociaciones con funciones inglesas para facilitar la implementación.
:::


:::danger CONTINUACIÓN EJEMPLO

Volviendo a nuestro ejemplo, en este caso, nuestra Entidad será ``Book`` la cual tendrá la siguiente estructura:

```java title="Book.java"
package com.jose.proyecto1;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String reader;
    private String isbn;
    private String title;
    private String author;
    private String description;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getReader() {
        return reader;
    }

    public void setReader(String reader) {
        this.reader = reader;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}

```

Como se puede observar la estructura es muy similar a la ya utilizada en Hibernate para la creación de entidades donde la anotación ``@Entity`` permite describir una entidad JPA.

Por otro lado, también es recomendable marcar el identificador con la anotación ``@Id`` y establecer la estrategia de generación con ``@GeneratedValue``.
:::