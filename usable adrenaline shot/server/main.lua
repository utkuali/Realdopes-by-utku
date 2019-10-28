ESX.RegisterUsableItem('adrenalin', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('adrenalin', 1) -- item name and how much player uses when one usage
	TriggerClientEvent('esx_optionalneeds:onAdrenalin', source)
end)