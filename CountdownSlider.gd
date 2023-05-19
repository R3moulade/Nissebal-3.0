extends Node2D

func _on_ValueSlider_value_changed(value: float) -> void:
	$Top.value = value
	$Right.value = value
	$Bottom.value = value
	$Left.value = value
