# Estado actual del videojuego

## Actualización: cocina y protagonista

Se integraron los assets entregados por el usuario en `assets/protagonist/`:

- `cocinero.png` y `cocinero_front.png` para el escenario de restaurante.
- `pescador.png` y `pescador_front.png` para el escenario de pesca.
- `plato.jpg` como referencia visual de platos en la cocina y el menú.
- `asset_pj.jpeg` como hoja fuente del personaje con trajes, direcciones, caminata y acciones de pesca.
- `cana.jpeg` como referencia de caña de pesca.
- `frames/*.png` como recortes transparentes usados directamente por Godot.

Los personajes se mantienen en PNG. Las variantes `_front.png` son recortes del frente de cada archivo original para usarlos como sprite directo dentro del juego.

### Flujo nuevo del restaurante

Antes de abrir la cocina aparece una pantalla de **Menú del día**. El jugador puede elegir hasta 3 platos desbloqueados para vender durante la jornada. Con las 3 recetas actuales, todas quedan seleccionadas por defecto, pero el sistema ya está preparado para más recetas.

Los pedidos del día se generan solo desde `restaurant["day_menu"]`, no desde todo el listado de recetas desbloqueadas.

### Llegada de clientes

Los clientes ya no aparecen todos al mismo tiempo. Cada cliente empieza en estado `waiting_to_arrive`, entra al puesto con una separación aproximada de 5 a 8 segundos y solo entonces:

- se dibuja su tarjeta en la cocina;
- aparece su botón de entrega;
- empieza a contar su paciencia.

La paciencia ya no corre mientras el cliente todavía no llegó.

### Vista de cocina

La pantalla de restaurante ahora separa visualmente:

- protagonista cocinero;
- hornillas como estaciones de cocina;
- clientes presentes como tarjetas compactas;
- panel inferior con recetas del menú, entregas disponibles y cierre del día.

### Fondos de cocina por mejora

Se agregaron fondos nuevos en `assets/restaurant/`:

- `cocinal1.png`: cocina base para `upgrade_level == 0`.
- `cocina2.png`: cocina mejorada para `upgrade_level >= 1`, reutilizada para L2, L3 y futuros niveles mientras no exista otro fondo.

El restaurante ahora usa estos fondos como imagen full-screen en lugar del fondo procedural anterior. Al abrir el proyecto en Godot, el editor debe importar estos PNG y generar sus archivos `.import`.

### Clientes sentados

Se agregaron placeholders simples en `assets/restaurant/client_placeholder_*.png`. Los clientes se dibujan sentados en las mesas solo cuando su estado ya no es `waiting_to_arrive`. Si el cliente está presente, aparece con el plato pedido y paciencia restante; si ya fue atendido, queda visible con la cara de satisfacción final.

### Animaciones del protagonista

El protagonista ya no se dibuja como una imagen completamente estática. En pesca usa los frames de `asset_pj.jpeg` y cambia por estado:

- reposo con respiración y balanceo leve;
- lanzamiento de caña al iniciar el lance;
- espera con señuelo flotando;
- respiración falsa con los frames `respira_1`, `respira_2` y `respira_3`;
- mordida real con frame de tensión y vibración;
- jalar/pesca exitosa al terminar con buena o perfecta.

La línea, el señuelo, el splash y el bote también tienen movimiento para reforzar la lectura de la pesca. En restaurante, el cocinero tiene respiración y balanceo sutil mientras la cocina está abierta.

Como los frames de `asset_pj.jpeg` ya incluyen caña, línea, boya y algunos efectos de agua, el dibujo procedural anterior de línea/señuelo se desactiva cuando se usan esos frames. Esto evita que aparezcan dos cañas o dos líneas superpuestas.

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

## Mejoras jugables del puesto

`Mejorar puesto` ahora consume monedas y aplica efectos reales desde `upgrade_level`:

- Nivel 1: cocina 10% mas rapido y clientes con +2.5s de paciencia.
- Nivel 2: mantiene mejoras de restaurante, agrega 1 lance diario y amplia la ventana de pesca buena/perfecta.
- Nivel 3: agrega 1 alino diario y un bono moderado de precio por fama.
- Niveles superiores: escalan de forma acotada hasta 30% de cocina, +7.5s de paciencia, 7 lances, +2 alinos y hasta +24% de precios.

El costo cambia de `50 + nivel * 25` a `50 + nivel * 30 + max(0, nivel - 2) * 15` para compensar los bonos de produccion.

## Guardado y continuidad

El archivo `user://la_pochita_stone_save.json` ahora guarda tambien la partida en curso en `current_run`.

El boton `Continuar` restaura:

- Estado global persistente: monedas, estrellas, mejor nivel, recetas y mejor dia.
- Estado del dia: inventario, bote, lances restantes y resumen.
- Fase actual: pesca, seleccion de menu, restaurante o resumen.
- Pesca activa: fase del senuelo, timers restantes, ventana de mordida y ultimo resultado.
- Restaurante: menu elegido, hornillas, platos listos/en coccion, clientes, llegada, espera, satisfaccion y pedidos.

Los tiempos de hornillas, clientes y pesca se guardan como tiempos restantes o transcurridos para que sigan siendo validos despues de cerrar y abrir el juego.

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
