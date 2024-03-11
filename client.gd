extends Control

const SERVER_1 = "127.0.0.1"
const PORT = 8382

func _ready() -> void:
	# Create fast withdraw client
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(SERVER_1, PORT)
	multiplayer.multiplayer_peer = peer

	print("Client started. Connected to ID: ", peer.get_unique_id())
	print("Is it a server?: ", multiplayer.is_server())


func _on_button_test_pressed() -> void:
	# Send fast withdraw request only to server
	$"/root/Net".request_fast_withdraw.rpc_id(1, 21.0)
