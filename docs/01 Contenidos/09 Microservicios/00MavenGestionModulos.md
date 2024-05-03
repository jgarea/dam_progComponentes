# Maven - Gestión de módulos

En este tema vamos a trabajar con varios microservicios o componentes donde cada uno de ellos corresponde a un proyecto independiente. Los IDEs por regla general suelen poner pegas cuando disponemos de varios proyectos donde cada uno de ellos dispone de su propio Maven.

Para evitar tener que abrir una ventana nueva del IDE por cada proyecto Maven permite la opción de crear módulos de tal forma que cada proyecto constituye un módulo dentro de un proyecto.

Por ejemplo, dado un directorio denominado ``proyectos`` que contiene tres carpetas correspondientes a tres proyectos Maven: ``modulo1``, ``modulo2`` y ``modulos3`` para poder gestionarlos desde una única instancia del IDE lo que habrá que hacer será:

1. Abrir la carpeta ``proyectos``.
2. Crear un fichero ``pom.xml``, a la altura de los tres módulos, con la siguiente estructura:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.example</groupId>      <!-- Nombre del paquete-->
	<artifactId>proyectos</artifactId><!-- Nombre del proyecto-->
	<version>0.0.1-SNAPSHOT</version>
	<packaging>pom</packaging>          <!-- Empaquetamiento-->
	<description>Descripción</description>
	<modules> <!-- Nombre de los módulos-->
		<module>modulo1</module>
		<module>modulo2</module>
        <module>modulo3</module>
	</modules>
	<properties> <!-- Propiedades del proyecto-->
		<java.version>17</java.version>
		<spring-cloud.version>2023.0.0</spring-cloud.version>
		<maven.compiler.source>17</maven.compiler.source>
		<maven.compiler.target>17</maven.compiler.target>
	</properties>
</project>

```

Donde:

* ``groupId``: permite identificar un proyecto del resto
* ``artifactID``: nombre del jar que se crea cuando se exporta. Por regla general, sería el nombre de la carpeta donde está, en este caso ``proyectos``
* ``packaging``: permite definir el tipo de empaquetamiento que se va a realizar. En este caso, como se está generando una agregación de proyectos maven sería ``pom``.
* ``Modules``: permite definir los módulos que forman parte del mismo proyecto
  * ``Module``: define cada uno de los módulos que forman parte del mismo proyecto. Corresponde con el nombre de cada proyecto: ``modulo1``, ``modulo2`` y ``modulo3``.
* ``Properties``: define las propiedades conjuntas del proyecto. A su vez cada módulo podría tener sus propias propiedades aunque no es lo recomendado.
  * ``java.version``: indicamos la versión de Java con la que se trabajará
  * ``maven.compiler.source`` y ``target``: define la versión de compilación origen y destino que usará maven para generar los ficheros de Java.

De esta forma se podrá disponer de una única instancia del IDE con la que trabajar en uno o varios microservicios de forma cómoda.