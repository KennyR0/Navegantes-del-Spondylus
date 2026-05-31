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


func draw_cards(deck: Array, amount: int) -> Array:
	var drawn: Array = []
	while drawn.size() < amount:
		if deck.is_empty():
			deck.append_array(build_deck())
		drawn.append(deck.pop_front())
	return drawn


func get_card(card_id: String) -> Dictionary:
	for card in cards:
		if card["id"] == card_id:
			return card
	return {}


func get_category_color(category: String) -> Color:
	return CATEGORY_COLORS.get(category, Color("#f5f0e8"))


func _card(id: String, title: String, category: String, text: String) -> Dictionary:
	return {
		"id": id,
		"title": title,
		"category": category,
		"text": text,
	}


func _create_cards() -> Array:
	return [
		_card("tormenta_norte", "Tormenta del Norte", "clima", "-3 balsa. Si tienes navegante, reduce el golpe."),
		_card("corriente_contraria", "Corriente Contraria", "clima", "Pierdes velocidad; puedes compensar con suministros."),
		_card("vientos_favorables", "Vientos Favorables", "clima", "+2 progreso."),
		_card("niebla_espesa", "Niebla Espesa", "clima", "Riesgo de arrecife y perdida de rumbo."),
		_card("marea_roja", "Marea Roja", "clima", "La pesca falla y se consumen reservas."),
		_card("calma_chicha", "Calma Chicha", "clima", "No hay viento; se aprovecha para reparar si hay artesanos."),
		_card("aguacero_torrencial", "Aguacero Torrencial", "clima", "+1 suministro, -2 balsa."),
		_card("tromba_marina", "Tromba Marina", "clima", "Amenaza grave. El navegante estelar puede evitarla."),
		_card("viento_huracanado", "Viento Huracanado", "clima", "-2 balsa, +3 progreso."),
		_card("amanecer_sereno", "Amanecer Sereno", "clima", "+1 suministro, +1 progreso."),
		_card("banco_peces", "Banco de Peces", "fauna", "Oportunidad de pescar."),
		_card("ballena_jorobada", "Ballena Jorobada", "fauna", "La tripulacion se anima: +1 suministro."),
		_card("banco_tiburones", "Banco de Tiburones", "fauna", "No se puede pescar y se pierden reservas."),
		_card("tortuga_marina", "Tortuga Marina", "fauna", "Buen augurio: +1 balsa."),
		_card("pulpo_gigante", "Pulpo Gigante", "fauna", "Timones enredados; usa herramienta o pierde progreso."),
		_card("cardumen_sardinas", "Cardumen de Sardinas", "fauna", "Comida abundante; mejora con redes."),
		_card("medusas_paso", "Medusas en el Paso", "fauna", "La pesca falla y la tripulacion pierde suministros."),
		_card("delfines_guia", "Delfines Guia", "fauna", "+1 progreso y +1 reputacion."),
		_card("puerto_huancavilca", "Puerto Huancavilca", "cultura", "Comercio aliado: +3 Spondylus, -1 progreso."),
		_card("comerciantes_chimu", "Comerciantes Chimu", "cultura", "Intercambia Spondylus por suministros."),
		_card("pueblo_valdivia", "Pueblo Valdivia Ancestral", "cultura", "Ofrenda: -1 Spondylus, +2 reputacion."),
		_card("piratas_pacifico", "Piratas del Pacifico", "cultura", "Negocia con Spondylus o fuerza la huida."),
		_card("mercado_flotante", "Mercado Flotante", "cultura", "Compra reparaciones portatiles con Spondylus."),
		_card("mensajero_tumbes", "Mensajero de Tumbes", "cultura", "Noticias del norte: +1 progreso."),
		_card("alianza_tallan", "Alianza Tallan", "cultura", "+2 suministros y +1 balsa."),
		_card("festival_ofrendas", "Festival de Ofrendas", "cultura", "+2 Spondylus y +3 reputacion."),
		_card("madera_carcomida", "Madera Carcomida", "astillero", "Repara con madera o sufre dano."),
		_card("vela_desgarrada", "Vela Desgarrada", "astillero", "Usa algodon o pierdes progreso."),
		_card("cuerda_rota", "Cuerda Rota", "astillero", "La carga se suelta: riesgo de perder Spondylus."),
		_card("grieta_casco", "Grieta en el Casco", "astillero", "Reparacion urgente con madera."),
		_card("mastil_doblado", "Mastil Doblado", "astillero", "Necesita cana y carpintero para restaurar."),
		_card("balsa_sobrecargada", "Balsa Sobrecargada", "astillero", "Sacrifica suministros o Spondylus."),
		_card("timon_atascado", "Timon Atascado", "astillero", "Pierdes control: -1 progreso."),
		_card("bendicion_umina", "Bendicion de Umina", "sagrada", "Cancela dano si construiste altar."),
		_card("vision_chaman", "Vision del Chaman", "sagrada", "Ofrenda para ganar rumbo: +2 progreso."),
		_card("concha_sagrada", "Concha Sagrada Encontrada", "sagrada", "+3 Spondylus."),
		_card("llamado_espiritual", "Llamado Espiritual", "sagrada", "+2 balsa."),
		_card("ofrenda_abismo", "Ofrenda al Abismo", "sagrada", "Sacrifica Spondylus para salvar la balsa."),
		_card("canto_ancestros", "Canto de los Ancestros", "sagrada", "+1 progreso y +2 reputacion en turnos criticos."),
		_card("diosa_viento_sur", "Diosa del Viento Sur", "sagrada", "+2 progreso."),
	]
