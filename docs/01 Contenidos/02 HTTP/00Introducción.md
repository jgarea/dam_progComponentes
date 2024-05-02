# Introduccion

<div class="alert alert--success">
**HTTP** es el protocolo de comunicación de la Web.

Es un protocolo de capa de aplicación, es decir, se encarga de la comunicación entre dos aplicaciones.
</div>

Las principales características de este protocolo son:

- Es un protocolo orientado a la transferencia de información, es decir, que no mantiene una conexión estable entre el cliente y el servidor, sino que cada petición se realiza de forma independiente.
  
- Es un protocolo de texto plano, es decir, que los mensajes que se intercambian entre cliente y servidor son cadenas de texto.
  
    - Cada cadena de texto se componen de una serie de líneas.
    - Cada línea contiene un campo y un valor separados por dos puntos (:).
        - El primer campo es el método, que indica la acción que se va a realizar sobre el recurso.
        - El segundo campo es la URL del recurso, que indica el recurso sobre el que se va a realizar la acción.
        - El tercer campo es la versión del protocolo HTTP que se está utilizando.
        - El resto de campos son cabeceras adicionales.