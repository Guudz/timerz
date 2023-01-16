local ConfigRedzone = {
    Location = vector3(1407.4257, 3079.6421, 130.3700), 
    Size = 350.0
}

local reviveWait = 0 -- Change the amount of time to wait before allowing revive (in seconds)
local isDead = false
local timerCount = reviveWait

-- Turn off automatic respawn here instead of updating FiveM file.
AddEventHandler('onClientMapStart', function()
	exports.system:spawnPlayer() -- Ensure player spawns into server.
	Citizen.Wait(3000)
	exports.system:setAutoSpawn(false)
end)

function IsOutsideOfRedZone(ped)
	return #(GetEntityCoords(ped) - ConfigRedzone.Location) > ConfigRedzone.Size
end

function respawnPed(ped, coords)
	SetEntityCoordsNoOffset(ped, 1407.4257, 3079.6421, 130.3657, false, false, false, true)
    NetworkResurrectLocalPlayer(1407.4257, 3079.6421, 130.3657, 83.8816, true, false) 
	SetPlayerInvincible(ped, false) 
	TriggerEvent('playerSpawned', 1407.4257, 3079.6421, 130.3657, 83.8816)
	ClearPedBloodDamage(ped)
end

function revivePed(ped)
	local playerPos = GetEntityCoords(ped, true)
	isDead = false
	timerCount = reviveWait
	NetworkResurrectLocalPlayer(playerPos, true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
end

function ShowInfoRevive(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(true, true)
end

Citizen.CreateThread(function()
	local respawnCount = 0
	local spawnPoints = {}
	local playerIndex = NetworkGetPlayerIndex(-1) or 0
	math.randomseed(playerIndex)

	function createSpawnPoint(x1, x2, y1, y2, z, heading)
		local xValue = math.random(x1,x2) + 0.0001
		local yValue = math.random(y1,y2) + 0.0001

		local newObject = {
			x = xValue,
			y = yValue,
			z = z + 0.0001,
			heading = heading + 0.0001
		}
		table.insert(spawnPoints,newObject)
	end

	createSpawnPoint(-14893, -14893, 13244, 13244, 340, 0) -- Mount Zonah


    while true do
    Citizen.Wait(0)
		ped = GetPlayerPed(-1)
        if IsEntityDead(ped) then
			isDead = true
            SetPlayerInvincible(ped, true)
            SetEntityHealth(ped, 0)
			ShowInfoRevive('~r~You are dead.~w~ Use ~g~[E] ~w~to revive or ~g~[Q] ~w~to respawn.')
            if IsControlJustReleased(1, 46) then
                if timerCount <= 0 then
					if (IsOutsideOfRedZone(ped)) then 
						revivePed(ped)
						TriggerEvent('chat:addMessage', {args = {'^2You have been revived!^0'}})
					else
						TriggerEvent('chat:addMessage', {args = {'^1You cannot revive when inside an Redzone...^0'}})
					end
					print("BAAS")
				else
					TriggerEvent('chat:addMessage', { args = {'^*Wait ' .. timerCount .. ' more seconds before reviving.'}})
                end	
            elseif IsControlJustReleased(1, 44) then
                local coords = spawnPoints[math.random(1,#spawnPoints)]
				respawnPed(ped, coords)
                                SetPedArmour(PlayerPedId(), 100)
				isDead = false
				timerCount = reviveWait
				respawnCount = respawnCount + 1
				math.randomseed(playerIndex * respawnCount)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isDead then
			timerCount = timerCount - 1
        end
        Citizen.Wait(2000)          
    end
end)
