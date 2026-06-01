extends Node

const EVENT_TYPES := {
	"enemigo": Color("#9d2f2f"),
	"clima": Color("#2f6f95"),
	"puerto": Color("#c4712a"),
	"averia": Color("#6b3a2a"),
	"sagrado": Color("#2ebfa5"),
}

var events: Array[Dictionary] = [
	{
		"id": "piratas_pacifico",
		"nombre": "Piratas del Pacifico",
		"tipo": "enemigo",
		"descripcion": "Una canoa armada corta la ruta y exige tributo.",
		"icono": "!",
		"dificultad": 5,
		"tags": ["comercio", "liderazgo", "resistencia"],
		"choices": [
			{"id": "negociar", "texto": "Negociar con Spondylus", "tag": "comercio", "bonus": 1, "success": {"spondylus": 2, "reputacion": 1}, "failure": {"spondylus": -3}},
			{"id": "huir", "texto": "Forzar la huida", "tag": "resistencia", "bonus": 0, "success": {"progreso": 1}, "failure": {"balsa": -3}},
			{"id": "intimidar", "texto": "Imponer respeto", "tag": "liderazgo", "bonus": -1, "success": {"reputacion": 3}, "failure": {"reputacion": -2, "balsa": -1}},
		],
	},
	{
		"id": "cardumen_tiburones",
		"nombre": "Cardumen de Tiburones",
		"tipo": "enemigo",
		"descripcion": "Los tiburones rodean la balsa y la tripulacion duda.",
		"icono": "!",
		"dificultad": 4,
		"tags": ["pesca", "navegacion", "resistencia"],
		"choices": [
			{"id": "cebo", "texto": "Usar carnada y apartarlos", "tag": "pesca", "bonus": 1, "success": {"suministros": 2}, "failure": {"suministros": -2}},
			{"id": "rodear", "texto": "Rodear el cardumen", "tag": "navegacion", "bonus": 0, "success": {"progreso": 1}, "failure": {"progreso": -1}},
			{"id": "resistir", "texto": "Proteger el casco", "tag": "resistencia", "bonus": 0, "success": {"balsa": 1}, "failure": {"balsa": -2}},
		],
	},
	{
		"id": "tormenta_mayor",
		"nombre": "Tormenta Mayor",
		"tipo": "clima",
		"descripcion": "El cielo se cierra y el mar golpea como piedra.",
		"icono": "!",
		"dificultad": 6,
		"tags": ["navegacion", "resistencia", "espiritualidad"],
		"choices": [
			{"id": "capear", "texto": "Capear la tormenta", "tag": "resistencia", "bonus": 1, "success": {"balsa": 2}, "failure": {"balsa": -4}},
			{"id": "buscar_viento", "texto": "Leer el viento", "tag": "navegacion", "bonus": 0, "success": {"progreso": 2}, "failure": {"balsa": -2, "progreso": -1}},
			{"id": "ofrendar", "texto": "Pedir favor a Umina", "tag": "espiritualidad", "bonus": 0, "success": {"reputacion": 2, "balsa": 1}, "failure": {"spondylus": -1, "balsa": -2}},
		],
	},
	{
		"id": "motin_a_bordo",
		"nombre": "Motin a Bordo",
		"tipo": "enemigo",
		"descripcion": "El cansancio rompe la confianza de la tripulacion.",
		"icono": "!",
		"dificultad": 5,
		"tags": ["liderazgo", "comercio", "espiritualidad"],
		"choices": [
			{"id": "discurso", "texto": "Reunir a la tripulacion", "tag": "liderazgo", "bonus": 1, "success": {"reputacion": 2}, "failure": {"reputacion": -3}},
			{"id": "racionar", "texto": "Prometer mejor reparto", "tag": "comercio", "bonus": 0, "success": {"suministros": 1}, "failure": {"suministros": -2}},
			{"id": "ritual", "texto": "Calmar con un ritual", "tag": "espiritualidad", "bonus": 0, "success": {"reputacion": 1, "balsa": 1}, "failure": {"spondylus": -1, "reputacion": -1}},
		],
	},
	{
		"id": "corriente_peligrosa",
		"nombre": "Corriente Peligrosa",
		"tipo": "clima",
		"descripcion": "Una corriente arrastra la balsa fuera de la ruta.",
		"icono": "!",
		"dificultad": 4,
		"tags": ["navegacion", "resistencia"],
		"choices": [
			{"id": "timonear", "texto": "Timonear contra el agua", "tag": "navegacion", "bonus": 1, "success": {"progreso": 2}, "failure": {"progreso": -2}},
			{"id": "remar", "texto": "Remar hasta salir", "tag": "resistencia", "bonus": 0, "success": {"progreso": 1}, "failure": {"suministros": -2, "balsa": -1}},
		],
	},
	{
		"id": "puerto_aliado",
		"nombre": "Puerto Aliado",
		"tipo": "puerto",
		"descripcion": "Una comunidad costera ofrece ayuda, pero espera reciprocidad.",
		"icono": "+",
		"dificultad": 3,
		"tags": ["comercio", "liderazgo"],
		"choices": [
			{"id": "trueque", "texto": "Hacer trueque", "tag": "comercio", "bonus": 1, "success": {"suministros": 3, "spondylus": 1}, "failure": {"spondylus": -2}},
			{"id": "alianza", "texto": "Sellar alianza", "tag": "liderazgo", "bonus": 0, "success": {"reputacion": 3}, "failure": {"reputacion": -1}},
		],
	},
	{
		"id": "grieta_urgente",
		"nombre": "Grieta Urgente",
		"tipo": "averia",
		"descripcion": "El casco toma agua y cada decision pesa.",
		"icono": "!",
		"dificultad": 5,
		"tags": ["resistencia", "navegacion"],
		"choices": [
			{"id": "reparar", "texto": "Reparar con madera", "tag": "resistencia", "bonus": 1, "success": {"balsa": 3}, "failure": {"madera": -2, "balsa": -3}},
			{"id": "aligerar", "texto": "Aligerar la carga", "tag": "navegacion", "bonus": 0, "success": {"progreso": 1}, "failure": {"spondylus": -2}},
		],
	},
	{
		"id": "senal_umina",
		"nombre": "Senal de Umina",
		"tipo": "sagrado",
		"descripcion": "Una concha brilla bajo la luna y marca una decision ritual.",
		"icono": "+",
		"dificultad": 4,
		"tags": ["espiritualidad", "liderazgo"],
		"choices": [
			{"id": "ofrenda", "texto": "Hacer ofrenda", "tag": "espiritualidad", "bonus": 1, "success": {"reputacion": 2, "progreso": 1}, "failure": {"spondylus": -1}},
			{"id": "inspirar", "texto": "Inspirar a la tripulacion", "tag": "liderazgo", "bonus": 0, "success": {"reputacion": 1, "suministros": 1}, "failure": {"reputacion": -1}},
		],
	},
]


