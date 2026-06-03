# Estado actual del videojuego

## Proyecto

**Nombre:** La Pochita Stone  
**Motor:** Godot 4.6  
**Escena principal:** `scenes/Main.tscn`  
**Script principal:** `scripts/main.gd`

El juego es un prototipo de gestión y pesca ambientado en un restaurante del puerto de Manta. El ciclo principal combina pesca al inicio del día, cocina con los ingredientes obtenidos y atención de clientes en el restaurante.

## Flujo principal

1. **Menú**
   - Permite iniciar un nuevo día.
   - Permite continuar si existe una partida guardada.

2. **Pesca**
   - El jugador renta un barco.
   - Tiene 5 lances por día.
   - Lanza la caña y espera las respiraciones del señuelo.
   - Debe presionar `¡Jalar!` cuando el señuelo se hunde.
   - Los pescados obtenidos pasan al inventario del día.

3. **Restaurante**
   - El jugador cocina recetas usando pescado normal, pescado premium y aliño temporal.
   - Hay 4 hornillas.
   - Hay 4 clientes por día.
   - Los clientes tienen paciencia limitada.
   - Entregar el plato correcto y a tiempo mejora la satisfacción.

4. **Resumen del día**
   - Muestra ventas, clientes atendidos, satisfacción y resultados de pesca.
   - Puede otorgar estrellas.
   - Permite mejorar el puesto o iniciar el siguiente día.

## Mecánica de pesca actual

La pesca está inspirada en la lógica de tensión y reacción rápida de Hades, pero adaptada al estado actual del prototipo.

### Secuencia

1. El jugador presiona `Lanzar caña`.
2. El señuelo queda flotando.
3. El señuelo hace entre 2 y 4 respiraciones falsas.
4. Durante una respiración falsa, el jugador no debe jalar.
5. Después de las respiraciones, el señuelo se hunde de verdad.
6. El botón `¡Jalar!` se activa.
7. El resultado depende del tiempo de reacción.

### Tiempos

- **Pesca perfecta:** `0.70s` o menos.
- **Pesca buena:** más de `0.70s` y hasta `1.10s`.
- **Pesca fallida:** después de `1.10s`.
- **Duración visual de cada respiración falsa:** `0.58s`.
- **Espera entre respiraciones:** entre `0.85s` y `1.45s`.
- **Primera espera tras lanzar:** entre `1.15s` y `1.85s`.

### Recompensas

- **Pesca perfecta:** agrega 1 pescado premium.
- **Pesca buena:** agrega 1 pescado normal.
- **Pesca fallida o jalada anticipada:** no agrega pescado.

### Corrección reciente

El botón `¡Jalar!` ahora ejecuta la acción al presionar, no al soltar. Esto evita que la pesca falle por reconstrucciones visuales de la UI durante la mordida.

Además, la pantalla ya no se redibuja automáticamente durante la fase real de mordida (`bite`), para que el botón no se destruya mientras el jugador intenta jalar.

## Inventario y economía

### Valores iniciales

- Monedas iniciales: `30`
- Costo de renta del barco: `10`
- Lances por día: `5`
- Aliño temporal por día: `2`

### Inventario del día

- `normal_fish`
- `premium_fish`
- `placeholder_spice`

El inventario se reinicia cada día.

## Recetas actuales

### Ceviche Manta

- Requiere: 1 pescado normal.
- Tiempo de cocción: `4.0s`.
- Precio: `18` monedas.

### Encebollado Pochita

- Requiere: 1 pescado normal y 1 aliño temporal.
- Tiempo de cocción: `5.0s`.
- Precio: `24` monedas.

### Pargo Premium

- Requiere: 1 pescado premium.
- Tiempo de cocción: `6.0s`.
- Precio: `34` monedas.

## Clientes y satisfacción

Cada día se generan 4 clientes.

La paciencia base es de `22.0s`, con un pequeño aumento progresivo por cliente.

