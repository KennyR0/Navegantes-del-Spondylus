extends Node

signal state_changed
signal log_changed

const INITIAL_RESOURCES := {
	"madera": 8,
	"fibra": 5,
	"algodon": 4,
	"herramientas": 3,
	"spondylus": 10,
	"suministros": 6,
	"artesanos": 3,
}

const MAX_PROGRESS := 10
const MAX_TURNS := 10

var resources: Dictionary = {}
var improvements: Dictionary = {}
var crew: Dictionary = {}
var deck: Array = []
var hand: Array = []
var logs: Array[String] = []

var actions_remaining := 3
var turn := 0
var progress := 0
var reputation := 0
var ship_integrity := 12
var max_ship_integrity := 20
var spondylus_capacity := 20
var game_over := false
var victory := false
var result_title := ""
var result_message := ""
var last_score := 0
var voyage_started := false

var active_event: Dictionary = {}
var evento_activo: Dictionary = {}
var event_phase := "preparacion"
var preparation_cards_played := 0
var max_preparation_cards := 2
var event_preparation_score := 0
var event_preparation_scores: Dictionary = {}
var event_choices: Array = []
var last_choice_result := ""

var legacy_points := 0
var total_legacy_earned := 0
var last_legacy_earned := 0
var shipyard_level := 1
var permanent_upgrades: Dictionary = {}
var legacy_awarded_this_run := false


func _ready() -> void:
	randomize()
	reset_game(false)


func reset_game(preserve_meta := true) -> void:
	var saved_legacy := legacy_points
	var saved_total := total_legacy_earned
	var saved_level := shipyard_level
	var saved_upgrades := permanent_upgrades.duplicate(true)
	resources = INITIAL_RESOURCES.duplicate(true)
	improvements = {
		"casco": false,
		"mastil": false,
		"redes": false,
		"carga": false,
		"altar": false,
	}
	crew = {
		"pescador": false,
		"carpintero": false,
		"navegante": false,
		"comerciante": false,
		"artesano_elite": false,
	}
	permanent_upgrades = _default_permanent_upgrades()
	legacy_points = 0
	total_legacy_earned = 0
	shipyard_level = 1
	if preserve_meta:
		legacy_points = saved_legacy
		total_legacy_earned = saved_total
		shipyard_level = saved_level
		if not saved_upgrades.is_empty():
			permanent_upgrades = saved_upgrades
	deck = []
	hand = []
	logs = []
	actions_remaining = 3
	turn = 0
	progress = 0
	reputation = 0
	max_ship_integrity = 20
	ship_integrity = 12
	spondylus_capacity = 20
	game_over = false
	victory = false
	result_title = ""
	result_message = ""
	last_score = 0
	voyage_started = false
	active_event = {}
	evento_activo = {}
	event_phase = "preparacion"
	preparation_cards_played = 0
	max_preparation_cards = 2
	event_preparation_score = 0
	event_preparation_scores = {}
	event_choices = []
	last_choice_result = ""
	last_legacy_earned = 0
	legacy_awarded_this_run = false
	_apply_permanent_run_bonuses()
	add_log("Amaru prepara una nueva expedicion en el astillero de Manta.")
	_emit_all()


func resource_summary() -> String:
	return "Madera %d | Fibra %d | Algodon %d | Herramientas %d | Spondylus %d | Suministros %d | Artesanos %d" % [
		resources["madera"],
		resources["fibra"],
		resources["algodon"],
		resources["herramientas"],
		resources["spondylus"],
		resources["suministros"],
		resources["artesanos"],
	]


func voyage_summary() -> String:
	return "Balsa %d/%d | Spondylus %d | Suministros %d | Progreso %d/%d | Turno %d/%d | Reputacion %d | Legado %d" % [
		ship_integrity,
		max_ship_integrity,
		resources["spondylus"],
		resources["suministros"],
		progress,
		MAX_PROGRESS,
		turn,
		MAX_TURNS,
		reputation,
		legacy_points,
	]


func spend(cost: Dictionary) -> bool:
	for key in cost.keys():
		if resources.get(key, 0) < int(cost[key]):
			return false
	for key in cost.keys():
		resources[key] -= int(cost[key])
	_emit_all()
	return true


func gain(values: Dictionary) -> void:
	_apply_outcome(values, "Ganancia")


