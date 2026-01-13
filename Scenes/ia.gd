extends Node3D

var joueur
var speed=0.5
var fall_acceleration=75
var target_velocity=Vector3.ZERO
var anim
var jump_impulse = 20
var a=0
var attente=0.0
var idle=true
var porte=false
var cote=false
var serrure
var fin=true
var route=[Vector3(2.233,1.247,5.308),
			Vector3(-8.885,1.247,4.263),
			Vector3(-12.398,1.247,-1.971),
			Vector3(-8.26,1.247,-3.136),
			Vector3(1.984,1.247,-3.136),
			Vector3(4.783,1.247,2.24),
			]
var numero=0
var attaque=false
var detail
var fonctionPorte=false
var fonctionEscalier=false
var debut=false
var mort=false
@onready var navigation_agent_3d: NavigationAgent3D=$NavigationAgent3D

func _ready():
	joueur=Global.joueur
	anim=$jump_walk_idle/AnimationPlayer
	attente=true
	
func animationWalk():
	$testWalkIdle/AnimationPlayer.play("Walk")
	if not $AudioStreamPlayer3D.playing:
		$AudioStreamPlayer3D.play()
	
func animationIdle():
	$testWalkIdle/AnimationPlayer.play("Idle")
	
func _process(delta):
	if(!mort):
		var rayon=$RayCast3D
		var positionJoueur=joueur.get_node("XROrigin3D").global_position
		rayon.target_position=positionJoueur-rayon.global_position
		rayon.target_position=rayon.to_local(positionJoueur)
		var faceCamera=$Camera
		$Timer.one_shot=true
		if($TimerPorte.is_stopped()):
			fin=true
		if(fonctionEscalier):
			escalier(detail)
		if(fonctionPorte):
			portes(detail)
		if(attaque):
			var tab=$Area3D.get_overlapping_bodies()
			for i in range(len(tab)):
				if(tab[i].name=="Player"):
					mort=true
					Global.mort.play("Mort")
					Global.cube.visible=true
					await get_tree().create_timer(3.0).timeout
					get_tree().change_scene_to_file("res://Scenes/Menu_principal_3D.tscn")
		if(faceCamera.is_position_in_frustum(positionJoueur)):
			if(rayon.is_colliding()):
				if(rayon.get_collider().name=="Player" || rayon.get_collider().name=="PlayerBody"):
					navigation_agent_3d.set_target_position(positionJoueur)
					idle=false
					if(!attaque):
						attaque=true
						numero-=1
		elif(Global.porteSousSol.ouverte):
			navigation_agent_3d.set_target_position(Vector3(8.043,-0.745,1.136))
		elif((navigation_agent_3d.is_navigation_finished() || navigation_agent_3d.target_position==Vector3.ZERO) && attente && debut):
			$Timer.start(2.0)
			idle=true
			attente=false
			attaque=false
		elif((navigation_agent_3d.is_navigation_finished() || navigation_agent_3d.target_position==Vector3.ZERO) && $Timer.is_stopped() && debut):
			navigation_agent_3d.set_target_position(route[numero])
			if(numero!=len(route)-1):
				numero+=1
			else:
				numero=0
			idle=false
			attente=true
			attaque=false
		if(idle):
			animationIdle()
		else:
			var destination=navigation_agent_3d.get_next_path_position()
			var local_destination=destination-global_position
			var direction=local_destination
			direction=direction.normalized()
			var devant=global_transform.basis.z
			var angle=acos(clamp(devant.dot(direction),-1.0,1.0))
			var cross=devant.cross(direction)
			angle*=sign(cross.y)
			var angleMax=deg_to_rad(90)*delta
			rotate_y(clamp(angle,-angleMax,angleMax))
			target_velocity.x = direction.x * speed
			target_velocity.z = direction.z * speed
			look_at(destination,Vector3.UP)
			rotation.x=0.0
			rotation.y+=deg_to_rad(180)
			animationWalk()
			direction.y=0.0
			global_position+=direction*speed*delta

func escalier(details):
	var start=true
	if(idle==false):
		$Timer.start(2.0)
		start=false
	idle=true
	if(idle && $Timer.is_stopped() && start):
		var start_position=details["owner"].get_global_start_position()
		var end_position=details["owner"].get_global_end_position()
		var da=global_position.distance_to(start_position)
		var db=global_position.distance_to(end_position)
		if(da<db):
			global_position=details["owner"].get_global_end_position()
		else:
			global_position=start_position
		idle=false
		fonctionEscalier=false

func portes(details):
	if(fin):
		if(porte==false):
			var start=true
			if(idle==false):
				$Timer.start(2.0)
				start=false
				var start_position=details["owner"].get_global_start_position()
				var end_position=details["owner"].get_global_end_position()
				var da=global_position.distance_to(start_position)
				var db=global_position.distance_to(end_position)
				if(da<db):
					global_position.x=start_position.x
					global_position.z=start_position.z
				else:
					global_position.x=end_position.x
					global_position.z=end_position.z
			idle=true
			if(idle && $Timer.is_stopped() && start):
				var tab=$Area3D.get_overlapping_areas()
				for i in range(len(tab)):
					if(tab[i].name=="XRToolsSnapZone"):
						serrure=tab[i].get_parent()
						tab[i].get_parent().open_the_door()
				var start_position=details["owner"].get_global_start_position()
				var end_position=details["owner"].get_global_end_position()
				var da=global_position.distance_to(start_position)
				var db=global_position.distance_to(end_position)
				if(da<db):
					porte=true
					cote=true
				else:
					porte=true
					cote=false
				idle=false
		else:
			if(!cote):
				var start_position=details["owner"].get_global_start_position()
				var end_position=details["owner"].get_global_end_position()
				var da=global_position.distance_to(start_position)
				var db=global_position.distance_to(end_position)
				if(da<db):
					porte=false
					cote=true
					serrure.close_the_door()
			else:
				var start_position=details["owner"].get_global_start_position()
				var end_position=details["owner"].get_global_end_position()
				var da=global_position.distance_to(start_position)
				var db=global_position.distance_to(end_position)
				if(db<da):
					porte=false
					cote=true
					serrure.close_the_door()
			fin=false
			$TimerPorte.one_shot=true
			$TimerPorte.start(1.0)
			fonctionPorte=false

func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	if(details["owner"].name=="NavigationEscalier"):
		detail=details
		fonctionEscalier=true
	else:
		fonctionPorte=true
		detail=details
