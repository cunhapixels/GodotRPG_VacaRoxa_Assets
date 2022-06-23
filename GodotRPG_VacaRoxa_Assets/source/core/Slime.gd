extends KinematicBody2D


var direction = Vector2.ZERO
var length = 0
var hp = 100 setget set_hp, get_hp


onready var HealthBarFG = $HealthBarFG
onready var HealthBarBG = $HealthBarBG
onready var TXTDamage = $TXTDamage


func set_hp(value):
	hp += value

func get_hp():
	return hp

func _ready():
	HealthBarFG.value = hp;


func _process(delta):
	if length > 0:
		position += direction * length
		length -= delta * 1
	
	if hp <= 0:
		queue_free()
		
	if (TXTDamage.is_visible()):
		move_txt(delta)
	

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Stick"):
		deal_damage(20)
		
		direction = -(area.position - position).normalized()
		length = .2

		area.queue_free()


func deal_damage(damage) -> void:
	set_hp(-damage)
	HealthBarFG.value = get_hp();
	show_hide_txt(true)
	yield(get_tree().create_timer(0.35), "timeout")
	show_hide_txt(false)
	HealthBarBG.value = get_hp();


func show_hide_txt(visible) -> void:
	TXTDamage.set_position(Vector2(-4,-14))
	TXTDamage.visible = visible


func move_txt(delta) -> void:
	TXTDamage.set_position(
		lerp(TXTDamage.get_position(), 
		Vector2(rand_range(-10, 10), rand_range(10, 20)), 
		delta))
