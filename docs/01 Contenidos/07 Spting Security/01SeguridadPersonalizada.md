# Seguridad personalizada

La configuración por defecto de seguridad puede ser una buena idea en casos puntuales. Sin embargo, no es la opción más cómoda. Por lo tanto, a continuación, se mostrará como crear una configuración de seguridad personalizada.

Para ello tendremos que crear una nueva clase que actúe a modo de configuración, que se encargue de gestionar la seguridad y que estará anotada como ``@EnableWebSecurity``.

Esta clase tendrá dos métodos:

* ``securityFilterChain(HttpSecurity http)``: define que URLs estarán securizadas y cuales no.

* ``userDetailsService()``: almacena en memoria el usuario y la contraseña válida que se utilizará así como el rol de usuario

:::danger EJEMPLO
En este ejemplo vamos a añadir una capa extra de seguridad al ejemplo de los libros.

<details>
<summary>SecurityConfig.java</summary>

```java {24-31,38-46} showLineNumbers
package com.jose.proyecto1;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(authRquest ->
                        authRquest.
                                requestMatchers("/login")
                                .permitAll()
                                .anyRequest()
                                .authenticated())
                .formLogin(Customizer.withDefaults());

        return http.build();
    }

    @Bean
    public UserDetailsService userDetailsService(PasswordEncoder passwordEncoder) {
        UserDetails user = User.withUsername("user")
                .password(passwordEncoder.encode("password"))
                .roles("USER")
                .build();

        UserDetails admin = User.withUsername("admin")
                .password(passwordEncoder.encode("admin"))
                .roles("USER", "ADMIN")
                .build();

        return new InMemoryUserDetailsManager(user, admin);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        PasswordEncoder encoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();
        return encoder;
    }
}
```
</details>

En la línea 24, deshabilitamos la protección CSRF que habilita por defecto Spring, es una medida de seguridad que agrega a las peticiones POST una autenticación basado en un token CSRF válido.

De la línea 25 a la 31, configuramos el conjunto de rutas en las cuales queremos o no utilizar autenticación, pare ello utilizamos una landa basada en un conjunto de filtros:

1. Para toda consulta comprobamos si la ruta es ``/login``
2. Si es ``/login`` permitimos el acceso sin autenticación.
3. Para cualquier otra petición
4. Tenemos que estar autenticado.
5. Llamamos al formulario de login

De las líneas 38 a la 46, establecemos los usuarios, las contraseñas y el rol que tendrá acceso a la aplicación.
:::