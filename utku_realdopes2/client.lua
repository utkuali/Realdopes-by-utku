--[[
Script by utku#9999, this is the second part of Real Dopes script.
With this you can produce Adrenaline Shot which which you can produce required meterial from first part (utku_realdopes).
You are free to edit and alter this code anyway you want but if you want to share or sell you must ask for my permission.
This code is free to use.
Bu scrtip utku#9999 tarafından yapılmıştır. Real Dopes scriptinin ilk bölümüdür.
Bu script ile Adrenalin Şırıngasını üretebiliyorsunuz. Gerekli olan madde bir önceki partda (utku_realdopes2) elde ediliniyor.
Kodu istediğiniz gibi değiştirebilir ve üzerinde oynayabilirsiniz. Ama eğer kodu satmak veya dağıtmak istiyorsanız önce benden izin almanız gerekiyor.
Bu code tamamen ücretsizdir.
--]]


local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

local basla2 = false -- Check if production started // Üretim başlama kontrolü


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


Citizen.CreateThread(function() -- Draw marker when near and check if started // Marker çizme ve aktive etme
    Citizen.Wait(100)
	while true do
		local sleepThread = 200
		local ped = PlayerPedId()

    	for locationIndex = 1, #Config.AdrenalinLocation do
        	local locationPos = Config.AdrenalinLocation[locationIndex]

        	local ped = PlayerPedId()
        	local pedCoords = GetEntityCoords(ped)
        	local dstCheck = GetDistanceBetweenCoords(pedCoords, locationPos, true)
            	if dstCheck <= 6.0 then -- Distane when draw // Çizim için mesafe
                	sleepThread = 5
					DrawMarker(20, 2433.97, 4968.94, 42.35, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.45, 0.45, 0.45, 0.0, 0.0, 133.0, 0.0012, false, false, 2, 0, nil, nil, false)
					ESX.Game.Utils.DrawText3D({x = 2433.97, y = 4968.94, z = 42.35}, 'Adrenalin İğnesi üretmek için "E" ye bas.', 1.0)
					if dstCheck <= 1.5 then -- Distance to press // Tuşa basmak için mesafe
                        if IsControlJustReleased(0, 38) and basla2 == false then -- Check if already started and pressed "E" // Zaten başladı mı ve "E" ye bastımı kontrolü
							TriggerServerEvent("utku_realdopes2:üretim")
						end
					end
				end
        	Citizen.Wait(sleepThread)
	 	end
	end
end)

Citizen.CreateThread(function() -- Check if still near location // Hala lokasyonun yakınında mı kontrolü
    Citizen.Wait(100)
	while true do
		local sleepThread = 100
    	for locationIndex = 1, #Config.AdrenalinLocation do
        	local locationPos = Config.AdrenalinLocation[locationIndex]

        	local ped = PlayerPedId()
        	local pedCoords = GetEntityCoords(ped)
        	local dstCheck = GetDistanceBetweenCoords(pedCoords, locationPos, true)
            	if dstCheck >= 6.0 and basla2 == true then  -- Distance // Uzaklık
					sleepThread = 5
					TriggerEvent("utku_realdopes2:aniDurdur") -- Activate if player leaves the area / Oyuncu alandan çıkarsa aktive olur
				end
        	Citizen.Wait(sleepThread)
	 	end
	end
end)

RegisterNetEvent("utku_realdopes2:aniDurdur") -- Stopping process if player leaves the area // Oyuncu alandan çıkmış ise üretimi durdurur
AddEventHandler("utku_realdopes2:aniDurdur", function()
	basla2 = false
	ESX.ShowNotification("~r~Üretim durdu, alandan uzaklaştın.")
end)

RegisterNetEvent("utku_realdopes2:üretimBaşla")  -- Production // Üretim
AddEventHandler("utku_realdopes2:üretimBaşla", function()
	basla2 = true
	ESX.ShowNotification("~g~Üretim başladı.")
	ESX.ShowNotification("~g~Üretim: 0% Şırıngalar hazırlanıyor.")
	Citizen.Wait(5000)
	if basla2 == true then  -- Each of this checks if started true in case player has leaved the area // Her yüzdeklikte başlama true mu diye kontrol ediyor ki oyuncu lokasyonun yakınında mı hala
		ESX.ShowNotification("~g~Üretim: 10% Epinerfin tablası temizleniyor.")
		Citizen.Wait(5000)
		if basla2 == true then
			ESX.ShowNotification("~g~Üretim: 20% Sodyum nitrat dinlendiriliyor.")
			Citizen.Wait(5000)
			if basla2 == true then
				ESX.ShowNotification("~g~Üretim: 30% Epinerfin tablaya yerleştiriliyor.")
				Citizen.Wait(5000)
				if basla2 == true then
					ESX.ShowNotification("~g~Üretim: 40% Epinerfin ile sodyum nitrat yavaş yavaş karıştırılıyor.")
					Citizen.Wait(5000)
					if basla2 == true then
						ESX.ShowNotification("~g~Üretim: 50% Karıştırma işlemi devam ediyor.")
						Citizen.Wait(5000)
						if basla2 == true then
							ESX.ShowNotification("~g~Üretim: 60% Karıştırma işlemi devam ediyor.")
							Citizen.Wait(5000)
							if basla2 == true then
								ESX.ShowNotification("~g~Üretim: 70% Karıştırma tamamlandı, basınç ve sıcaklık ekleniyor.")
								Citizen.Wait(5000)
								if basla2 == true then
									ESX.ShowNotification("~g~Üretim: 80% Dinlendiriliyor.")
									Citizen.Wait(5000)
									if basla2 == true then
										ESX.ShowNotification("~g~Üretim: 90% Adrenalin şırıngalara dolduruluyor.")
										Citizen.Wait(5000)
										if basla2 == true then
											ESX.ShowNotification("~g~Üretim: 100% Şırıngalar hazırlandı.")
											Citizen.Wait(500)
											ESX.ShowNotification("~g~Üretim tamamlandı.")
											basla2 = false
											TriggerServerEvent("utku_realdopes2:bitti")
										else
											TriggerEvent("utku_realdopes2:aniDurdur") -- Each of these are for if player leaves the area // Eğer oyuncu alan terk ederse aktive olacaklar
										end
									else
										TriggerEvent("utku_realdopes2:aniDurdur")
									end
								else
									TriggerEvent("utku_realdopes2:aniDurdur")
								end
							else
								TriggerEvent("utku_realdopes2:aniDurdur")
							end
						else
							TriggerEvent("utku_realdopes2:aniDurdur")
						end
					else
						TriggerEvent("utku_realdopes2:aniDurdur")
					end
				else
					TriggerEvent("utku_realdopes2:aniDurdur")
				end
			else
				TriggerEvent("utku_realdopes2:aniDurdur")
			end
		else
		    TriggerEvent("utku_realdopes2:aniDurdur")
		end
	else
		TriggerEvent("utku_realdopes2:aniDurdur")
	end
end)