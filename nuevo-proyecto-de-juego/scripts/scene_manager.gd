extends Node

const START_SCENE := "res://scenes/StartScene.tscn"
const SHIPYARD_SCENE := "res://scenes/ShipyardScene.tscn"
const VOYAGE_SCENE := "res://scenes/VoyageScene.tscn"
const RESULTS_SCENE := "res://scenes/ResultsScene.tscn"


func change_to(path: String) -> void:
	var tree := get_tree()
	if tree == null:
		return
	tree.call_deferred("change_scene_to_file", path)


func go_to_start() -> void:
	change_to(START_SCENE)


func go_to_shipyard() -> void:
	change_to(SHIPYARD_SCENE)


func go_to_voyage() -> void:
	change_to(VOYAGE_SCENE)


func go_to_results() -> void:
	change_to(RESULTS_SCENE)
