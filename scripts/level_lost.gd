extends ColorRect

signal LoseRetry()
signal MainMenu()

@onready var lose_retry_button = %LoseRetryButton
@onready var lose_main_menu_button = %LoseMainMenuButton



func _on_lose_retry_button_pressed():
	LoseRetry.emit()


func _on_lose_main_menu_button_pressed():
	MainMenu.emit()
