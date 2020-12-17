# Prueba de concepto GOlang - REST - TDD
Prueba de concepto TDD con lenguaje de programación Golang disponibilizando un API Rest

Nuestro proyecto
- Trabajara con modulos y makefile para correr los linters.
- GoKit

Para trabajar con Gokit

Implementamos en la carpeta infrastructure: 
- handler.go
- enpoint.go
- transport.go

En los modulos
- `handler.go` vamos a implementar nuestro `router con Mux` de esta forma crearemos los metodos `HTTP` con sus respectivas URL
- `transport.go` declaramos nuestros `handling methods` que recibiran nuestro request y enviara las respuestas.
- `endpoint.go` aca implementaremos la logica que se ejecutara una pase por  `func` decode nusetra petición.  


##Request example
- Method HTTP: POST
- ENDPOINT: http://localhost:8080/v1
- Body Request:
 `{
        "field": "value"
    } 
`