func get_shipyard_options() -> Array:
	return [
		{"id": "casco", "group": "Construir", "title": "Reforzar el Casco", "cost": {"madera": 3, "herramientas": 1}, "desc": "+3 integridad inicial."},
		{"id": "mastil", "group": "Construir", "title": "Mejorar el Mastil", "cost": {"fibra": 2, "algodon": 1}, "desc": "+1 progreso adicional tras resolver eventos."},
		{"id": "redes", "group": "Construir", "title": "Redes de Pesca", "cost": {"fibra": 2, "algodon": 1}, "desc": "+1 preparacion en eventos de pesca."},
		{"id": "carga", "group": "Construir", "title": "Compartimento de Carga", "cost": {"madera": 2, "herramientas": 1}, "desc": "+10 capacidad de Spondylus."},
		{"id": "altar", "group": "Construir", "title": "Altar a Umina", "cost": {"spondylus": 1}, "desc": "+1 preparacion espiritual."},
		{"id": "provisiones", "group": "Comerciar", "title": "Provisiones extra", "cost": {"spondylus": 2}, "desc": "+3 suministros."},
		{"id": "materiales", "group": "Comerciar", "title": "Materiales de reparacion", "cost": {"herramientas": 1}, "desc": "+2 madera y +1 fibra."},
		{"id": "artesano_elite", "group": "Comerciar", "title": "Artesano especialista", "cost": {"spondylus": 3}, "desc": "Mejora reparaciones de trabajo."},
		{"id": "pescador", "group": "Contratar", "title": "Pescador", "cost": {"spondylus": 2}, "desc": "+1 preparacion en pesca y +2 suministros en recompensas."},
		{"id": "carpintero", "group": "Contratar", "title": "Carpintero Naval", "cost": {"spondylus": 3}, "desc": "Reduce dano y suma resistencia."},
		{"id": "navegante", "group": "Contratar", "title": "Navegante Estelar", "cost": {"spondylus": 4}, "desc": "+1 preparacion en navegacion."},
		{"id": "comerciante", "group": "Contratar", "title": "Comerciante Experto", "cost": {"spondylus": 3}, "desc": "+1 preparacion en comercio."},
	]


func get_permanent_upgrade_options() -> Array:
	return [
		{"id": "taller_basico", "title": "Taller organizado", "cost": 4, "desc": "+1 accion de preparacion en el astillero."},
		{"id": "quilla_firme", "title": "Quilla firme", "cost": 5, "desc": "+3 balsa inicial y maxima."},
		{"id": "rutas_memorizadas", "title": "Rutas memorizadas", "cost": 6, "desc": "+1 preparacion por carta en navegacion."},
		{"id": "bodega_comunal", "title": "Bodega comunal", "cost": 6, "desc": "+2 suministros y +1 Spondylus al iniciar cada expedicion."},
		{"id": "rituales_puerto", "title": "Rituales de puerto", "cost": 7, "desc": "+1 preparacion espiritual y +1 reputacion inicial."},
	]


func buy_permanent_upgrade(upgrade_id: String) -> String:
	var upgrade := _find_permanent_upgrade(upgrade_id)
	if upgrade.is_empty():
		return "Mejora permanente no encontrada."
	if permanent_upgrades.get(upgrade_id, false):
		return "Esa mejora ya esta desbloqueada."
	if legacy_points < int(upgrade["cost"]):
		return "Legado insuficiente para %s." % upgrade["title"]
	legacy_points -= int(upgrade["cost"])
	permanent_upgrades[upgrade_id] = true
	shipyard_level = 1 + _active_permanent_upgrade_count()
	add_log("Legado invertido: %s." % upgrade["title"])
	_emit_all()
	return "%s desbloqueado. Legado restante: %d." % [upgrade["title"], legacy_points]


func permanent_upgrade_labels() -> Array[String]:
	var labels: Array[String] = []
	for upgrade in get_permanent_upgrade_options():
		if permanent_upgrades.get(upgrade["id"], false):
			labels.append(upgrade["title"])
	return labels


