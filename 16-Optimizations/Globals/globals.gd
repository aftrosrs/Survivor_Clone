extends Node


var movement_speed: float = 40.0
var enemy_movement_speed: float = 20.0
var speed: float = 100.0
var level: int = 1
var hp: float = 50.0
var max_hp: float = 80.0
var enemy_hp: float = 10.0
var cant_die: float = 9999
var attack_hp: int = 1
var attack_damage: float = 5.0
var attack_size: float = 1.0
var knockback_amount: float = 100.0
var knockback_recovery: float = 3.5
var knockback: Vector2 = Vector2.ZERO
var last_movement: Vector2 = Vector2.ZERO
var target: Vector2 = Vector2.ZERO
var angle: Vector2 = Vector2.ZERO
var angle_less: Vector2 = Vector2.ZERO
var angle_more: Vector2 = Vector2.ZERO
