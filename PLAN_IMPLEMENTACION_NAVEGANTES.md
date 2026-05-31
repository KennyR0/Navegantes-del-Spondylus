# Plan de Implementacion - Navegantes del Spondylus

## Estado inicial

- Proyecto Godot real: `nuevo-proyecto-de-juego`.
- Motor configurado: Godot 4.6, render mobile.
- Estado original: proyecto casi vacio con `project.godot`, `icon.svg` e import del icono.
- Fuente de diseno: `GDD_Navegantes_del_Spondylus.md`.

## Objetivo MVP

Construir una version jugable de 5 a 8 minutos con inicio narrativo, preparacion en astillero, travesia por turnos con cartas, resultados por puntaje y exportabilidad posterior a HTML5/Android.

## Fases

### Fase 0 - Documento de seguimiento

- [x] Crear este archivo.
- [x] Registrar estado inicial.
- [x] Convertir el GDD en checklist implementable.
- [x] Separar MVP de pulido.

### Fase 1 - Base tecnica Godot

- [x] Ajustar nombre del proyecto.
- [x] Configurar escena principal.
- [x] Crear carpetas `scenes`, `scripts`, `data`, `ui`, `art`, `audio`.
- [x] Crear escenas base.
- [x] Crear autoloads `GameState`, `CardDatabase`, `SceneManager`.

### Fase 2 - Estado de partida y recursos

- [x] Implementar recursos iniciales.
- [x] Implementar balsa, progreso, reputacion, turno y tripulacion.
- [x] Agregar validacion para gastar recursos.
- [x] Agregar reinicio de partida.

### Fase 3 - Astillero

- [x] Implementar 3 acciones de preparacion.
- [x] Agregar mejoras de balsa.
- [x] Agregar comercio del puerto.
- [x] Agregar contratacion de tripulacion.
- [x] Habilitar zarpe.

### Fase 4 - Sistema de cartas y turnos

- [x] Implementar mazo de 40 cartas.
- [x] Robar 3 cartas por turno.
- [x] Consumir suministros automaticamente.
- [x] Resolver una carta obligatoria por turno.
- [x] Avanzar progreso al final del turno.

### Fase 5 - Travesia completa

- [x] Derrota por balsa en 0.
- [x] Penalizacion por hambre.
- [x] Victoria por progreso 10 o supervivencia al turno 10.
- [x] Habilidades de tripulacion y mejoras permanentes en efectos principales.
- [x] Log narrativo por turno.

### Fase 6 - Resultados y puntuacion

- [x] Formula de puntuacion final.
- [x] Rangos de resultado.
- [x] Resumen de recursos finales.
- [x] Boton de reintento.

### Fase 7 - UI, arte provisional y legibilidad

- [x] Paleta base aplicada en pantallas.
- [x] Cartas visuales por categoria con color.
- [x] HUD superior de travesia.
- [x] Fondos simples de astillero/oceano/resultados.
- [x] Layout corregido para landscape mobile sin posiciones absolutas.
- [ ] Arte final inspirado en sellos mantenos.
- [ ] Iconos finales tipo petroglifo.

### Fase 8 - Audio, pulido y exportacion

- [ ] Agregar musica y efectos.
- [ ] Balancear dificultad con playtests.
- [ ] Crear presets de exportacion HTML5/Android.
- [ ] Exportar build HTML5.
- [ ] Subir a itch.io.

## MVP incluido

- Inicio narrativo.
- Astillero funcional.
- Travesia jugable completa.
- 40 cartas con efectos simplificados.
- Resultados y game over.
- UI provisional responsive.

## Pendientes de pulido

- Arte final.
- Audio final.
- Animaciones de oceano, balsa y cartas.
- Decisiones avanzadas con dialogos por carta.
- Export presets y build final.

## Pruebas manuales

- [ ] Nueva partida desde inicio.
- [x] Corregir pantalla de inicio cortada por posiciones fijas.
- [ ] Descuento correcto de recursos en astillero.
- [ ] Bloqueo cuando no hay recursos suficientes.
- [ ] Zarpe despues de 0 a 3 acciones.
- [ ] Travesia hasta victoria.
- [ ] Travesia hasta game over por balsa.
- [ ] Penalizacion por hambre.
- [ ] Reintento desde resultados.
- [ ] Revision visual en 1280x720.
- [ ] Revision visual mobile.
