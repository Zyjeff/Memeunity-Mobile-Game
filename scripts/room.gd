extends Panel

var dankAmount = 5.00
var dankPerClick = 1
var hashRate = 1.00
var elecPrice = 0
var pcType = 0
var pcVersion = [0,0,0,0]
var stats = {}
var versionTypeString = ""

onready var pcMenu = get_node("pcMenu")
onready var upgrade = get_node("MarginContainer/GridContainer/firstPC")

#Call Update UI and load savegame
func _ready():
	updateUI()
	$hashTimer.start()
	$elecTimer.start()
	$plusDank.text = ""
	$minusDank.text = ""
	load_game()

#Update UI
func updateUI():
	$DankLabel.text = str(dankAmount)#Display label in $DANK
	$MiningHashrateLabel.text = str(hashRate) + " Mh/s" #Display label in Mh/s
	pcMenu.callfunc() #Update store values

#Mine by clicking
func _on_Button_pressed(): #Mine Dank
	dankAmount += dankPerClick * hashRate
	updateUI()

#1 second timer mines + update UI + display increment
func _on_hashTimer_timeout():
	callStats()
	hashRate = stats.plusHash
	dankAmount += hashRate
	updateUI()
	$plusDank.text = "+" + str(hashRate)
	yield(get_tree().create_timer(0.2), "timeout")
	$plusDank.text = ""

#2.1 second timer pays electricity + display decrement
func _on_elecTimer_timeout():
	if hashRate > 0:
		elecPrice = hashRate / 2
		dankAmount -= elecPrice
		updateUI()
		$minusDank.text = "-" + str(elecPrice)
		yield(get_tree().create_timer(0.2), "timeout")
		$minusDank.text = ""

#Save values
func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"dankAmount" : dankAmount,
		"hashRate" : hashRate,
		"firstPC" : pcMenu.firstPC,
		"secondPC" : pcMenu.secondPC
	}
	return save_dict

#Save the game
func save_game():
	var save_dict = {}
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		save_dict[node.get_path()] = node.save()

	var save_file = File.new()
	save_file.open("res://save.json", File.WRITE)
	save_file.store_line(to_json(save_dict))
	save_file.close()

#Loads game
func load_game():
	var save_file = File.new()
	if not save_file.file_exists("res://save.json"):
		return
	
	save_file.open("res://save.json", File.READ)
	var data = parse_json(save_file.get_as_text())
	
	for node_path in data.keys():
		var node = get_node(node_path)
		for attribute in data[node_path]:
			node.set(attribute, data[node_path][attribute])
		var nodeStats = pcMenu
		for attribute in data[node_path]:
			nodeStats.set(attribute, data[node_path][attribute])

#Opens shop
func _on_shopButton_pressed():
	$pcMenu.visible = true

#Closes shop
func _on_shopButtonClose_pressed():
	$pcMenu.visible = false

#Press to save game
func _on_Button2_pressed():
	save_game()

#Retrieves stats from current PC
func callStats():
	match pcType:
		0:
			determineVersion()
			stats = pcMenu.stats.computer.firstPC.get(versionTypeString)
		1:
			determineVersion()
			stats = pcMenu.stats.computer.secondPC.get(versionTypeString)

#Retrieves version of current pc
func determineVersion():
	match pcVersion[pcType]:
		0:
			versionTypeString = "versionOne"
		1:
			versionTypeString = "versionTwo"
