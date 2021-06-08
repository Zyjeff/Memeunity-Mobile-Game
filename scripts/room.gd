extends Panel

var dankAmount = 5.00
var dankPerClick = 1
var hashRate = 0.00
var elecPrice = 0

onready var pcMenu = get_node("pcMenu")

func _ready():
	load_game()
	updateUI()
	$hashTimer.start()
	$elecTimer.start()
	$plusDank.text = ""
	$minusDank.text = ""

func updateUI():
	$DankLabel.text = str(dankAmount)#Display label in $DANK
	$MiningHashrateLabel.text = str(hashRate) + " Mh/s" #Display label in Mh/s
	pcMenu.callfunc()

func _on_Button_pressed(): #Mine Dank
	dankAmount += dankPerClick * hashRate
	updateUI()

func _on_hashTimer_timeout():
	if hashRate > 0:
		dankAmount += hashRate
		updateUI()
		$plusDank.text = "+" + str(hashRate)
		yield(get_tree().create_timer(0.2), "timeout")
		$plusDank.text = ""

func _on_elecTimer_timeout():
	if hashRate > 0:
		elecPrice = hashRate / 2
		dankAmount -= elecPrice
		updateUI()
		$minusDank.text = "-" + str(elecPrice)
		yield(get_tree().create_timer(0.2), "timeout")
		$minusDank.text = ""

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

func save_game():
	var save_dict = {}
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		save_dict[node.get_path()] = node.save()

	var save_file = File.new()
	save_file.open("res://save.json", File.WRITE)
	save_file.store_line(to_json(save_dict))
	save_file.close()

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

func _on_shopButton_pressed():
	$pcMenu.visible = true

func _on_shopButtonClose_pressed():
	$pcMenu.visible = false

func _on_Button2_pressed():
	save_game()
