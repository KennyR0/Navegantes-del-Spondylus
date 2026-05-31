extends Node

const CATEGORY_COLORS := {
	"clima": Color("#2f6f95"),
	"fauna": Color("#2ebf7a"),
	"cultura": Color("#c4712a"),
	"astillero": Color("#6b3a2a"),
	"sagrada": Color("#2ebfa5"),
}

var cards: Array = []


func _ready() -> void:
	cards = _create_cards()


func build_deck() -> Array:
	if cards.is_empty():
		cards = _create_cards()
	var deck: Array = cards.duplicate(true)
	deck.shuffle()
	return deck


func draw_cards(deck: Array, amount: int, active_event: Dictionary = {}) -> Array:
	var drawn: Array = []
	var compatible_target := int(ceil(float(amount) * 0.7)) if not active_event.is_empty() else 0
	while drawn.size() < amount:
		if deck.is_empty():
			deck.append_array(build_deck())
		var pool := deck
		if drawn.size() < compatible_target:
			var compatible_pool := _filter_event_compatible(deck, active_event)
			if not compatible_pool.is_empty():
				pool = compatible_pool
		var card := draw_weighted_card(pool)
		drawn.append(card)
		deck.erase(card)
	return drawn


func draw_weighted_card(pool: Array) -> Dictionary:
	if pool.is_empty():
		return {}
	var total_weight := 0
	for card in pool:
		total_weight += int(card.get("peso", 5))
	var roll := randf() * float(total_weight)
	var cumulative := 0
	for card in pool:
		cumulative += int(card.get("peso", 5))
		if roll <= float(cumulative):
			return card
	return pool[-1]


func get_card(card_id: String) -> Dictionary:
	for card in cards:
		if card["id"] == card_id:
			return card
	return {}


func get_category_color(category: String) -> Color:
	return CATEGORY_COLORS.get(category, Color("#f5f0e8"))


func card_resolves_event(card: Dictionary, active_event: Dictionary) -> bool:
	if active_event.is_empty() or card.is_empty():
		return false
	var needed: Array = active_event.get("evento_compatible", [])
	for tag in card.get("evento_compatible", []):
		if needed.has(tag):
			return true
	return false


func _filter_event_compatible(pool: Array, active_event: Dictionary) -> Array:
	var compatible: Array = []
	for card in pool:
		if card_resolves_event(card, active_event):
			compatible.append(card)
	return compatible


func _card(id: String, title: String, category: String, text: String, peso: int, compatible: Array[String]) -> Dictionary:
	return {
		"id": id,
		"title": title,
		"category": category,
		"text": text,
		"peso": peso,
		"evento_compatible": compatible,
	}


