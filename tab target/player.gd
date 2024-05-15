extends CharacterBody2D
var potential_targets = []
var current_target = null
var current_target_index = -1

func _input(event):
	# Check if the Tab key is pressed
	if event.is_action_pressed("tab"):
		print("Tab key pressed")
		# Check if there are potential targets
		if potential_targets.size() > 0:
			# Increment the current target index
			current_target_index += 1
			# Wrap around to the beginning if the index exceeds the number of potential targets
			if current_target_index >= potential_targets.size():
				current_target_index = 0
			# Get the next target
			var new_target = potential_targets[current_target_index]
			if new_target:
				print("New target: ", new_target.name)
				# Toggle visibility of highlight sprite for previous target
				if current_target and current_target.has_node("highlight"):
					current_target.get_node("highlight").visible = false
				# Set current target
				current_target = new_target
				# Toggle visibility of highlight sprite for new target
				if current_target.has_node("highlight"):
					current_target.get_node("highlight").visible = true
			else:
				print("No target found")
				# If no target found, hide highlight sprite for previous target
				if current_target and current_target.has_node("highlight"):
					current_target.get_node("highlight").visible = false
				current_target = null
		else:
			print("No potential targets available")


func _on_area_entered(body):
	# Check if the entered body is an enemy
	if body.has_method("is_enemy") and body.is_enemy():
		print("Enemy entered area: ", body.name)
		# Add the enemy to the list of potential targets
		potential_targets.append(body)
		print("Potential targets: ", potential_targets)


func _on_area_exited(body):
	# Check if the exited body is in the potential targets list
	if body in potential_targets:
		print("Enemy exited area: ", body.name)
		# Remove the enemy from the list of potential targets
		potential_targets.erase(body)

func find_nearest_enemy():
	var nearest_enemy = null
	var nearest_distance = 1000000  # Set to a large value, adjust as needed

	# Loop through the potential targets
	for target in potential_targets:
		# Calculate the distance between the player and the target
		var distance = $Area2D.global_position.distance_to(target.global_position)
		print("Distance to ", target.name, ": ", distance)
		
		# Check if the distance is shorter than the current nearest distance
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = target

	if nearest_enemy:
		print("Nearest enemy found: ", nearest_enemy.name)
	else:
		print("No nearest enemy found")

	return nearest_enemy


func _ready():
	# Connect the input event for the Tab key
	set_process_input(true)
	# Connect the body_entered and body_exited signals of the Area2D
	$Area2D.body_entered.connect(_on_area_entered)
	$Area2D.body_exited.connect(_on_area_exited)





# Variable for movement speed
var speed = 200
#movement
func _physics_process(delta):
	# Get input from keyboard
	var input_vector = Vector2()

	# Left and Right Movement
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1

	# Up and Down Movement
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1

	# Normalize input to prevent diagonal movement from being faster
	input_vector = input_vector.normalized()

	# Move the player
	velocity = input_vector * speed
	move_and_slide()
