# Servlets
<div class="alert alert--success">
**Tip** 

Un servlet es un proceso servidor que está todo el tiempo a la escucha de peticiones que llegan mediante el protocolo HTTP.
</div>
Los aspectos fundamentales acerca de un servlet son:

1. Programación: un servlet es un objeto de una clase que implementa la interfaz Servlet.
2. Despliegue: son desplegados en contenedores, por ejemplo, Apache Tomcat
3. Interacción:
     - reciben peticiones HTTP o HTTPS y responden en el mismo protocolo.
     - el contenedor aloja los servlets y les proporciona servicios básicos y hace de intermediario entre ellos y el cliente

Las páginas JSP de las que hablamos anteriormente se implementan mediante servlets y no son más que un mecanismo que facilitan el desarrollo de servlets.

<div class="theme-admonition theme-admonition-danger admonition_xJq3 alert alert--danger">
A continuación, se muestra un ejemplo de código de un servlet

Ejemplo HelloServlet.java

```java	
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/HelloServlet")
public class HelloServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener el parámetro "nombre" de la solicitud
        String nombre = request.getParameter("nombre");

        // Establecer el parámetro "nombre" como atributo de la solicitud
        request.setAttribute("nombre", nombre);

        // Redirigir la solicitud a la página JSP
        request.getRequestDispatcher("/hello.jsp").forward(request, response);
    }
}
```

</div>