func apply_shipyard_option(option_id: String) -> String:
	if actions_remaining <= 0:
		return "No quedan acciones de preparacion."
	var option := _find_shipyard_option(option_id)
	if option.is_empty():
		return "Opcion no encontrada."
	if _is_unique_option_taken(option_id):
		return "Ya elegiste esa mejora o tripulante."
	if not spend(option["cost"]):
		return "Recursos insuficientes para %s." % option["title"]
	actions_remaining -= 1
	match option_id:
		"casco":
			improvements["casco"] = true
			repair_ship(3, "El casco reforzado aumenta la resistencia inicial.")
		"mastil":
			improvements["mastil"] = true
			add_log("El mastil mejorado promete una travesia mas veloz.")
		"redes":
			improvements["redes"] = true
			add_log("Las redes de pesca quedan listas para el mar.")
		"carga":
			improvements["carga"] = true
			spondylus_capacity += 10
			add_log("La balsa puede cargar mas Spondylus.")
		"altar":
			improvements["altar"] = true
			reputation += 2
			add_log("La ofrenda a Umina bendice la expedicion.")
		"provisiones":
			gain({"suministros": 3})
			add_log("El puerto entrega provisiones extra.")
		"materiales":
			gain({"madera": 2, "fibra": 1})
			add_log("Se aseguran materiales de reparacion.")
		"artesano_elite":
			crew["artesano_elite"] = true
			add_log("Un artesano especialista se une al astillero.")
		"pescador", "carpintero", "navegante", "comerciante":
			crew[option_id] = true
			add_log("%s se une a la tripulacion." % option["title"])
	_emit_all()
	return "%s completado. Acciones restantes: %d." % [option["title"], actions_remaining]


func start_voyage() -> void:
	voyage_started = true
	deck = CardDatabase.build_deck()
	hand = []
	active_event = {}
	evento_activo = {}
	event_choices = []
	add_log("La balsa zarpa hacia la Ruta del Spondylus.")
	start_voyage_turn()


func start_voyage_turn() -> void:
	if game_over or victory:
		return
	turn += 1
	if resources["suministros"] > 0:
		resources["suministros"] -= 1
		add_log("Turno %d: la tripulacion consume 1 suministro." % turn)
	else:
		damage_ship(2, "La falta de suministros enferma a la tripulacion.")
	if game_over:
		_emit_all()
		return
	start_event()


func start_event() -> void:
	active_event = EventSystem.get_random_event(turn)
	evento_activo = active_event
	event_phase = "preparacion"
	preparation_cards_played = 0
	event_preparation_score = 0
	event_preparation_scores = {}
	last_choice_result = ""
	max_preparation_cards = 2 + (1 if permanent_upgrades.get("taller_basico", false) else 0)
	event_choices = []
	hand = CardDatabase.draw_cards(deck, 3, active_event)
	add_log("Encuentro: %s. Prepara la respuesta con cartas." % active_event["nombre"])
	_emit_all()


func play_card(card_id: String) -> void:
	play_preparation_card(card_id)


func play_preparation_card(card_id: String) -> void:
	if game_over or victory or event_phase != "preparacion":
		return
	var card := _find_card_in_hand(card_id)
	if card.is_empty():
		return
	hand.erase(card)
	preparation_cards_played += 1
	var gained := _score_card_preparation(card)
	event_preparation_score += gained
	add_log("Preparacion: %s aporta +%d contra %s." % [card["title"], gained, active_event["nombre"]])
	if preparation_cards_played >= max_preparation_cards or hand.is_empty():
		build_event_choices()
	_emit_all()


func build_event_choices() -> void:
	event_phase = "decision"
	event_choices = active_event.get("choices", [])
	hand = []
	add_log("Decide como resolver %s." % active_event["nombre"])
	_emit_all()


func resolve_event_choice(choice_id: String) -> void:
	if game_over or victory or event_phase != "decision":
		return
	var choice := _find_event_choice(choice_id)
	if choice.is_empty():
		return
	var score: int = EventSystem.choice_score(active_event, event_preparation_scores, choice)
	var difficulty: int = int(active_event.get("dificultad", 1))
	if EventSystem.choice_succeeds(active_event, event_preparation_scores, choice):
		last_choice_result = "Exito: %s (%d/%d)" % [choice["texto"], score, difficulty]
		add_log(last_choice_result)
		grant_event_reward(choice.get("success", {}), choice)
	else:
		last_choice_result = "Fallo: %s (%d/%d)" % [choice["texto"], score, difficulty]
		add_log(last_choice_result)
		_apply_outcome(choice.get("failure", {}), active_event["nombre"])
	_close_event_and_advance()


