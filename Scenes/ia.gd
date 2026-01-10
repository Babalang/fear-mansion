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
	#print(navigation_agent_3d.target_position)
	
#func animationJump():
	#anim.play("Take 001",0.0)
	
func animationWalk():
	#anim.play("Take 001")
	#if(anim.current_animation_position>3.2 || anim.current_animation_position<2.17):
		#anim.seek(2.18,true)
	$testWalkIdle/AnimationPlayer.play("Walk")
	if not $AudioStreamPlayer3D.playing:
		$AudioStreamPlayer3D.play()
	#print("arrete")
	#var i=1+1
	
func animationIdle():
	#anim.play("Take 001")
	#if(anim.current_animation_position>11.79 || anim.current_animation_position<3.5):
		#anim.seek(3.51,true)
	#print("IDLEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
	#var i=1+1
	$testWalkIdle/AnimationPlayer.play("Idle")
	
#func _on_area_3d

#ROUTE : 
	#2.233 1.247 5.308
	#-8.885 1.247 4.263
	#-12.398 1.247 -1.971
	#-8.26 1.247 -3.136
	#1.984 1.247 -3.136
	#4.783 1.247 2.24
	
func _process(delta):
	#Test de la vue du joueur en gros bah si l'ia voit le joueur quoi ca te va comme ca ?
	if(!mort):
		var rayon=$RayCast3D
		#var positionJoueur=joueur.get_node("sphere").global_position
		#print(joueur)
		var positionJoueur=joueur.get_node("XROrigin3D").global_position
		#var positionJoueur=Vector3.ZERO
		rayon.target_position=positionJoueur-rayon.global_position
		rayon.target_position=rayon.to_local(positionJoueur)
		var faceCamera=$Camera
		#print("test")
		#if(rayon.is_colliding()):
			#print(rayon.get_collider())
		#print(positionJoueur)
		#print(joueur.get_node("XROrigin3D").get_node("Sphere").global_position)
		##print(rayon.target_position)
		#print(rayon.is_colliding())
		#print(faceCamera.is_position_in_frustum(positionJoueur))
		##print(joueur.get_node("Sphere").global_position)
		#print(rayon.get_collider())
		#print($Timer.time_left)
		$Timer.one_shot=true
		if($TimerPorte.is_stopped()):
			fin=true
		if(fonctionEscalier):
			escalier(detail)
		if(fonctionPorte):
			portes(detail)
		#print(navigation_agent_3d.target_position)
		#print($Area3D.get_overlapping_areas())
		
		#print(global_position)
		#var fps=Engine.get_frames_per_second()
		#print("FPS : "+str(fps))
		#if($Timer.time_left>0.0):$Timer.start(2.0)
		#navigation_agent_3d.set_target_position(Vector3(-5.869,-0.938,-0.802))
		if(attaque):
			var tab=$Area3D.get_overlapping_bodies()
			print(tab)
			for i in range(len(tab)):
				if(tab[i].name=="Player"):
					mort=true
					Global.mort.play("Mort")
					Global.cube.visible=true
					print("MORT")
		if(faceCamera.is_position_in_frustum(positionJoueur)):
			if(rayon.is_colliding()):
				if(rayon.get_collider().name=="Player" || rayon.get_collider().name=="PlayerBody"):
					navigation_agent_3d.set_target_position(positionJoueur)
					idle=false
					
					#print("PLAYER AAAAAAAAAAAAAAAAAAAAAAAAAAAH")
					#print(positionJoueur)
					#print(navigation_agent_3d.target_position)
					if(!attaque):
						attaque=true
						numero-=1
		elif(Global.porteSousSol.ouverte):
			print("OUAIIIIIIIIIIIIIS ELLE EST OUVERTE !!")
			navigation_agent_3d.set_target_position(Vector3(8.043,-0.745,1.136))
		elif((navigation_agent_3d.is_navigation_finished() || navigation_agent_3d.target_position==Vector3.ZERO) && attente && debut):
			$Timer.start(2.0)
			idle=true
			attente=false
			attaque=false
		elif((navigation_agent_3d.is_navigation_finished() || navigation_agent_3d.target_position==Vector3.ZERO) && $Timer.is_stopped() && debut):
			#print("iiiiiiiiiiiiiiiii")
			#var random_position:=Vector3.ZERO
			#random_position.x=randf_range(-5.0,5.0)
			#random_position.z=randf_range(-5.0,5.0)
			#navigation_agent_3d.set_target_position(random_position)
			#navigation_agent_3d.set_target_position(Vector3(-11.08,2.094,5.464))
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
			#global_position.x+=0.001
		else:
			var destination=navigation_agent_3d.get_next_path_position()
			var local_destination=destination-global_position
			#var direction=positionJoueur-position
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
			#velocity=target_velocity
			look_at(destination,Vector3.UP)
			rotation.x=0.0
			#rotate_y(deg_to_rad(180))
			rotation.y+=deg_to_rad(180)
			animationWalk()
			#if(!is_on_floor()):
				#velocity.y=-1.0*speed
			direction.y=0.0
			#rotation.x-=90
			global_position+=direction*speed*delta
		
#func _physics_process(delta):
	#on fait bouger l'ia suivant où elle doit aller
	
		#move_and_slide()


func escalier(details):
	var start=true
	if(idle==false):
		$Timer.start(2.0)
		start=false
	idle=true
	#print($Timer.time_left)
	if(idle && $Timer.is_stopped() && start):
		print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
		print(details)
		var start_position=details["owner"].get_global_start_position()
		var end_position=details["owner"].get_global_end_position()
		var da=global_position.distance_to(start_position)
		var db=global_position.distance_to(end_position)
		if(da<db):
			#print("iiiiiii")
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
			#print($Timer.time_left)
			if(idle && $Timer.is_stopped() && start):
				var tab=$Area3D.get_overlapping_areas()
				print(tab)
				for i in range(len(tab)):
					print("aaaaaaa")
					if(tab[i].name=="XRToolsSnapZone"):
						print(tab[i].get_parent())
						serrure=tab[i].get_parent()
						tab[i].get_parent().open_the_door()
				var start_position=details["owner"].get_global_start_position()
				var end_position=details["owner"].get_global_end_position()
				var da=global_position.distance_to(start_position)
				var db=global_position.distance_to(end_position)
				if(da<db):
					#print("iiiiiii")
					porte=true
					cote=true
					#global_position=details["owner"].get_global_end_position()
				else:
					#global_position=start_position
					#print("aaaaaaaa")
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
		print("escalier")
		detail=details
		fonctionEscalier=true
	else:
		print("porte")
		fonctionPorte=true
		detail=details
		
		#navigation_agent_3d.target_position=details["owner"].end_position
