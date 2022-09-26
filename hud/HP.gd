extends Control


export var healthBlue : NodePath
export var healthYellow : NodePath
export var healthRed : NodePath
export var healthGone : NodePath

export var healthBlueTxt : NodePath
export var healthYellowTxt : NodePath
export var healthRedTxt : NodePath
export var healthGoneTxt : NodePath

# Called when the node enters the scene tree for the first time.
func _ready():	
	Globals.healthCount = 3
func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_L:
			Globals.healthCount -= 1
		if event.scancode == KEY_W:
			Globals.healthCount += 1			
func _process(delta):
	
	if Globals.healthCount >= 3:
		Globals.healthCount = 3
		
	if Globals.healthCount <= 0:
		Globals.healthCount = 0		
		
	if Globals.healthCount == 3:
		get_node(healthBlue).visible = true
		get_node(healthBlueTxt).visible = true	

		get_node(healthYellow).visible = false
		get_node(healthYellowTxt).visible = false	

		get_node(healthRed).visible = false
		get_node(healthRedTxt).visible = false	
		
		get_node(healthGone).visible = false
		get_node(healthGoneTxt).visible = false									
	elif Globals.healthCount == 2:
		get_node(healthBlue).visible = false
		get_node(healthBlueTxt).visible = false
		
		get_node(healthRed).visible = false
		get_node(healthRedTxt).visible = false			
		
		get_node(healthGone).visible = false
		get_node(healthGoneTxt).visible = false						
		
		get_node(healthYellow).visible = true
		get_node(healthYellowTxt).visible = true					
	elif Globals.healthCount == 1:
		get_node(healthYellow).visible = false
		get_node(healthYellowTxt).visible = false		

		get_node(healthBlue).visible = false
		get_node(healthBlueTxt).visible = false
		
		get_node(healthGone).visible = false
		get_node(healthGoneTxt).visible = false				
		
		get_node(healthRed).visible = true
		get_node(healthRedTxt).visible = true				
	elif Globals.healthCount == 0:
		get_node(healthYellow).visible = false
		get_node(healthYellowTxt).visible = false		

		get_node(healthBlue).visible = false
		get_node(healthBlueTxt).visible = false
		
		get_node(healthRed).visible = false
		get_node(healthRedTxt).visible = false

		get_node(healthGone).visible = true
		get_node(healthGoneTxt).visible = true			
						
	print(Globals.healthCount)	
	
