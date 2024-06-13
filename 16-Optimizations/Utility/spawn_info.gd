extends Resource

class_name spawn_info

@export var time_start:int #When enemy spawns
@export var time_end:int #When enemy spawns

@export var enemy:Resource #What enemy is meant to spawn
@export var enemy_num:int # number of enemies that spawn

#Delays
@export var enemy_spawn_delay:float
@export var enemy_movement_speed = 20.0
@export var spawn_delay_counter = 0 