func _create_cards() -> Array:
	return [
		_card("tormenta_norte", "Tormenta del Norte", "clima", "-3 balsa. Si tienes navegante, reduce el golpe.", 3, ["resistencia", "navegacion"]),
		_card("corriente_contraria", "Corriente Contraria", "clima", "Pierdes velocidad; puedes compensar con suministros.", 6, ["resistencia", "navegacion"]),
		_card("vientos_favorables", "Vientos Favorables", "clima", "+2 progreso.", 3, ["navegacion"]),
		_card("niebla_espesa", "Niebla Espesa", "clima", "Riesgo de arrecife y perdida de rumbo.", 6, ["navegacion", "espiritualidad"]),
		_card("marea_roja", "Marea Roja", "clima", "La pesca falla y se consumen reservas.", 10, ["pesca"]),
		_card("calma_chicha", "Calma Chicha", "clima", "No hay viento; se aprovecha para reparar si hay artesanos.", 10, ["resistencia"]),
		_card("aguacero_torrencial", "Aguacero Torrencial", "clima", "+1 suministro, -2 balsa.", 6, ["resistencia", "pesca"]),
		_card("tromba_marina", "Tromba Marina", "clima", "Amenaza grave. El navegante estelar puede evitarla.", 3, ["navegacion", "resistencia"]),
		_card("viento_huracanado", "Viento Huracanado", "clima", "-2 balsa, +3 progreso.", 3, ["navegacion", "resistencia"]),
		_card("amanecer_sereno", "Amanecer Sereno", "clima", "+1 suministro, +1 progreso.", 6, ["navegacion", "espiritualidad"]),
		_card("banco_peces", "Banco de Peces", "fauna", "Oportunidad de pescar.", 10, ["pesca"]),
		_card("ballena_jorobada", "Ballena Jorobada", "fauna", "La tripulacion se anima: +1 suministro.", 10, ["liderazgo", "pesca"]),
		_card("banco_tiburones", "Banco de Tiburones", "fauna", "No se puede pescar y se pierden reservas.", 10, ["pesca", "navegacion"]),
		_card("tortuga_marina", "Tortuga Marina", "fauna", "Buen augurio: +1 balsa.", 10, ["espiritualidad", "resistencia"]),
		_card("pulpo_gigante", "Pulpo Gigante", "fauna", "Timones enredados; usa herramienta o pierde progreso.", 6, ["navegacion", "resistencia"]),
		_card("cardumen_sardinas", "Cardumen de Sardinas", "fauna", "Comida abundante; mejora con redes.", 10, ["pesca"]),
		_card("medusas_paso", "Medusas en el Paso", "fauna", "La pesca falla y la tripulacion pierde suministros.", 10, ["pesca", "resistencia"]),
		_card("delfines_guia", "Delfines Guia", "fauna", "+1 progreso y +1 reputacion.", 3, ["navegacion", "espiritualidad"]),
		_card("puerto_huancavilca", "Puerto Huancavilca", "cultura", "Comercio aliado: +3 Spondylus, -1 progreso.", 6, ["comercio", "liderazgo"]),
		_card("comerciantes_chimu", "Comerciantes Chimu", "cultura", "Intercambia Spondylus por suministros.", 10, ["comercio"]),
		_card("pueblo_valdivia", "Pueblo Valdivia Ancestral", "cultura", "Ofrenda: -1 Spondylus, +2 reputacion.", 6, ["liderazgo", "espiritualidad"]),
		_card("piratas_pacifico", "Piratas del Pacifico", "cultura", "Negocia con Spondylus o fuerza la huida.", 6, ["comercio", "liderazgo", "resistencia"]),
		_card("mercado_flotante", "Mercado Flotante", "cultura", "Compra reparaciones portatiles con Spondylus.", 10, ["comercio", "resistencia"]),
		_card("mensajero_tumbes", "Mensajero de Tumbes", "cultura", "Noticias del norte: +1 progreso.", 10, ["navegacion", "liderazgo"]),
		_card("alianza_tallan", "Alianza Tallan", "cultura", "+2 suministros y +1 balsa.", 3, ["comercio", "liderazgo"]),
		_card("festival_ofrendas", "Festival de Ofrendas", "cultura", "+2 Spondylus y +3 reputacion.", 1, ["liderazgo", "comercio", "espiritualidad"]),
		_card("madera_carcomida", "Madera Carcomida", "astillero", "Repara con madera o sufre dano.", 10, ["resistencia"]),
		_card("vela_desgarrada", "Vela Desgarrada", "astillero", "Usa algodon o pierdes progreso.", 10, ["navegacion", "resistencia"]),
		_card("cuerda_rota", "Cuerda Rota", "astillero", "La carga se suelta: riesgo de perder Spondylus.", 10, ["resistencia"]),
		_card("grieta_casco", "Grieta en el Casco", "astillero", "Reparacion urgente con madera.", 6, ["resistencia"]),
		_card("mastil_doblado", "Mastil Doblado", "astillero", "Necesita cana y carpintero para restaurar.", 6, ["navegacion", "resistencia"]),
		_card("balsa_sobrecargada", "Balsa Sobrecargada", "astillero", "Sacrifica suministros o Spondylus.", 10, ["resistencia", "liderazgo"]),
		_card("timon_atascado", "Timon Atascado", "astillero", "Pierdes control: -1 progreso.", 10, ["navegacion"]),
		_card("bendicion_umina", "Bendicion de Umina", "sagrada", "Cancela dano si construiste altar.", 1, ["espiritualidad", "resistencia"]),
		_card("vision_chaman", "Vision del Chaman", "sagrada", "Ofrenda para ganar rumbo: +2 progreso.", 3, ["espiritualidad", "navegacion"]),
		_card("concha_sagrada", "Concha Sagrada Encontrada", "sagrada", "+3 Spondylus.", 3, ["espiritualidad", "comercio"]),
		_card("llamado_espiritual", "Llamado Espiritual", "sagrada", "+2 balsa.", 6, ["espiritualidad", "resistencia"]),
		_card("ofrenda_abismo", "Ofrenda al Abismo", "sagrada", "Sacrifica Spondylus para salvar la balsa.", 3, ["espiritualidad", "resistencia"]),
		_card("canto_ancestros", "Canto de los Ancestros", "sagrada", "+1 progreso y +2 reputacion en turnos criticos.", 1, ["espiritualidad", "liderazgo"]),
		_card("diosa_viento_sur", "Diosa del Viento Sur", "sagrada", "+2 progreso.", 1, ["espiritualidad", "navegacion"]),
	]