func grant_event_reward(reward: Dictionary, choice: Dictionary = {}) -> void:
	var final_reward := reward.duplicate(true)
	if crew["pescador"] and str(choice.get("tag", "")) == "pesca":
		final_reward["suministros"] = int(final_reward.get("suministros", 0)) + 2
	if permanent_upgrades.get("bodega_comunal", false) and str(choice.get("tag", "")) == "comercio":
		final_reward["spondylus"] = int(final_reward.get("spondylus", 0)) + 1
	_apply_outcome(final_reward, "Recompensa")


func active_crew_count() -> int:
	var count := 0
	for key in crew.keys():
		if crew[key]:
			count += 1
	return count


func active_crew_labels() -> Array[String]:
	var labels: Array[String] = []
	for key in crew.keys():
		if crew[key]:
			labels.append(str(key).capitalize().replace("_", " "))
	return labels


func active_improvement_labels() -> Array[String]:
	var labels: Array[String] = []
	for key in improvements.keys():
		if improvements[key]:
			labels.append(str(key).capitalize().replace("_", " "))
	return labels


func damage_ship(amount: int, reason: String) -> void:
	var final_amount := amount
	if crew["carpintero"] and final_amount > 1:
		final_amount -= 1
		reason += " El carpintero reduce 1 punto de dano."
	ship_integrity -= final_amount
	add_log("%s (-%d balsa)" % [reason, final_amount])
	if ship_integrity <= 0:
		ship_integrity = 0
		fail_voyage("Las aguas del Pacifico se tragaron tu balsa.")
	_emit_all()


func repair_ship(amount: int, reason: String) -> void:
	var final_amount := amount
	if crew["artesano_elite"]:
		final_amount += 1
	ship_integrity = min(max_ship_integrity, ship_integrity + final_amount)
	add_log("%s (+%d balsa)" % [reason, final_amount])
	_emit_all()


func complete_voyage() -> void:
	victory = true
	if resources["spondylus"] > 15:
		reputation += 4
	last_score = calculate_score()
	_set_result_rank(last_score)
	finish_run_and_grant_legacy()
	add_log("La expedicion llega a destino.")
	_emit_all()


func fail_voyage(message: String) -> void:
	game_over = true
	victory = false
	result_title = "Game Over"
	result_message = message
	last_score = calculate_score()
	finish_run_and_grant_legacy()
	add_log(message)
	_emit_all()


func finish_run_and_grant_legacy() -> void:
	if legacy_awarded_this_run:
		return
	legacy_awarded_this_run = true
	var earned: int = max(1, progress + int(reputation / 2) + int(resources.get("spondylus", 0) / 4))
	if victory:
		earned += 6
	if ship_integrity > 0:
		earned += int(ship_integrity / 5)
	last_legacy_earned = earned
	legacy_points += earned
	total_legacy_earned += earned
	result_message += "\nLegado ganado: %d. Usalo para mejorar el astillero." % earned


func calculate_score() -> int:
	return max(0, resources["spondylus"]) * 10 + ship_integrity * 5 + max(0, resources["suministros"]) * 3 + reputation * 8 + progress * 12 + 15


func add_log(message: String) -> void:
	logs.append(message)
	if logs.size() > 12:
		logs.pop_front()
	log_changed.emit()


func latest_logs_text() -> String:
	return "\n".join(logs)


func _close_event_and_advance() -> void:
	if game_over or victory:
		_emit_all()
		return
	active_event = {}
	evento_activo = {}
	event_choices = []
	hand = []
	var advance := 1
	if improvements["mastil"]:
		advance += 1
	if permanent_upgrades.get("rutas_memorizadas", false) and last_choice_result.begins_with("Exito"):
		advance += 1
	progress += advance
	add_log("La balsa avanza +%d progreso tras resolver el encuentro." % advance)
	if progress >= MAX_PROGRESS or turn >= MAX_TURNS:
		complete_voyage()
	else:
		start_voyage_turn()
	_emit_all()


