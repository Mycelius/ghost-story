extends Node

const AVAILABLE_LANGUAGES = ['fr', 'en']
const CONFIG_FILE_PATH = "res://global/config.json"

var language = 'fr'
var params = {}


func _ready():
	loadConfig()
	applyConfig()
	
func applyConfig():
	TranslationServer.set_locale(language)

func loadConfig():
	var save_file = File.new()
	if(!save_file.file_exists(CONFIG_FILE_PATH)):
		return
	
	save_file.open(CONFIG_FILE_PATH, File.READ)
	var data = {}
	data = parse_json(save_file.get_as_text())
	
	language = data["language"]
	
	
func saveConfig():
	params = {
		language = language
	}
	
	var save_file = File.new()
	save_file.open(CONFIG_FILE_PATH, File.WRITE)
	save_file.store_line(to_json(params))
	save_file.close()