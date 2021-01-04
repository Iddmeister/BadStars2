extends Node

const PORT = 8543
const MAX_PLAYERS = 6

const mainMenuPath:String = "res://Screens/Menu/Menu.tscn"

onready var localIP = getLocalIP()

var info = {
	
	"name":"EpicDude54",
	
}


var players:Dictionary = {}

signal playerJoined(id)
signal playerLeft()
signal recievedPlayerInfo()

var upnp:UPNP = UPNP.new()
var upnpActive = false

func _ready():
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	get_tree().connect("connected_to_server", self, "connected_to_server")
	get_tree().connect("connection_failed", self, "connection_failed")
	get_tree().connect("server_disconnected", self, "server_disconnected")
	get_tree().connect("network_peer_connected", self, "peer_connected")
	get_tree().connect("network_peer_disconnected", self, "peer_disconnected")
	

func hostGame():
	
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(PORT, MAX_PLAYERS)
	if not err == OK:
		return err
	get_tree().network_peer = peer
	players[1] = info
	return OK
	
	pass
	
func peer_connected(id:int):
	
	players[id] = {}
	yield(self, "playerJoined")
	rpc_id(id, "setPlayerInfo", players)
	
	pass
	
	
func peer_disconnected(id:int):
	
	pass
	

func joinGame(address:String):
	
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_client(address, PORT)
	if not err == OK:
		return err
	get_tree().network_peer = peer
	

	return OK
	
	
func connected_to_server():
	
	rpc("playerConnected", get_tree().get_network_unique_id(), info)
	
	pass
	
func connection_failed():
	
	pass
	
func server_disconnected():
	
	cleanup()
	Manager.changeScene(mainMenuPath)
	
	pass
	
remotesync func setPlayerInfo(i:Dictionary):
	
	players = i
	emit_signal("recievedPlayerInfo")
	
	pass
	
remotesync func playerConnected(id:int, info:Dictionary):
	players[id] = info
	emit_signal("playerJoined", id)
	pass
	
remotesync func playerDisconnected(id:int):
	players.erase(id)
	emit_signal("playerLeft", id)
	pass

func leaveGame():
	
	get_tree().paused = true
	get_tree().network_peer.close_connection()
	cleanup()
	Manager.changeScene(mainMenuPath)
	get_tree().paused = false
	
	pass
	
remotesync func kick(message:String=""):
	leaveGame()
	pass
	
func cleanup():
	
	players = {}
	info.character = "none"
	
	pass
	
func getLocalIP():
	
	var ip = ""
	
	for i in IP.get_local_addresses():
		
		if i .begins_with("192"):
			ip = i
			break
	
	return ip
	
	pass
	
func isMultiplayer():
	return players.size() > 1
	
func activateUPNP():
	
	upnp.discover()
	
	var error = upnp.add_port_mapping(PORT)
	
	if error == OK:
		upnpActive = true
	
	return error
	
	pass
	
func deactivateUPNP():
	
	upnp.delete_port_mapping(PORT)
	upnp = UPNP.new()
	upnpActive = false
	
func getUPNPAddress():
	return upnp.query_external_address()
	pass
