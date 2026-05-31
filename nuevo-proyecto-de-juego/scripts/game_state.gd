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
var evento_activo: Dictionary = {}
var evento_resuelto_este_turno := false


func _ready() -> void:
	randomize()
	reset_game()


func reset_game() -> void:
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
	deck = []
	hand = []
	logs = []
	actions_remaining = 3
	turn = 0
	progress = 0
	reputation = 0
	ship_integrity = 12
	max_ship_integrity = 20
	spondylus_capacity = 20
	game_over = false
	victory = false
	result_title = ""
	result_message = ""
	last_score = 0
	voyage_started = false
	evento_activo = {}
	evento_resuelto_este_turno = false
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
	return "Balsa %d/%d | Spondylus %d | Suministros %d | Progreso %d/%d | Turno %d/%d | Reputacion %d" % [
		ship_integrity,
		max_ship_integrity,
		resources["spondylus"],
		resources["suministros"],
		progress,
		MAX_PROGRESS,
		turn,
		MAX_TURNS,
		reputation,
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
	for key in values.keys():
		resources[key] = resources.get(key, 0) + int(values[key])
	if resources["spondylus"] > spondylus_capacity:
		resources["spondylus"] = spondylus_capacity
	_emit_all()


func get_shipyard_options() -> Array:
	return [
		{"id": "casco", "group": "Construir", "title": "Reforzar el Casco", "cost": {"madera": 3, "herramientas": 1}, "desc": "+3 integridad inicial."},
		{"id": "mastil", "group": "Construir", "title": "Mejorar el Mastil", "cost": {"fibra": 2, "algodon": 1}, "desc": "+1 progreso adicional por turno."},
		{"id": "redes", "group": "Construir", "title": "Redes de Pesca", "cost": {"fibra": 2, "algodon": 1}, "desc": "Mejora cartas de pesca."},
		{"id": "carga", "group": "Construir", "title": "Compartimento de Carga", "cost": {"madera": 2, "herramientas": 1}, "desc": "+10 capacidad de Spondylus."},
		{"id": "altar", "group": "Construir", "title": "Altar a Umina", "cost": {"spondylus": 1}, "desc": "Activa bendiciones sagradas."},
		{"id": "provisiones", "group": "Comerciar", "title": "Provisiones extra", "cost": {"spondylus": 2}, "desc": "+3 suministros."},
		{"id": "materiales", "group": "Comerciar", "title": "Materiales de reparacion", "cost": {"herramientas": 1}, "desc": "+2 madera y +1 fibra."},
		{"id": "artesano_elite", "group": "Comerciar", "title": "Artesano especialista", "cost": {"spondylus": 3}, "desc": "Mejora reparaciones de trabajo."},
		{"id": "pescador", "group": "Contratar", "title": "Pescador", "cost": {"spondylus": 2}, "desc": "+2 suministros en pesca."},
		{"id": "carpintero", "group": "Contratar", "title": "Carpintero Naval", "cost": {"spondylus": 3}, "desc": "Reduce dano y mejora reparaciones."},
		{"id": "navegante", "group": "Contratar", "title": "Navegante Estelar", "cost": {"spondylus": 4}, "desc": "Evita eventos climaticos graves."},
		{"id": "comerciante", "group": "Contratar", "title": "Comerciante Experto", "cost": {"spondylus": 3}, "desc": "+2 Spondylus en comercio."},
	]


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
	evento_activo = {}
	evento_resuelto_este_turno = false
	add_log("La balsa zarpa hacia la Ruta del Spondylus.")
	start_voyage_turn()


func start_voyage_turn() -> void:
	if game_over or victory:
		return
	turn += 1
	evento_resuelto_este_turno = false
	if resources["suministros"] > 0:
		resources["suministros"] -= 1
		add_log("Turno %d: la tripulacion consume 1 suministro." % turn)
	else:
		damage_ship(2, "La falta de suministros enferma a la tripulacion.")
	if evento_activo.is_empty() and randf() <= EventSystem.EVENT_CHANCE:
		evento_activo = EventSystem.get_random_event()
		add_log("Evento activo: %s. Se resuelve con %s." % [evento_activo["nombre"], ", ".join(evento_activo["evento_compatible"])])
	hand = CardDatabase.draw_cards(deck, 3, evento_activo)
	add_log("Robas 3 cartas de evento.")
	_emit_all()


func play_card(card_id: String) -> void:
	if game_over or victory:
		return
	var card := _find_card_in_hand(card_id)
	if card.is_empty():
		return
	hand.erase(card)
	add_log("Carta jugada: %s." % card["title"])
	if EventSystem.resolve_event(evento_activo, card):
		evento_resuelto_este_turno = true
		add_log("El evento %s queda resuelto." % evento_activo["nombre"])
	_apply_card_effect(card_id)
	if game_over or victory:
		_emit_all()
		return
	_close_active_event()
	if game_over or victory:
		_emit_all()
		return
	var advance := 1
	if improvements["mastil"]:
		advance += 1
	progress += advance
	add_log("La balsa avanza +%d progreso al cerrar el turno." % advance)
	if progress >= MAX_PROGRESS or turn >= MAX_TURNS:
		complete_voyage()
	else:
		start_voyage_turn()
	_emit_all()


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
	add_log("La expedicion llega a destino.")
	_emit_all()


func fail_voyage(message: String) -> void:
	game_over = true
	victory = false
	result_title = "Game Over"
	result_message = message
	last_score = calculate_score()
	add_log(message)
	_emit_all()


func calculate_score() -> int:
	return max(0, resources["spondylus"]) * 10 + ship_integrity * 5 + max(0, resources["suministros"]) * 3 + reputation * 8 + 15


func add_log(message: String) -> void:
	logs.append(message)
	if logs.size() > 12:
		logs.pop_front()
	log_changed.emit()


func _close_active_event() -> void:
	if evento_activo.is_empty():
		return
	if evento_resuelto_este_turno:
		evento_activo = {}
		return
	add_log("No resolviste %s. Se aplica la penalizacion." % evento_activo["nombre"])
	EventSystem.apply_penalty(evento_activo)
	evento_activo = {}


func latest_logs_text() -> String:
	return "\n".join(logs)


func _find_shipyard_option(option_id: String) -> Dictionary:
	for option in get_shipyard_options():
		if option["id"] == option_id:
			return option
	return {}


func _is_unique_option_taken(option_id: String) -> bool:
	return improvements.get(option_id, false) or crew.get(option_id, false)


func _find_card_in_hand(card_id: String) -> Dictionary:
	for card in hand:
		if card["id"] == card_id:
			return card
	return {}


func _apply_card_effect(card_id: String) -> void:
	match card_id:
		"tormenta_norte":
			damage_ship(1 if crew["navegante"] else 3, "La tormenta del norte golpea el casco.")
		"corriente_contraria":
			if resources["suministros"] > 0:
				resources["suministros"] -= 1
				add_log("Remas contra la corriente y gastas 1 suministro.")
			else:
				progress = max(0, progress - 1)
				add_log("La corriente frena la ruta.")
		"vientos_favorables":
			progress += 2
			add_log("Los vientos favorables empujan las velas.")
		"niebla_espesa":
			progress = max(0, progress - 1)
			if randi() % 2 == 0:
				damage_ship(2, "La niebla oculta un arrecife.")
			else:
				add_log("La tripulacion evita el arrecife entre la niebla.")
		"marea_roja":
			resources["suministros"] = max(0, resources["suministros"] - 1)
			add_log("La marea roja impide pescar.")
		"calma_chicha":
			if resources["artesanos"] > 0:
				repair_ship(1, "La calma permite reparar la balsa.")
			else:
				progress = max(0, progress - 1)
		"aguacero_torrencial":
			gain({"suministros": 1})
			damage_ship(2, "El aguacero castiga la estructura.")
		"tromba_marina":
			if crew["navegante"]:
				add_log("El navegante estelar esquiva la tromba marina.")
			else:
				damage_ship(4, "La tromba marina amenaza con hundir la balsa.")
		"viento_huracanado":
			damage_ship(2, "El viento huracanado fuerza el avance.")
			progress += 3
		"amanecer_sereno":
			gain({"suministros": 1})
			progress += 1
			add_log("El amanecer sereno renueva la ruta.")
		"banco_peces":
			gain({"suministros": 4 if crew["pescador"] else 2})
			progress = max(0, progress - 1)
			add_log("La tripulacion pesca en un banco abundante.")
		"ballena_jorobada":
			gain({"suministros": 1})
			add_log("La ballena jorobada levanta la moral.")
		"banco_tiburones":
			resources["suministros"] = max(0, resources["suministros"] - 1)
			add_log("Los tiburones obligan a guardar las redes.")
		"tortuga_marina":
			repair_ship(1, "La tortuga marina trae buen augurio.")
		"pulpo_gigante":
			if resources["herramientas"] > 0:
				resources["herramientas"] -= 1
				add_log("Usas una herramienta para liberar los timones.")
			else:
				progress = max(0, progress - 1)
				add_log("El pulpo retrasa la navegacion.")
		"cardumen_sardinas":
			gain({"suministros": 3 if improvements["redes"] else 1})
			add_log("Las sardinas llenan las reservas.")
		"medusas_paso":
			resources["suministros"] = max(0, resources["suministros"] - 1)
			add_log("Las medusas arruinan la pesca.")
		"delfines_guia":
			progress += 1
			reputation += 1
			add_log("Los delfines guian la balsa.")
		"puerto_huancavilca":
			gain({"spondylus": 5 if crew["comerciante"] else 3})
			progress = max(0, progress - 1)
			add_log("El puerto aliado fortalece el comercio.")
		"comerciantes_chimu":
			if resources["spondylus"] >= 2:
				resources["spondylus"] -= 2
				gain({"suministros": 3})
			add_log("Comercias con visitantes Chimu.")
		"pueblo_valdivia":
			if resources["spondylus"] > 0:
				resources["spondylus"] -= 1
				reputation += 2
			add_log("La ofrenda en Valdivia honra la ruta sagrada.")
		"piratas_pacifico":
			if resources["spondylus"] >= 2:
				resources["spondylus"] -= 2
				add_log("Negocias con los piratas.")
			else:
				damage_ship(2, "Huyes de los piratas a toda fuerza.")
		"mercado_flotante":
			if resources["spondylus"] >= 3:
				resources["spondylus"] -= 3
				repair_ship(2, "El mercado flotante vende reparaciones.")
		"mensajero_tumbes":
			progress += 1
			add_log("El mensajero revela una ruta segura.")
		"alianza_tallan":
			gain({"suministros": 2})
			repair_ship(1, "La alianza Tallan ofrece abrigo.")
		"festival_ofrendas":
			gain({"spondylus": 2})
			reputation += 3
			add_log("Participas en el festival de ofrendas.")
		"madera_carcomida":
			if resources["madera"] >= 2:
				resources["madera"] -= 2
				repair_ship(1, "Cambias madera carcomida a tiempo.")
			else:
				damage_ship(3, "La madera carcomida cede en alta mar.")
		"vela_desgarrada":
			if resources["algodon"] > 0:
				resources["algodon"] -= 1
				add_log("Remiendas la vela con algodon.")
			else:
				progress = max(0, progress - 1)
		"cuerda_rota":
			if resources["herramientas"] > 0:
				resources["herramientas"] -= 1
				add_log("Aseguras la carga con una herramienta.")
			else:
				resources["spondylus"] = max(0, resources["spondylus"] - 2)
				reputation -= 1
				add_log("Parte de la carga cae al mar.")
		"grieta_casco":
			if resources["madera"] >= 3:
				resources["madera"] -= 3
				repair_ship(2, "Sellas la grieta del casco.")
			else:
				damage_ship(4, "La grieta toma agua.")
		"mastil_doblado":
			if resources["fibra"] >= 2 and crew["carpintero"]:
				resources["fibra"] -= 2
				add_log("El carpintero restaura el mastil.")
			else:
				progress = max(0, progress - 1)
				add_log("El mastil doblado retrasa la expedicion.")
		"balsa_sobrecargada":
			if resources["suministros"] >= 2:
				resources["suministros"] -= 2
			else:
				resources["spondylus"] = max(0, resources["spondylus"] - 1)
			add_log("Aligeras la balsa para evitar el naufragio.")
		"timon_atascado":
			progress = max(0, progress - 1)
			add_log("El timon atascado reduce el control.")
		"bendicion_umina":
			if improvements["altar"]:
				repair_ship(3, "Umina protege la balsa.")
				reputation += 1
			else:
				add_log("La bendicion no despierta sin altar.")
		"vision_chaman":
			if resources["spondylus"] > 0:
				resources["spondylus"] -= 1
				progress += 2
				reputation += 1
			add_log("La vision del chaman marca el camino.")
		"concha_sagrada":
			gain({"spondylus": 3})
			add_log("Encuentras una concha sagrada.")
		"llamado_espiritual":
			repair_ship(2, "El llamado espiritual fortalece a la tripulacion.")
		"ofrenda_abismo":
			if resources["spondylus"] >= 2:
				resources["spondylus"] -= 2
				repair_ship(4, "La ofrenda al abismo salva la balsa.")
		"canto_ancestros":
			progress += 1
			if turn in [5, 7, 9]:
				reputation += 2
			add_log("El canto de los ancestros acompana la ruta.")
		"diosa_viento_sur":
			progress += 2
			add_log("La diosa del viento sur impulsa la vela.")
	_emit_all()


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
