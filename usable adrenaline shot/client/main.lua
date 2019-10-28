--Adrenalin
RegisterNetEvent("esx_optionalneeds:onAdrenalin")
AddEventHandler("esx_optionalneeds:onAdrenalin", function()

  local lib, anim = 'melee@small_wpn@streamed_core_fps', 'small_wpn_long_range_0'  -- usage animation (I fucked this up and don't bother to add working animation)
        local playerPed = PlayerPedId()
    	ESX.ShowNotification('Her şey artık daha net!') -- usage notification
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, 8.0, -1, 0, 0, false, false, false)
            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TriggerEvent('esx_optionalneeds:adrenalin') -- below effect
          end)
end)

-------------EFEKTLER---------------
local hizliKos = false -- hızlı koşma var // this is for fast run
local yavasKos = false -- yavaş koşma var // this is for slow run



Citizen.CreateThread(function()           -- yavaş koşma için call // check if slow run activated
    while true do
      Citizen.Wait(16)
      if yavasKos then
        SetPedMoveRateOverride(PlayerPedId(), 0.1) -- you can edit this ratio : values above 1.0 make charater move faster / values belowe 1.0 make charater slower / 1.0 is default speed - This makes characters movement faster, which means even your walking speed
      end
    end
  end)

Citizen.CreateThread(function()           -- hızlı koşma için call // chechk if fast run activated
    while true do
      Citizen.Wait(16)
      if hizliKos then
        SetPedMoveRateOverride(PlayerPedId(), 1.050) -- you can edit this ratio : values above 1.0 make charater move faster / values belowe 1.0 make charater slower / 1.0 is default speed - This makes characters movement faster, which means even your walking speed
      end
    end
  end)

--Agresif ve Sınırsız Stamina
RegisterNetEvent("esx_optionalneeds:adrenalin")
AddEventHandler("esx_optionalneeds:adrenalin", function()
    local count = 0

    Citizen.Wait(1000)
    SetPedMotionBlur(GetPlayerPed(-1), true) -- Adds very little blur effect
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetTimecycleModifier("underwater_deep")  -- Display filter to make it funnier and realistic
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.35)   -- This ratio is for sprinting speed not movement speed so it will only effective when your character sprints, max is 1.49 / aboe 1.49 won't effect speed
    hizliKos = true  -- activites fast movement (not sprinting speed but overall speed)

    DoScreenFadeIn(1000)
	repeat  -- Start of the cycle
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)   -- Shaking cam effect
    RestorePlayerStamina(PlayerId(), 1.0)   -- This is for resetting stamina
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
    Citizen.Wait(2000)
		count = count  + 1
	until count == 15  -- One cycle takes 10 seconds, if you put 15 in this value adrenaline effect will take 150 seconds
    hizliKos = false  -- deactivetes speed
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier() -- clears display filter
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0) -- sets sprint speed to defualt
    SetPedMotionBlur(GetPlayerPed(-1), false) -- removes blur
    count = 0  -- sets cylce count to 0 for next usage
    ESX.ShowNotification('Yavaşlıyorsun ve yorgun düşüyorsun...') -- sends notification when effect is over
    yavasKos = true  -- sets speed to very slow to animiate exhausting effect
    Citizen.Wait(30000)  -- this values determines how long the exhausting effect // value is in miliseconds
    yavasKos = false -- removes slow speed
    ESX.ShowNotification('Tekrar eski haline döndün.') -- show notification that you are now feeling okay
end)