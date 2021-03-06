extends Node

const PORT = 8543
const MAX_PLAYERS = 20

const mainMenuPath:String = "res://Screens/Menu/Menu.tscn"

onready var localIP = getLocalIP()

var info = {
	
	"name":"EpicDude54",
	
}


var players:Dictionary = {}
var pingQueue:Array = []
var pinging:bool = false

signal playerJoined(id)
signal playerLeft()
signal recievedPlayerInfo()
signal gotPing(id)

signal pong()

var upnp:UPNP = UPNP.new()
var upnpActive = false

var clock:float = 0
var inGame:bool = false

remotesync func setClock(time:float):
	
	clock = time
	
	pass
	
func measurePing(id:int):
	
	var start:int = OS.get_system_time_msecs()
	rpc_id(id, "ping")
	yield(self, "pong")
	var end = OS.get_system_time_msecs()
	
	return end-start

	pass
	
remotesync func ping():
	rpc("pong")
	pass
	
master func pong():
	emit_signal("pong")
	pass
	
func _ready():
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	get_tree().connect("connected_to_server", self, "connected_to_server")
	get_tree().connect("connection_failed", self, "connection_failed")
	get_tree().connect("server_disconnected", self, "server_disconnected")
	get_tree().connect("network_peer_connected", self, "peer_connected")
	get_tree().connect("network_peer_disconnected", self, "peer_disconnected")

func _process(delta):
	
	if not pinging and not pingQueue.empty():
		yield(getAveragePing(pingQueue[0]), "completed")
		pingQueue.remove(0)
	
	if inGame:
	
		clock += delta
	
	pass
	
var pings:int = 100

func getAveragePing(id:int):
	
	pinging = true
	
	var total:int
	
	for i in range(pings):
		total += yield(measurePing(id), "completed")
	
	players[id].ping = ceil((float(total)/pings)/2)
	yield(syncClock(id), "completed")
	rpc("gotPing", id, players[id].ping)
	pinging = false

func hostGame():
	
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(PORT, MAX_PLAYERS)
	if not err == OK:
		return err
	get_tree().network_peer = peer
	players[1] = info
	players[1].ping = 0
	inGame = true
	return OK
	
	pass
	
func peer_connected(id:int):
	
	if is_network_master():
	
		rpc_id(id, "sendPlayerInfo", players)
	
remote func sendPlayerInfo( p:Dictionary):
	
	players = p
	emit_signal("recievedPlayerInfo")
	rpc("addPlayer", get_tree().get_network_unique_id(), info)
	
remotesync func addPlayer(id:int, i:Dictionary):
	
	players[id] = i
	emit_signal("playerJoined", id)
	
	if is_network_master():
		pingQueue.append(id)
	
	pass
	
func syncClock(id:int):
	rpc_id(id, "setClock", clock+((float(players[id].ping))/1000))
	yield(get_tree().create_timer(0.2), "timeout")
	rpc_id(id, "setClock", clock+((float(players[id].ping))/1000))
	yield(get_tree().create_timer(0.2), "timeout")
	rpc_id(id, "setClock", clock+((float(players[id].ping))/1000))
	pass
	
remotesync func gotPing(id:int, ping:float):
	
	players[id].ping = ping
	emit_signal("gotPing", id)
	
	pass
	
remotesync func removePlayer(id:int):
	players.erase(id)
	emit_signal("playerLeft", id)
	
func peer_disconnected(id:int):
	removePlayer(id)
	pass
	

func joinGame(address:String):
	
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_client(address, PORT)
	if not err == OK:
		return err
	get_tree().network_peer = peer
	inGame = true

	return OK
	
	
func connected_to_server():
	
	pass
	
func connection_failed():
	
	pass
	
func server_disconnected():
	
	cleanup()
	Manager.changeScene(mainMenuPath)
	
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
	inGame = true
	clock = 0
	
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
	upnp.clear_devices()
	upnp = UPNP.new()
	upnpActive = false
	
func getUPNPAddress():
	return upnp.query_external_address()
	pass