La satisfacción depende de:

- Si el plato entregado es correcto.
- Qué tanto esperó el cliente.

Estados posibles:

- `happy`
- `neutral`
- `unhappy`

Si un cliente espera demasiado, se marca como `unhappy`.

## Guardado

El juego guarda en:

`user://la_pochita_stone_save.json`

Datos guardados:

- Monedas.
- Estrellas.
- Nivel de mejora.
- Recetas desbloqueadas.
- Mejor día.

## Assets actuales

### Craftpix

El proyecto usa assets existentes en:

`assets/craftpix/`

Se usan actualmente:

- Agua.
- Choza.
- Barco.
- Pescador.
- Elementos visuales de pesca y restaurante.

### Pixelart creado para el prototipo

Se agregaron assets nuevos en:

`assets/pixelart/`

Archivos:

- `lure_bobber.png`
- `lure_sink.png`
- `bite_splash.png`
- `fish_normal_pixel.png`
- `fish_premium_pixel.png`
- `fishing_seascape_pixel.png`

Estos assets se usan en la escena de pesca para diferenciar mejor el fondo marítimo, el señuelo, la mordida y la calidad del pescado.

## Estado visual

### Pesca

Actualmente muestra:

- Fondo pixelart de mar con cielo, horizonte, reflejos, isla y faro.
- Barco.
- Pescador original visible sobre el barco.
- Caña incluida en el frame original del pescador durante la pesca.
- Línea hacia el señuelo.
- Señuelo flotando o hundido.
- Ondas de agua.
- Splash durante la mordida.
- Pez normal o premium según estado.
- Medidor visual durante espera, respiración y mordida.

### Restaurante

Actualmente muestra:

- Fondo del puesto.
- Cartel de La Pochita Stone.
- Estado de clientes en tarjetas.
- Panel de acciones para cocinar, entregar platos y cerrar el día.

## Controles actuales

### Pesca

- `Rentar barco`: habilita la salida de pesca.
- `Lanzar caña`: inicia un lance.
- `¡Jalar!`: solo se habilita cuando el señuelo se hunde de verdad.
- `Ir al restaurante`: disponible cuando ya hubo pesca y no hay lance activo.

### Restaurante

- Botones de recetas para cocinar.
- Botones de clientes para entregar platos.
- `Cerrar día` para ir al resumen.

## Problemas corregidos recientemente

- Se agregó una mecánica de respiraciones falsas antes de la mordida real.
- Se alargaron los tiempos de pesca porque la primera versión iba demasiado rápido.
- Se hizo visible al pescador sobre el bote.
- Se volvió al pescador original de Craftpix para mantener consistencia visual con el barco.
- Se reemplazó el mar plano por un fondo pixelart marítimo.
- Se agregaron assets pixelart propios para señuelo, splash y peces.
- Se evitó que el botón `¡Jalar!` falle por reconstrucción de UI durante la mordida.
- Se corrigieron tarjetas visuales del restaurante para que usen `PanelContainer`.
- Se activó filtro `nearest` para que los sprites pixelart no se vean borrosos.

## Pendientes recomendados

- Probar el juego directamente en Godot y ajustar posiciones visuales con captura real.
- Separar el script principal en sistemas más pequeños: pesca, restaurante, guardado y UI.
- Reemplazar `placeholder_spice` por un ingrediente real del mundo del juego.
- Añadir sonido para respiración falsa, hundimiento real, pesca perfecta y pesca fallida.
- Añadir animación más clara para el momento exacto de mordida.
- Crear una pantalla de tutorial corta para enseñar que no se debe jalar durante respiraciones falsas.
- Agregar balance de dificultad por día o por nivel de mejora.
- Exportar a Web si se quiere probar por `localhost`.

## Limitación de prueba

No se pudo ejecutar Godot desde este entorno porque `godot` no está disponible en PATH. Los cambios se han verificado por revisión de archivos, pero falta una prueba jugable dentro del motor.
