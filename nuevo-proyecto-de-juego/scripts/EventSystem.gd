extends Node

const EVENT_CHANCE := 0.3

var events: Array[Dictionary] = [
	{
		"nombre": "Tormenta en mar abierto",
		"descripcion": "Olas gigantes sacuden la balsa.",
		"icono": "!",
		"penalizacion": {"balsa": -2},
		"evento_compatible": ["navegacion", "resistencia"],
	},
	{
		"nombre": "Motin a bordo",
		"descripcion": "La tripulacion pierde confianza.",
		"icono": "!",
		"penalizacion": {"reputacion": -2},
		"evento_compatible": ["liderazgo", "comercio"],
	},
	{
		"nombre": "Cardumen de tiburones",
		"descripcion": "El avance se detiene por miedo.",
		"icono": "!",
		"penalizacion": {"progreso": -1},
		"evento_compatible": ["pesca", "navegacion"],
	},
	{
		"nombre": "Neblina espesa",
		"descripcion": "No se puede avanzar sin guia.",
		"icono": "!",
		"penalizacion": {"progreso": -1},
		"evento_compatible": ["espiritualidad", "navegacion"],
	},
	{
		"nombre": "Escasez de agua",
		"descripcion": "Los suministros caen rapido.",
		"icono": "!",
		"penalizacion": {"suministros": -2},
		"evento_compatible": ["comercio", "pesca"],
	},
	{
		"nombre": "Corriente adversa",
		"descripcion": "La balsa retrocede.",
		"icono": "!",
		"penalizacion": {"progreso": -2},
		"evento_compatible": ["resistencia", "navegacion"],
	},
]


func get_random_event() -> Dictionary:
	return events.pick_random().duplicate(true)


func resolve_event(event: Dictionary, card_played: Dictionary) -> bool:
	if event.is_empty() or card_played.is_empty():
		return false
	var needed: Array = event.get("evento_compatible", [])
	var tags: Array = card_played.get("evento_compatible", [])
	for tag in tags:
		if needed.has(tag):
			return true
	return false


func apply_penalty(event: Dictionary) -> void:
	if event.is_empty():
		return
	var penalty: Dictionary = event.get("penalizacion", {})
	for key in penalty.keys():
		var amount := int(penalty[key])
		match key:
			"balsa":
				if amount < 0:
					GameState.damage_ship(abs(amount), "El evento %s castiga la balsa." % event["nombre"])
				else:
					GameState.repair_ship(amount, "El evento %s fortalece la balsa." % event["nombre"])
			"suministros":
				GameState.resources["suministros"] = max(0, GameState.resources.get("suministros", 0) + amount)
			"reputacion":
				GameState.reputation += amount
			"progreso":
				GameState.progress = max(0, GameState.progress + amount)
			_:
				GameState.resources[key] = max(0, GameState.resources.get(key, 0) + amount)
