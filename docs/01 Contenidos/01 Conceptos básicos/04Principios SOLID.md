# Principios SOLID
<div class="alert alert--success">
Los principios SOLID son una serie de premisas de diseño orientado a objetos que ayudan a crear código más mantenible y reutilizable.

Estos principios fueron definidos por Robert C. Martin (Uncle Bob) en su libro Agile Software Development, Principles, Patterns, and Practices en 2000.
</div>

Los principios SOLID son:

- S: Single Responsibility Principle (Principio de Responsabilidad Única)
- O: Open-Closed Principle (Principio de Abierto-Cerrado)
- L: Liskov Substitution Principle (Principio de Sustitución de Liskov)
- I: Interface Segregation Principle (Principio de Segregación de Interfaces)
- D: Dependency Inversion Principle (Principio de Inversión de Dependencias)

## Single Responsibility Principle (Principio de Responsabilidad Única)
Este principio dice que una clase debe tener una única responsabilidad, es decir, que debe tener una única razón para cambiar. Esto ayuda a crear clases más pequeñas y con una única responsabilidad.

## Open-Closed Principle (Principio de Abierto-Cerrado)
Este principio dice que las entidades del código (clases, módulos, funciones, etc.) deben estar abiertas a la extensión pero cerradas a la modificación.

Es decir, si se tiene una clase que implementa una funcionalidad, no se debe modificar para añadir nuevas funcionalidades, sino que se debe crear una nueva clase que herede de ella y que implemente la nueva funcionalidad.

## Liskov Substitution Principle (Principio de Sustitución de Liskov)
Este principio dice que las clases derivadas deben ser sustituibles por sus clases base.

Es decir, si se tiene una clase base que implementa una funcionalidad, las clases derivadas deben poder usar esa funcionalidad sin tener que modificar el código de la clase base.

## Interface Segregation Principle (Principio de Segregación de Interfaces)
Este principio dice que las interfaces deben ser lo más pequeñas posibles.

Es decir, si se tiene una interfaz que define una funcionalidad, no se deben añadir más funcionalidades a esa interfaz, sino que se debe crear una nueva interfaz que herede de la interfaz base y que defina la nueva funcionalidad.

## Dependency Inversion Principle (Principio de Inversión de Dependencias)
Este principio dice que las clases de alto nivel no deben depender de las clases de bajo nivel, sino que ambas deben depender de abstracciones.

Es decir, si se tiene una clase que implementa una funcionalidad, no se debe depender de la implementación de esa funcionalidad, sino que se debe depender de una interfaz que defina la funcionalidad.