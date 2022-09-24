extends State

export var group_path : NodePath
onready var collider_group = get_node(group_path)

export var squish_speed : float

var sprite
var og_offset
var unsquish_timer = 0.0

func _start_check(_delta):
	var squish_ray = character.raycasts_node.get_node("Squish")
	var is_squish = false
	if squish_ray.is_colliding():
		var collider = squish_ray.get_collider()
		var i = squish_ray.get_collider_shape()
		var hit_node = collider.shape_owner_get_owner(i)
		if !is_instance_valid(hit_node) || !hit_node.one_way_collision:
			is_squish = true
	return is_squish

func _start(delta):
	character.velocity.x = 0
	
	sprite = character.get_node("AnimatedSprite")
	sprite.offset.y = 0
	var collider = collider_group.get_node(collider_group.colliders[0])
	og_offset = collider.position.y

func _update(delta):
	var squish_ray = character.raycasts_node.get_node("Squish")
	var collider = collider_group.get_node(collider_group.colliders[0])
	var collider2 = collider_group.get_node(collider_group.colliders[1])
	var texture = sprite.frames.get_frame(sprite.animation, sprite.frame)
	
	if squish_ray.is_colliding():
		unsquish_timer = 0.5
	
	if unsquish_timer > 0:
		sprite.scale.y = lerp(sprite.scale.y, 0.1, delta * squish_speed)

		collider_group.get_node(collider_group.colliders[1]).disabled = true
		collider.scale.y = lerp(collider.scale.y, 0.025, delta * squish_speed)
		collider2.scale.y = lerp(collider2.scale.y, 0.025, delta * squish_speed)
		collider.position.y = lerp(collider.position.y, 0, delta * squish_speed)
	else:
		sprite.scale.y = lerp(sprite.scale.y, 1, delta * squish_speed)
		
		collider_group.get_node(collider_group.colliders[1]).disabled = false
		collider.scale.y = lerp(collider.scale.y, 1, delta * squish_speed)
		collider2.scale.y = lerp(collider2.scale.y, 1, delta * squish_speed)
		collider.position.y = lerp(collider.position.y, og_offset, delta * squish_speed)
		
		character.velocity.y = -50

func _stop(_delta):
	sprite.scale.y = 1
	var collider = collider_group.get_node(collider_group.colliders[0])
	collider.scale.y = 1
	collider.position.y = og_offset

func _stop_check(_delta):
	var squish_ray = character.raycasts_node.get_node("Squish")
	return sprite.scale.y > 0.95 && !squish_ray.is_colliding()

func _general_update(delta):
	if unsquish_timer > 0:
		unsquish_timer -= delta
		if unsquish_timer <= 0:
			unsquish_timer = 0