func get_random_event(turn: int = 1) -> Dictionary:
	var pool: Array = []
	for event in events:
		if turn < 3 and int(event.get("dificultad", 1)) <= 5:
			pool.append(event)
	if pool.is_empty():
		pool = events
	return pool.pick_random().duplicate(true)


func get_type_color(event_type: String) -> Color:
	return EVENT_TYPES.get(event_type, Color("#f5f0e8"))


func card_preparation_for_event(card: Dictionary, event: Dictionary) -> int:
	if card.is_empty() or event.is_empty():
		return 0
	var total := 0
	var event_tags: Array = event.get("tags", [])
	var preparation: Dictionary = card.get("preparacion", {})
	for tag in preparation.keys():
		if event_tags.has(tag):
			total += int(preparation[tag])
	return total


func choice_score(event: Dictionary, scores: Dictionary, choice: Dictionary) -> int:
	var tag: String = str(choice.get("tag", ""))
	var score: int = int(scores.get(tag, 0)) + int(choice.get("bonus", 0))
	for event_tag in event.get("tags", []):
		if str(event_tag) != tag:
			score += int(int(scores.get(event_tag, 0)) / 3)
	return score


func choice_succeeds(event: Dictionary, scores: Dictionary, choice: Dictionary) -> bool:
	return choice_score(event, scores, choice) >= int(event.get("dificultad", 1))
