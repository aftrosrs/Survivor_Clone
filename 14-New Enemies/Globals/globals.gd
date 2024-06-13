extends Node


var movement_speed := 40.0
var enemy_movement_speed := 20.0
var speed := 100.0
var level := 1.0
var hp := 50.0
var max_hp := 80.0
var enemy_hp := 10.0
var cant_die := 9999
var attack_hp := 1.0
var attack_damage := 5.0
var attack_size := 1.0
var knockback_amount := 100.0
var knockback_recovery := 3.5
var knockback := Vector2.ZERO
var last_movement := Vector2.ZERO
var target := Vector2.ZERO
var angle := Vector2.ZERO
var angle_less := Vector2.ZERO
var angle_more := Vector2.ZERO
