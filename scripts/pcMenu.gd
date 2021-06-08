extends Panel

onready var main = get_node("/root/MainPanel")
onready var pc1 = get_node("MarginContainer/GridContainer/firstPC")
onready var pc2 = get_node("MarginContainer/GridContainer/secondPC")

#Array is cost - plusHash - multiHash
var firstPC = {"cost": 5, "plushHash": 1, "multiHash": 1}
var secondPC = {"cost": 35, "plushHash": 0, "multiHash": 2}

func callfunc():
	pc1.progressUpdate()
	pc2.progressUpdate()
