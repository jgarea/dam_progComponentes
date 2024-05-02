# JavaBeans
<div class="theme-doc-markdown markdown">
    
    <p>
        Es el modelo de componente utilizado por Java SE que se comenzaron a
        utilizar como componentes visuales para interfaces gráficas pero más
        adelante se centraron en componentes no visuales con otras finalidades,
        como por ejemplo, el acceso a datos.
    </p>
    <div
        class="theme-admonition theme-admonition-tip admonition_xJq3 alert alert--success"
    >
        <div class="admonitionHeading_Gvgb">
            <span class="admonitionIcon_Rf37"></span>JavaBeans
        </div>
        <div class="admonitionContent_BuS1">
            <p>
                Los <strong>JavaBeans</strong> son clases de java que cumplen
                una serie de requisitos formales. La mayoría de ellos son los
                que exigían las clase POJO de Java para poder ser clases
                persistentes, por ejemplo, con Hibernate.
            </p>
        </div>
    </div>
    <p>
        De hecho, los POJO son, en general, JavaBeans con la peculiaridad de que
        los JavaBeans pueden tener características adicionales relacionadas con
        la gestión de eventos.
    </p>
    <p>Los requisitos que tienen que cumplir los JavaBeans son:</p>
    <ol>
        <li>Disponer de un constructor sin argumentos.</li>
        <li>Implementar la interfaz <em>Serializable</em></li>
        <li>
            Disponer de las propiedades definidas como privadas y accesibles
            mediante métodos públicos <em>getters</em> y <em>setters</em>.
            <ul>
                <li>
                    El nombre de los <strong>getter</strong> deben empezar por
                    <strong>get</strong>, salvo que sean booleanos que empezarán
                    por <strong>is</strong>.
                </li>
            </ul>
        </li>
        <li>
            Las propiedades pueden ser:
            <ul>
                <li>
                    <strong>Simples</strong>: constan de un único valor, por
                    ejemplo, <em>void setX(Tipo valor)</em> o <em>getX()</em>.
                </li>
                <li>
                    <strong>Indexadas</strong>: constan de un conjunto de
                    valores, por ejemplo, <em>Tipo getX(int indice)</em> o
                    <em>void setX(int indice, Tipo valor)</em>
                </li>
                <li>
                    <strong>Compartidas</strong>: propiedades de cuyos cambio de
                    valor se notifica a otros objetos, por ejemplo, incorporarán
                    métodos tipo <em>addPropertyChangeListener</em>
                </li>
                <li>
                    <strong>Restringidas</strong>: similares a las compartidas,
                    per los objetos notificados pueden vetar el cambio de valor.
                </li>
            </ul>
        </li>
    </ol>
    <p>Para gestionar los JavaBeans se utilizan los siguientes mecanismos:</p>
    <ol>
        <li>
            <strong>Reflexión e introspección</strong>: un programa Java puede
            obtener información detallada acerca de cualquier clase, incluyendo
            sus atributos y métodos
        </li>
        <li>
            <strong>Persistencia</strong>: se puede almacenar el contenido
            actual y restaurarlo posteriormente. La propia interfaz
            <em>Serializable</em> proporciona un mecanismo básico de
            persistencia en ficheros
        </li>
        <li>
            <strong>Personalización</strong>: posibilidad de modificar la
            apariencia y la conducta durante el diseño, esto es importante sobre
            todo si son JavaBeans de componentes visuales.
        </li>
    </ol>
    <p>De esta forma:</p>
    <ul>
        <li>
            Los atributos, métodos y eventos declarados como públicos
            constituyen <strong>la interfaz</strong>.
        </li>
        <li>
            La <strong>funcionalidad</strong> viene determinada por las
            operaciones que realizan los métodos y no por su implementación
        </li>
    </ul>
    <div
        class="theme-admonition theme-admonition-warning admonition_xJq3 alert alert--warning"
    >
        <div class="admonitionHeading_Gvgb">
            <span class="admonitionIcon_Rf37"></span>Dónde usar JavaBeans
        </div>
        <div class="admonitionContent_BuS1">
            <p>
                Volviendo la vista atrás y retomando el modelo MVC (Modelo -
                Vista - Controlador), el modelo, constituido por objetos
                persistentes, en Java se implementará con JavaBeans.
            </p>
        </div>
    </div>
</div>