func _score_card_preparation(card: Dictionary) -> int:
	var gained := 0
	var preparation: Dictionary = card.get("preparacion", {})
	for tag in preparation.keys():
		var value: int = int(preparation[tag])
		if active_event.get("tags", []).has(tag):
			value += _bonus_for_tag(str(tag))
			event_preparation_scores[tag] = int(event_preparation_scores.get(tag, 0)) + value
			gained += value
	if gained <= 0:
		gained = 1
		event_preparation_scores["apoyo"] = int(event_preparation_scores.get("apoyo", 0)) + 1
	return gained


func _bonus_for_tag(tag: String) -> int:
	var bonus := 0
	if tag == "pesca" and (improvements["redes"] or crew["pescador"]):
		bonus += 1
	if tag == "espiritualidad" and (improvements["altar"] or permanent_upgrades.get("rituales_puerto", false)):
		bonus += 1
	if tag == "navegacion" and (crew["navegante"] or permanent_upgrades.get("rutas_memorizadas", false)):
		bonus += 1
	if tag == "comercio" and crew["comerciante"]:
		bonus += 1
	if tag == "resistencia" and crew["carpintero"]:
		bonus += 1
	return bonus


func _apply_outcome(values: Dictionary, reason: String) -> void:
	for key in values.keys():
		var amount: int = int(values[key])
		match key:
			"balsa":
				if amount >= 0:
					repair_ship(amount, "%s fortalece la balsa." % reason)
				else:
					damage_ship(abs(amount), "%s castiga la balsa." % reason)
			"progreso":
				progress = max(0, progress + amount)
				add_log("%s cambia el progreso %+d." % [reason, amount])
			"reputacion":
				reputation += amount
				add_log("%s cambia la reputacion %+d." % [reason, amount])
			_:
				resources[key] = max(0, resources.get(key, 0) + amount)
				if key == "spondylus":
					resources[key] = min(spondylus_capacity, resources[key])
				add_log("%s: %s %+d." % [reason, key, amount])
	_emit_all()


func _apply_permanent_run_bonuses() -> void:
	if permanent_upgrades.get("taller_basico", false):
		actions_remaining += 1
	if permanent_upgrades.get("quilla_firme", false):
		max_ship_integrity += 3
		ship_integrity += 3
	if permanent_upgrades.get("bodega_comunal", false):
		resources["suministros"] += 2
		resources["spondylus"] += 1
	if permanent_upgrades.get("rituales_puerto", false):
		reputation += 1


func _default_permanent_upgrades() -> Dictionary:
	return {
		"taller_basico": false,
		"quilla_firme": false,
		"rutas_memorizadas": false,
		"bodega_comunal": false,
		"rituales_puerto": false,
	}


func _active_permanent_upgrade_count() -> int:
	var count := 0
	for key in permanent_upgrades.keys():
		if permanent_upgrades[key]:
			count += 1
	return count


func _find_shipyard_option(option_id: String) -> Dictionary:
	for option in get_shipyard_options():
		if option["id"] == option_id:
			return option
	return {}


func _find_permanent_upgrade(upgrade_id: String) -> Dictionary:
	for upgrade in get_permanent_upgrade_options():
		if upgrade["id"] == upgrade_id:
			return upgrade
	return {}


func _find_event_choice(choice_id: String) -> Dictionary:
	for choice in event_choices:
		if choice["id"] == choice_id:
			return choice
	return {}


func _is_unique_option_taken(option_id: String) -> bool:
	return improvements.get(option_id, false) or crew.get(option_id, false)


func _find_card_in_hand(card_id: String) -> Dictionary:
	for card in hand:
		if card["id"] == card_id:
			return card
	return {}


func _set_result_rank(score: int) -> void:
	if score >= 300:
		result_title = "Senor del Spondylus"
		result_message = "Umina sonrie. Tu nombre quedara grabado en las piedras de Manta."
	elif score >= 200:
		result_title = "Maestro del Astillero"
		result_message = "Las rutas conocen tu nombre, Amaru."
	elif score >= 100:
		result_title = "Navegante del Pacifico"
		result_message = "Tu balsa llego. Tu pueblo sobrevivio."
	else:
		result_title = "Pescador Novato"
		result_message = "El mar te probo y casi te vencio."


func _emit_all() -> void:
	state_changed.emit()
	log_changed.emit()
