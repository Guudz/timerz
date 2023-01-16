--------------------------------------------------
----------------REGISTERING EVENTS----------------
--------------------------------------------------

RegisterNetEvent("DeathScript:Revive")
RegisterNetEvent("DeathScript:Respawn")
RegisterNetEvent("DeathScript:AdminRevive")
RegisterNetEvent("DeathScript:AdminRespawn")
RegisterNetEvent("DeathScript:SetReviveTime")
RegisterNetEvent("DeathScript:SetRespawnTime")
RegisterNetEvent("DeathScript:Toggle")
RegisterNetEvent("DeathScript:ShowNotification")
RegisterNetEvent("DeathScript:IsPlayerDead")
RegisterNetEvent("DeathScript:Suicide")


--------------------------------------------------
----------------DEFINING VARIABLES----------------
--------------------------------------------------

OriginalReviveTime = 500
OriginalRespawnTime = 0

ReviveTime = 500
RespawnTime = 0

ReviveAllowed = false
RespawnAllowed = false

DeathTime = nil

DeathScriptToggle = true

respawnCount = 0
spawnPoints = {}


--------------------------------------------------
--------------------Death Loop--------------------
--------------------------------------------------

Citizen.CreateThread(function()
    
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
		if IsEntityDead( ped ) then
            SetPlayerInvincible( ped, true )
			SetEntityHealth( ped, 1 )
			RespawnAllowed = true
		end
	end
end)


--------------------------------------------------
-----------------EVENT  HANDLERS------------------
--------------------------------------------------

AddEventHandler("DeathScript:Revive", function( adrev, admin, all)
	local ped = PlayerPedId()
	if adrev then ReviveAllowed = true end
	if all then
		revivePed( ped )
		resetTimers()
		ShowNotification("~g~You have been revived by an admin!")
		return;
	end
	if GetEntityHealth( ped ) <= 1 then --if you are dead
		if ReviveAllowed then -- if timer is complete allow revive --

			revivePed( ped )
			resetTimers()
			if adrev then
				ShowNotification("~g~You have been revived by an admin!")
				TriggerServerEvent('DeathScript:AdminReturn', '~g~Player have been revived', admin)
			end
		else
			ShowNotification("~r~" .. ReviveTime .. ' seconds remaining until revive!')
		end
	else
		if adrev then
			TriggerServerEvent('DeathScript:AdminReturn', '~r~Player is alive', admin)
		else
			ShowNotification("~g~You're alive!")
		end
	end
end)

AddEventHandler("DeathScript:Respawn", function( adres, admin, all, asf)
	local ped = PlayerPedId()
	if asf == nil then asf = spawnPoints[math.random(1,#spawnPoints)] end
	if adres then RespawnAllowed = true end
	if all then
		respawnPed( ped, spawnPoints[math.random(1,#spawnPoints)] )
		resetTimers()
		ShowNotification("~g~You have been respawned by an admin!")
		return;
	end
	if GetEntityHealth( ped ) <= 1 then --if you are dead
		if RespawnAllowed then -- if timer is complete allow revive --
			
			respawnPed( ped, asf )
			GiveWeaponToPed(PlayerPedId(), "WEAPON_APPISTOL", 1000, false, true)
			resetTimers()
			if adres then
				ShowNotification("~g~You have been respawned by an admin!")
				TriggerServerEvent('DeathScript:AdminReturn', '~g~Player have been respawned', admin)
			end
		else
			ShowNotification("~r~" .. RespawnTime .. ' seconds remaining until respawn!')
		end
	else
		if adres then
			TriggerServerEvent('DeathScript:AdminReturn', '~r~Player is alive', admin)
		else
			--ShowNotification("~g~You're alive!")
		end
	end
end)

AddEventHandler('DeathScript:Toggle', function()
	DeathScriptToggle = not DeathScriptToggle
	if (DeathScriptToggle) then
		ShowNotification("~b~DeathScript was enabled")
	else
		ShowNotification("~r~DeathScript was disabled")
	end
end)

AddEventHandler('DeathScript:ShowNotification', function( str )
	ShowNotification( str )
end)

AddEventHandler('DeathScript:Suicide', function( str )
	local playerped = GetPlayerPed(-1)
	SetEntityHealth(playerped,0)
end)

--------------------------------------------------
--------------------FUNCTIONS---------------------
--------------------------------------------------

function resetTimers()
	ReviveTime = OriginalReviveTime
	RespawnTime = OriginalRespawnTime
	ReviveAllowed = false
	RespawnAllowed = false
end

--------------------------------------------------
---------------------KEYBIND----------------------
--------------------------------------------------
RegisterCommand('r', function()
	local spawn = {x = -411.26, y = 1173.99, z = 325.64, heading = 101.85}
	if isInsideOpium then
		spawn = {x = 219.45, y = -2547.156, z = 6.203, heading = 101.85}	
	elseif isInsideWeed then
		spawn = {x = -239.3322, y = -1576.631, z = 33.734, heading = 101.85}
	elseif isInsideBasketball then
		spawn = {x = -921.0408, y = -744.493, z = 19.895, heading = 101.85}
	elseif isInsidePark then
		spawn = {x = -958.58, y = -780.192, z = 17.836, heading = 101.85}
	elseif isInsideArena then
		spawn = {x = 2034.418, y = 2784.754, z = 52.90, heading = 101.85}
	elseif isInsideRedZonePoly then
		spawn = {x = -3507.179, y = 5753.718, z = 658.27, heading = 101.85}
	elseif isInsideRamp1 then
		spawn = {x = -3453.44, y = -2558.12, z = 162.83, heading = 101.85}
	elseif isInsideRamp2 then
		spawn = {x = -3453.369, y = -2491.304, z = 162.83, heading = 101.85}
	elseif isInsideRamp3 then
		spawn = {x = -3453.406, y = -2425.594, z = 162.83, heading = 101.85}
	elseif isInsideRamp4 then
		spawn = {x = -3453.637, y = -2359.472, z = 162.83, heading = 101.85}
	elseif isInsideRamp5 then
		spawn = {x = -3453.613, y = -2293.513, z = 162.83, heading = 101.85}
	end
	TriggerEvent('DeathScript:Respawn', source, nil, nil, spawn)
end, false)

RegisterKeyMapping('r', 'Revive at Zone', 'keyboard', 'CAPITAL')


------------------------------------------

RegisterCommand('die',function()
    SetEntityHealth(PlayerPedId(),0)
end)