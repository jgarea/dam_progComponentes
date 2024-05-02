# JSP
> **Tip:** JSP se utiliza para dar forma a la vista (en un modelo MVC) lo que en el ámbito de las aplicaciones web significa la generación dinámica de páginas HTML
Las páginas JSP generar código HTML utilizando como base Java, de forma muy similar a tecnologías como PHP y ASP.

Estas páginas tienen el aspecto de una página web, con etiquetas de HTML, pero además, pueden incluir directivas propias de JSP, fragmentos de código Java y referencias a constantes y variables.

Para realizar la inserción del código utilizan la siguiente estructura:
```
<% código de Java %>
```

EJEMPLO DE CÓDIGO JSP
A continuación, se muestra un ejemplo de código JSP el cual se almacena en ficheros con extensión .jsp

Ejemplo hello.jsp:
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Saludo JSP</title>
    </head>
    <body>
        <h1>Hola, <%= request.getParameter("nombre") %>!</h1>
    </body>
</html>
```
