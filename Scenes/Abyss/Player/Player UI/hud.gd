class_name HUD
extends Control

@onready var energy_label: Label = %EnergyLabel
@onready var energy_bar: ColorRect = %EnergyBar


func set_energy(full: int, current: float):
	var percentage = current / full
	energy_bar.material.set_shader_parameter("progress", percentage)
	energy_label.text = "%s / %d" % [Helper.format_float(current), full]
