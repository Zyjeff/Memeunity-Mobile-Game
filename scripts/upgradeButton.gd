extends Panel

onready var main = get_node("/root/MainPanel")
onready var pcMenu = get_node("/root/MainPanel/pcMenu")

var cost = 0
var plusHash = 0
var multiHash = 1
var stats = {"cost": 0, "plushHash": 0, "multiHash": 1}

func _ready():
	match self.name:
		"firstPC":
			stats = pcMenu.firstPC
		"secondPC":
			stats = pcMenu.secondPC


func progressUpdate():
	_ready()
	if main.dankAmount > 0:
		var percent =  main.dankAmount / stats.cost * 100
		$hashButton/upgradeBar.value = percent
		$hashButton/hashUpgradePrice.text = "costs " + str(stats.cost) + " $DANK"

func _on_hashButton_pressed():
	_ready()
	if cost <= main.dankAmount:
		main.dankAmount -= stats.cost
		main.hashRate += stats.plushHash
		main.hashRate *= stats.multiHash
		pcMenu.firstPC.cost *= 2
		main.updateUI()
	else:
		$hashButton/hashUpgradePrice.text = "Not enough $DANK"
		yield(get_tree().create_timer(1.75), "timeout")
		main.updateUI()
