extends Panel

onready var main = get_node("/root/MainPanel")
onready var pcMenu = get_node("/root/MainPanel/pcMenu")

var plusHash = 0
var multiHash = 1
var stats = {}
var versionTypeNode = ""
var versionTypeString = ""

func _ready():
	callStats(self.name)

func _on_hashButton_pressed():
	_ready()
	if stats.cost <= main.dankAmount:
		if stats.id > main.pcType:
			pcMenu.deleteOld(versionTypeNode)
			main.pcType += 1
		main.pcVersion[main.pcType] += 1
		main.dankAmount -= stats.cost
		main.updateUI()
	else:
		$hashButton/hashUpgradePrice.text = "Not enough $DANK"
		yield(get_tree().create_timer(1.75), "timeout")
		main.updateUI()

func progressUpdate():
	callStats(self.name)
	if main.dankAmount > 0:
		var percent =  main.dankAmount / stats.cost * 100
		$hashButton/upgradeBar.value = percent
		$hashButton/hashUpgradePrice.text = "costs " + str(stats.cost) + " $DANK"

func callStats(node:String):
	match node:
		"firstPC":
			determineVersion(0)
			stats = pcMenu.stats.computer.firstPC.get(versionTypeString)
		"secondPC":
			determineVersion(1)
			#versionButtonString = "secondPC"
			stats = pcMenu.stats.computer.secondPC.get(versionTypeString)

func determineVersion(type:int):
	match main.pcVersion[type]:
		0:
			versionTypeString = "versionOne"
		1:
			versionTypeString = "versionTwo"
