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

const EXPLOSION = preload("res://source/misc/Explosion.tscn")
const TEXT = preload("res://source/misc/FloatingText.tscn")

var motion = Vector2.ZERO

func _process(delta):
	if length > 0:
		motion = direction * length
		length *= 0.9
	
	if position.x < 0 or position.x > 320:
		direction *= -1
	if position.y < 0 or position.y > 180:
		direction *= -1
	
	if hp <= 0:
		var e = EXPLOSION.instance()
		e.position = position
		e.emitting = true
		get_parent().add_child(e)
		
		queue_free()
		
	if (TXTDamage.is_visible()):
		move_txt(delta)
		
	motion = move_and_slide(motion)


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
	
	motion = move_and_slide(motion)
	get_node("ProgressBar").value = hp * 20


func _on_Hitbox_area_entered(area):
	if area.is_in_group("Stick"):
		#var txt = TEXT.instance()
		#txt.position = position
		#get_parent().add_child(txt)
		
		direction = -(area.position - position).normalized()
		length = 150
		get_node("AnimationPlayer").play("Hit")
		
		deal_damage(area.damage)
		#area.queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		get_node("AnimationPlayer").play("Bounce")
