extends Panel

onready var main = get_node("/root/MainPanel")
onready var pc1 = get_node("MarginContainer/GridContainer/firstPC")
onready var pc2 = get_node("MarginContainer/GridContainer/secondPC")

#Array is cost - plusHash - multiHash
var stats = {
	"computer": {
		"firstPC": {
			"versionOne": {
				"id": 0,
				"cost": 5, 
				"plusHash": 1, 
				"multiHash": 1
			},
			"versionTwo": {
				"id": 0,
				"cost": 10, 
				"plusHash": 2, 
				"multiHash": 1
			}
		},
		"secondPC": {
			"versionOne": {
				"id": 1,
				"cost": 35, 
				"plusHash": 0, 
				"multiHash": 2
			},
			"versionTwo": {
				"id": 1,
				"cost": 45, 
				"plusHash": 1, 
				"multiHash": 1
			}
		}
	}
}

func callfunc():
	pc1.progressUpdate()
	pc2.progressUpdate()

func deleteOld(node:String):
	$MarginContainer/GridContainer/firstPC.visible = false
