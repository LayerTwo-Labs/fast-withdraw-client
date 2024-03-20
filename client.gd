extends Control

const SERVER_1 = "127.0.0.1"
const PORT = 8382

var invoice_address : String = ""

func _ready() -> void:
	# Create fast withdraw client
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(SERVER_1, PORT)
	multiplayer.multiplayer_peer = peer
	
	$"/root/Net".fast_withdraw_invoice.connect(_on_fast_withdraw_invoice)
	$"/root/Net".fast_withdraw_complete.connect(_on_fast_withdraw_complete)

	print("Client started. Peer ID: ", peer.get_unique_id())


func _on_button_test_pressed() -> void:
	# Send fast withdraw request only to server
	$"/root/Net".request_fast_withdraw.rpc_id(1, $SpinBoxAmount.value, $LineEditMainchainAddress.text)


func _on_button_test_complete_pressed() -> void:
	# Tell the server we paid
	var txid : String = $LineEditTXID.text
	$"/root/Net".invoice_paid.rpc_id(1, txid, $SpinBoxAmount.value, $LineEditMainchainAddress.text)


func _on_fast_withdraw_invoice(amount : float, destination: String) -> void:
	print("Received fast withdraw invoice!")
	print("Amount: ", amount)
	print("Destination: ", destination)
	
	var invoice_text = "Fast withdraw request received!\n"
	invoice_text += str("Send ", amount, " L2 coins to ", destination, "\n") 
	invoice_text += "Then enter the L2 txid and hit invoice paid"
	
	invoice_address = destination
	
	$LabelInvoice.text = invoice_text


func _on_fast_withdraw_complete(txid: String, amount : float, destination: String) -> void:
	print("Fast withdraw complete!")
	print("TxID: ", txid)
	print("Amount: ", amount)
	print("Destination: ", destination)
	
	$LabelComplete.text = str("Withdraw complete: ", txid)


func _on_button_copy_address_pressed() -> void:
	DisplayServer.clipboard_set(invoice_address)
	
