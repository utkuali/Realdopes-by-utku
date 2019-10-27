local ESX = nil

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

RegisterServerEvent("utku_realdopes:üretim")
AddEventHandler("utku_realdopes:üretim", function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)


    local currentOpium = xPlayer.getInventoryItem("opium")["count"]
    local currentAcetone = xPlayer.getInventoryItem("acetone")["count"]
    local currentLithium = xPlayer.getInventoryItem("lithium")["count"]

    if currentOpium >= 40 then
         if currentAcetone >= 5 then
            if currentLithium >= 5 then
                xPlayer.removeInventoryItem("opium", 40)
                xPlayer.removeInventoryItem("acetone", 5)
                xPlayer.removeInventoryItem("lithium", 5)

                    TriggerClientEvent("esx:showNotification", _source, ("Üretim başladı."))
                    TriggerClientEvent("utku_realdopes:üretimBaşla", _source)
                else
                    TriggerClientEvent("esx:showNotification", _source, "Yeteri kadar malzemen yok.")
                end
            else
                TriggerClientEvent("esx:showNotification", _source, "Yeteri kadar malzemen yok.")
            end
        else
            TriggerClientEvent("esx:showNotification", _source, "Yeteri kadar malzemen yok.")
        end
end)

RegisterServerEvent('utku_realdopes:finish')
AddEventHandler('utku_realdopes:finish', function(qualtiy)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local rnd = math.random(-5, 5)
	xPlayer.addInventoryItem('epinefrin', math.floor(qualtiy * 3 / 2) + rnd)
end)

RegisterServerEvent('utku_realdopes:patla')
AddEventHandler('utku_realdopes:patla', function(posx, posy, posz)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('utku_realdopes:patlamaBaşla', xPlayers[i],posx, posy, posz)
	end
end)