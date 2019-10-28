
--[[
Script by utku#9999, this is the first part of Real Dopes script.
With this you can produce Epinephrine metarial which can later used for producing adrenaline shot (utku_realdopes2).
You are free to edit and alter this code anyway you want but if you want to share or sell you must ask for my permission.
This code is free to use.
-------------------------------------------------------------------------------------------------------------------------
Bu scrtip utku#9999 tarafından yapılmıştır. Real Dopes scriptinin ilk bölümüdür.
Bu script ile Efinerfin maddesini üretebiliyorsunuz. Bu madde daha sonra adrenalin iğnesi (utku_realdopes2) yapımında kullanılıyor.
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
-- Don't edit this if you don't know what you're doing. // Ne yaptığınızı bilmiyorsanız bunlarla oynamayın. --
local basla = false -- Control of wether production has started or not. // Üretim başladı mı başlamadı mı kontrolü.

local ilerleme = 0 -- Progression // Kaydedilen ilerleme.
local dur = false -- Stop check // Durma kontrolü.
local secim = 0 -- Selection check // Seçin kontrolü.
local kalite = 0 -- Quality of product which late transformed to number of given items. // Maddenin kalites, sonradan oyuncuya verilecek item sayısınıa dönüştürülür.

ESX = nil

local LastPlayerPed

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
RegisterNetEvent('utku_realdopes:aniDurdur')
AddEventHandler('utku_realdopes:aniDurdur', function()
	basla = false
	DisplayHelpText("~r~Üretim durdu, alandan uzaklaştın.")
end)

RegisterNetEvent('utku_realdopes:dur')
AddEventHandler('utku_realdopes:dur', function()
	basla = false
	DisplayHelpText("~r~Üretim durdu")
	FreezeEntityPosition(LastPlayerPed, false)
end)
RegisterNetEvent('utku_realdopes:üretimBaşla')
AddEventHandler('utku_realdopes:üretimBaşla', function()
	DisplayHelpText("~g~Üretim başlatıldı alanı terk etme.")
	basla = true
	ESX.ShowNotification("~r~Epinefrin üretimi başlatıldı.")
end)
RegisterNetEvent('utku_realdopes:patlamaBaşla')
AddEventHandler('utku_realdopes:patlamaBaşla', function(posx, posy, posz)
	AddExplosion(posx, posy, posz + 2,23, 20.0, true, false, 1.0, true)
	ilerleme = 0
	kalite = 0
	dur = false
end)
RegisterNetEvent('utku_realdopes:uyuştu')
AddEventHandler('utku_realdopes:uyuştu', function()
	SetTimecycleModifier("drug_drive_blend01")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)

	Citizen.Wait(300000)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@CASUAL@D", true)
	ClearTimecycleModifier()
	SetPedMotionBlur(GetPlayerPed(-1), false)
end)

Citizen.CreateThread(function() -- To check if you are close enough to marker so that marker can be drawn // Markera yakınlığınızı ölçüp ona göre spawnlıyor.
    Citizen.Wait(100)
	while true do
		local sleepThread = 100
    	for locationIndex = 1, #Config.ProductionLocations do
        	local locationPos = Config.ProductionLocations[locationIndex]

        	local ped = PlayerPedId()
        	local pedCoords = GetEntityCoords(ped)
        	local dstCheck = GetDistanceBetweenCoords(pedCoords, locationPos, true)
            	if dstCheck <= 6.0 then  -- distance // uzaklık
                	sleepThread = 5
					DrawMarker(20, 1443.61, 6332.17, 24.20, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.45, 0.45, 0.45, 133.0, 0.0, 0.0, 0.0012, false, false, 2, 0, nil, nil, false)
					ESX.Game.Utils.DrawText3D({x = 1443.61, y = 6332.17, z = 24.20}, 'Epinefrin üretmek için "E" ye bas.', 1.0)
					if dstCheck <= 1.5 then  -- start distance // başlama uzaklığı
                        if IsControlJustReleased(0, 38) and basla == false then
							TriggerServerEvent("utku_realdopes:üretim")
						end
					end
				end
        	Citizen.Wait(sleepThread)
	 	end
	end
end)

Citizen.CreateThread(function() -- To check if you remain in the area // Üretim boyunca hala alanda mısınız kontrolü
    Citizen.Wait(100)
	while true do
		local sleepThread = 200
    	for locationIndex = 1, #Config.ProductionLocations do
        	local locationPos = Config.ProductionLocations[locationIndex]

        	local ped = PlayerPedId()
        	local pedCoords = GetEntityCoords(ped)
        	local dstCheck = GetDistanceBetweenCoords(pedCoords, locationPos, true)
            	if dstCheck > 6.0 and basla == true then  -- area distance // alanın uzaklığı
					sleepThread = 5
					TriggerEvent("utku_realdopes:aniDurdur")
				end
        	Citizen.Wait(sleepThread)
	 	end
	end
end)

Citizen.CreateThread(function()  -- Production // Üretim
	while true do
		Citizen.Wait(10)

		playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1))

		if basla == true and IsPlayerDead() == false then
			if ilerleme < 96 then
				Citizen.Wait(6000)
				if not dur then
					ilerleme = ilerleme +  1  -- Progress add on start and after every event // Başlangıçta ve her olaydan sonra ilerlemeye eklenecek değer.
					ESX.ShowNotification('~r~Üretim: ~g~~h~' .. ilerleme .. '%')
					Citizen.Wait(6000)
				end
				--
				--   EVENT 1 // OLAY 1
				--
				if ilerleme > 20 and ilerleme < 25 then
					dur = true
					if secim == 0 then
						ESX.ShowNotification('~o~Damıtma unitesinde sorun var, ne yapacaksın?')	
						ESX.ShowNotification('~o~1. İnternetten yardım al.')
						ESX.ShowNotification('~o~2. Hiçbir şey. ')
						ESX.ShowNotification('~o~3. Yenisini kullan.')
						ESX.ShowNotification('~c~Sayı tuşlarıyla seçim yapınız.')
					end
					if secim == 1 then
						ESX.ShowNotification('~r~İşe yaramışa benziyor, akıntı durdu.')
						kalite = kalite - 1
						dur = false
					end
					if secim == 2 then
						ESX.ShowNotification('~r~Damıtma unitesi patladı, sıçtın...')
						kalite = 0
						basla = false
						ApplyDamageToPed(GetPlayerPed(-1), 110, false) -- Player dmg in case explosion is not enough. // Patlama yetmez diye oyuncuya hasar.
						TriggerServerEvent('utku_realdopes:patla', pos.x, pos.y, pos.z) -- Explosion // Patlama
					end
					if secim == 3 then
						ESX.ShowNotification('~r~Yeni bir damıtma unitesi kullandın.')
						dur = false
						kalite = kalite + 4
					end
				end
				--
				--  EVENT 2 // OLAY 2
				--
				if ilerleme > 26 and ilerleme < 31 then
					dur = true
					if secim == 0 then
						ESX.ShowNotification('~o~Yere aseton şişesi düşürdün ve kırıldı, ne yapacaksın?')
						ESX.ShowNotification('~o~1. Kokuyu  gazete ile savurmaya çalış.')
						ESX.ShowNotification('~o~2. Hiçbir şey.')
						ESX.ShowNotification('~o~3. Gaz maskesi tak.')
						ESX.ShowNotification('~c~Sayı tuşlarıyla seçim yapınız.')
					end
					if secim == 1 then
						ESX.ShowNotification('~r~Kokuyu gazete ile dağıtmaya çalıştın.')
						kalite = kalite - 1
						dur = false
					end
					if secim == 2 then
						ESX.ShowNotification('~r~Çok fazla aseton soluduğun için kafan güzelleşti.')
						kalite = kalite + 1
						dur = false
						TriggerEvent('utku_realdopes:uyuştu')

					end
					if secim == 3 then
						ESX.ShowNotification('~r~Gaz maskesi taktın.')
						SetPedPropIndex(playerPed, 1, 26, 7, true)  -- Gas mask put on // Gaz maskesi takma
						dur = false
					end
				end
				--
				--   EVENT 3 // OLAY 3
				--
				if ilerleme > 33 and ilerleme < 38 then
					dur = true
					if secim == 0 then
						ESX.ShowNotification('~o~Haşhaş çok hızlı katılaşıyor, ne yapacaksın? ')	
						ESX.ShowNotification('~o~1. Basıncı arttır.')
						ESX.ShowNotification('~o~2. Sıcaklığı arttır.')
						ESX.ShowNotification('~o~3. Basıncı azalt.')
						ESX.ShowNotification('~c~Sayı tuşlarıyla seçim yapınız.')
					end
					if secim == 1 then
						ESX.ShowNotification('~rBasıncı arttırdın ve haşhaşlar garip bir hal aldı, tekrar basıncı azalttın, şimdilik sorun yok.')
						kalite = kalite - 1
						dur = false
					end
					if secim == 2 then
						ESX.ShowNotification('~r~Sıcaklığı yükseltmek işe yaradı gibi...')
						kalite = kalite + 4
						dur = false
					end
					if secim == 3 then
						ESX.ShowNotification('~r~Basıncı düşürmek haşhaşları daha beter hale soktu.')
						dur = false
						kalite = kalite -3
					end
				end
				--
				--   EVENT 4 // OLAY 4
				--
				if ilerleme > 40 and ilerleme < 45 then
					dur = true
					if secim == 0 then
						ESX.ShowNotification('~o~Yanlışlıkla çok fazla aseton kullandın, ne yapacaksın?')	
						ESX.ShowNotification('~o~1. Hiçbir şey.')
						ESX.ShowNotification('~o~2. Şırınga ile birazcık çekmeye çalış.')
						ESX.ShowNotification('~o~3. Daha fazla lityum ekleyerek dengelemeye çalış.')
						ESX.ShowNotification('~c~Sayı tuşlarıyla seçim yapınız.')
					end
					if secim == 1 then
						ESX.ShowNotification('~r~Karışım çok fazla aseton kokmaya başladı.')
						kalite = kalite - 2
						dur = false
					end
					if secim == 2 then
						ESX.ShowNotification('~r~İşe yaradı gibi ama hala aseton normalden fazla.')
						dur = false
						kalite = kalite - 1
					end
					if secim == 3 then
						ESX.ShowNotification('~r~Her iki kimyasalı da dengelemeyi başardın.')
						dur = false
						kalite = kalite + 3
					end
				end
				--
				--   EVENT 5 // OLAY 5
				--
				if ilerleme > 47 and ilerleme < 53 then
					dur = true
					if secim == 0 then
						ESX.ShowNotification('~o~Biraz su renklendirici buldun, ne yapacaksın?')	
						ESX.ShowNotification('~o~1. Karışıma ekle.')
						ESX.ShowNotification('~o~2. Kenara koy.')
						ESX.ShowNotification('~o~3. İç.')
						ESX.ShowNotification('~c~Sayı tuşlarıyla seçim yapınız.')
					end
					if secim == 1 then
						ESX.ShowNotification('~r~Karışıma azıcık su renklendirici ekledin.')
						kalite = kalite -1
						dur = false
					end
					if secim == 2 then
						ESX.ShowNotification('~r~Mantıklı, karışımı bozabilir.')
						kalite = kalite + 2
						dur = false
					end
					if secim == 3 then
						ESX.ShowNotification('~r~Biraz garip hissediyorsun ama sorun yok.')
						TaskPlayAnim()
						dur = false
					end
				end
				--
				--   EVENT 6 // OLAY 6
				--
				if ilerleme > 55 and ilerleme < 60 then
					dur = true
					if secim == 0 then
						ESX.ShowNotification('~o~Filtre tıkandı, ne yapacaksın?')	
						ESX.ShowNotification('~o~1. Sıkıştırılmış hava ile filtreyi temizle')
						ESX.ShowNotification('~o~2. Yenisini tak')
						ESX.ShowNotification('~o~3. Diş fırçası ile temizle')
						ESX.ShowNotification('~c~Sayı tuşlarıyla seçim yapınız.')
					end
					if secim == 1 then
						ESX.ShowNotification('~r~Sıkıştırılmış hava her yere karışımdan saçtı.')
						kalite = kalite - 2
						dur = false
					end
					if secim == 2 then
						ESX.ShowNotification('~r~Yenisini takmak en iyi seçenek gibi duruyor...')
						dur = false
						kalite = kalite + 3
					end
					if secim == 3 then
						ESX.ShowNotification('~r~Gerçekten işe yaradı ama hala birazcık kirli gibi.')
						dur = false
						kalite = kalite - 1
					end
				end
				--
				--   EVENT 7 (COPY) // OLAY 7 (KOPYA)
				--
				if ilerleme > 62 and ilerleme < 67 then
					dur = true
					if secim == 0 then
						ESX.ShowNotification('~o~Damıtma unitesinde sorun var, ne yapacaksın?')	
						ESX.ShowNotification('~o~1. İnternetten yardım al.')
						ESX.ShowNotification('~o~2. Hiçbir şey. ')
						ESX.ShowNotification('~o~3. Yenisini tak.')
						ESX.ShowNotification('~c~Sayı tuşlarıyla seçim yapınız.')
					end
					if secim == 1 then
						ESX.ShowNotification('~r~İşe yaramışa benziyor, akıntı durdu.')
						kalite = kalite - 1
						dur = false
					end
					if secim == 2 then
						ESX.ShowNotification('~r~Damıtma unitesi patladı, sıçtın...')
						TriggerServerEvent('utku_realdopes:patla', pos.x, pos.y, pos.z)
						kalite = 0
						basla = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('Üretim durdu')
					end
					if secim == 3 then
						ESX.ShowNotification('~r~Yeni bir damıtma unitesi kullandın.')
						dur = false
						kalite = kalite + 4
					end
				end
				--
				--   EVENT 8 (COPY) // OLAY 8 (KOPYA)
				--
				if ilerleme > 69 and ilerleme < 75 then
					dur = true
					if secim == 0 then
						ESX.ShowNotification('~o~Filtre tıkandı, ne yapacaksın?')	
						ESX.ShowNotification('~o~1. Sıkıştırılmış hava ile filtreyi temizle.')
						ESX.ShowNotification('~o~2. Yenisini tak.')
						ESX.ShowNotification('~o~3. Diş fırçası ile temizle.')
						ESX.ShowNotification('~c~Sayı tuşlarıyla seçim yapınız.')
					end
					if secim == 1 then
						ESX.ShowNotification('~r~Sıkıştırılmış hava her yere karışımdan saçtı.')
						kalite = kalite - 2
						dur = false
					end
					if secim == 2 then
						ESX.ShowNotification('~r~Yenisini takmak en iyi seçenek gibi duruyor...')
						dur = false
						kalite = kalite + 3
					end
					if secim == 3 then
						ESX.ShowNotification('~r~Gerçekten işe yaradı ama hala birazcık kirli gibi.')
						dur = false
						kalite = kalite - 1
					end
				end
				--
				--   EVENT 9 (COPY) // OLAY 9 (KOPYA)
				--
				if ilerleme > 77 and ilerleme < 83 then
					dur = true
					if secim == 0 then
						ESX.ShowNotification('~o~Yanlışlıkla çok fazla aseton kullandın, ne yapacaksın?')	
						ESX.ShowNotification('~o~1. Hiçbir şey.')
						ESX.ShowNotification('~o~2. Şırınga ile birazcık çekmeye çalış.')
						ESX.ShowNotification('~o~3. Daha fazla lityum ekleyerek dengelemeye çalış.')
						ESX.ShowNotification('~c~Sayı tuşlarıyla seçim yapınız.')
					end
					if secim == 1 then
						ESX.ShowNotification('~r~Karışım çok fazla aseton kokmaya başladı.')
						kalite = kalite - 3
						dur = false
					end
					if secim == 2 then
						ESX.ShowNotification('~r~İşe yaradı gibi ama hala aseton normalden fazla.')
						dur = false
						kalite = kalite - 1
					end
					if secim == 3 then
						ESX.ShowNotification('~r~Her iki kimyasalı da dengelemeyi başardın.')
						dur = false
						kalite = kalite + 3
					end
				end
				--
				--   EVENT 10 // OLAY 10
				--
				if ilerleme > 85 and ilerleme < 95 then
					dur = true
					if secim == 0 then
						ESX.ShowNotification("~o~Daha fazla epinefrin elde etmek için karışıma su eklemek ister misin?")
						ESX.ShowNotification('~o~1. EVET!')
						ESX.ShowNotification('~o~2. Hayır.')
						ESX.ShowNotification('~c~Sayı tuşlarıyla seçim yapınız.')
					end
					if secim == 1 then
						ESX.ShowNotification('~r~Biraz daha fazla epinefrin oldu.')
						kalite = kalite + 1
						dur = false
					end
					if secim == 2 then
						ESX.ShowNotification('~r~Kaliteden asla ödün vermiyorsun.')
						dur = false
						kalite = kalite + 2
					end
				end

				if dur == false and IsPlayerDead() == false then
						secim = 0
						kalite = kalite + 2
						ilerleme = ilerleme +  6 -- Progress add after each event // Her olay sonrasında ilerleme eklemesi
						ESX.ShowNotification('~r~Üretim: ~g~~h~' .. ilerleme .. '%')

				end
			else
				TriggerEvent('utku_realdopes:dur')
				ilerleme = 100
				ESX.ShowNotification('~r~Üretim: ~g~~h~' .. ilerleme .. '%')
				ESX.ShowNotification('~g~~h~Üretim tamamlandı.')
				Citizen.Wait(10)
				ilerleme = 0
				TriggerServerEvent('utku_realdopes:finish', kalite) -- Quality call // Kalite çağrısı
				kalite = 0
			end

		end
	end
	end)

    Citizen.CreateThread(function() -- Selection check // Seçim kontrolü
        while true do
            Citizen.Wait(10)
            if dur == true then
                if IsControlJustReleased(0, Keys['1']) then
                    secim = 1
                    ESX.ShowNotification('~g~1. seçeneği seçtin.')
                end
                if IsControlJustReleased(0, Keys['2']) then
                    secim = 2
                    ESX.ShowNotification('~g~2. seçeneği seçtin.')
                end
                if IsControlJustReleased(0, Keys['3']) then
                    secim = 3
                    ESX.ShowNotification('~g~3. seçeneği seçtin.')
                end
            end

        end

end)
