# HealthBar.gd
# This script controls the visual health bar display.
# It extends ProgressBar, which is a Godot UI element that shows a bar from 0% to 100%.

extends ProgressBar

# This function is called whenever the player's health changes.
# It takes two parameters: current health and maximum health.
# Example: update_health(75, 100) means 75/100 health (75% full)
func update_health(current: float, maximum: float) -> void:
	max_value = maximum  # Set the bar's maximum (e.g., 100)
	value = current      # Set the bar's current value (e.g., 75)
