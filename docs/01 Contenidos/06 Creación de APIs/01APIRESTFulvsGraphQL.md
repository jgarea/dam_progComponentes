# API RESTFul vs GraphQL
## Diferencias y similitudes

|	|REST	|GraphQL|
|---|---|---|
|¿Qué es?|Conjunto de reglas que define el intercambio de datos estructurados entre cliente y servidor.	|Lenguaje de consulta, un estilo de arquitectura y un conjunto de herramientas para crear y manipular las API.|
|Más adecuada para lo siguiente:	|Cuando el origen de datos es simple y los recursos están bien definidos.	|Cuando el orígenes de los datos es grande, complejo e interrelacionado.|
|Acceso a los datos|	Dispone de varios puntos de conexión en forma de URL para definir los recursos.	|Dispone de un único punto de conexión de URL.|
|Datos devueltos|	En una estructura fija definida por el servidor.|	En una estructura flexible definida por el cliente.|
|Cómo se estructuran y definen los datos|	Datos de tipado débil. El cliente debe decidir cómo interpretar los datos devueltos.|	Datos de tipado fuerte. El cliente recibe los datos en formatos predeterminados y mutuamente comprendidos.|
|Comprobación de errores|	El cliente debe comprobar si los datos devueltos son válidos.|	Las solicitudes no válidas son rechazadas por la estructura del esquema generando un mensaje de error.|

## Limitaciones de REST que supera GraphQL
Los desarrolladores descubrieron que las **arquitecturas** de API existentes, como REST, eran demasiado **largas** y **estructuradas** para producir fuentes de noticias de manera eficiente.

A continuación, analizamos algunos de los desafíos a los que se enfrentaron.

**Intercambio de datos de estructura fija**
La API de REST requiere que las **solicitudes sigan una estructura fija para recibir un recurso**. Esta estructura es **fácil de usar**, pero **no** siempre es el **medio más eficiente** para intercambiar exactamente los datos necesarios.

**Exceso e insuficiencia de datos**
Las API de REST siempre **devuelven un conjunto de datos completo**, independientemente de si necesita todos los datos o no.

Además, si se quiere obtener dos datos independientes, por ejemplo, un teléfono móvil y la última compra será necesario realizar varias peticiones. Una para obtener los datos personales donde está el teléfono móvil y otra para obtener el historial de compras.

Es aquí, donde GraphQL surge como una solución basada en consultas, donde estas consultas Las consultas pueden devolver los datos exactos en un solo intercambio de solicitudes y respuestas de API.

## Cuando usar API RESTFul o GraphQL
Se puede usar las API de GraphQL y de REST de forma intercambiable. Sin embargo, hay algunos casos de uso en los que una u otra es más adecuada.
* Es probable que **GraphQL sea una mejor opción si** tiene estas consideraciones:
    * Se tiene un ancho de banda limitado y se desea minimizar la cantidad de solicitudes y respuestas.
    * Se tienen varios orígenes de datos y se desea combinarlos en un punto de conexión.
    * Las solicitudes de los clientes varían significativamente y espera respuestas muy diferentes.
* Es probable que **REST sea una mejor opción si** tiene estas consideraciones:
    * Se tienen aplicaciones más pequeñas con datos menos complejos.
    * Se tienen datos y operaciones que todos los clientes utilizan de manera similar.
    * No se tienen requisitos para realizar consultas de datos complejas.

:::info MÁS INFORMACIÓN
Si se quiere conocer más información sobre la diferencia de estas dos tecnologías puedes consultar este [enlace](https://aws.amazon.com/es/compare/the-difference-between-graphql-and-rest/)
:::
