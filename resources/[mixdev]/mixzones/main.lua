self = {}
Citizen.CreateThread(function()
    while true do
        self.PlayerPed = PlayerPedId()
        self.PlayerPosition = GetEntityCoords(self.PlayerPed)
        Citizen.Wait(1500)
    end
end)

local mz = {
	{["x"] = 0.15, ["y"] = -0.52, ["z"] = 667.43}, --Spawn
	{["x"] = 1407.4257, ["y"] = 3079.6421, ["z"] = 130.3700}, --Redzone
	{["x"] = -1208.0020, ["y"] = -2280.2664, ["z"] = 13.9374}, --Burgy
	{["x"] = -472.8600, ["y"] = 5571.5400, ["z"] = 330.4420}, --Sky 1
	{["x"] = -472.8706, ["y"] = 5571.5400, ["z"] = 1224.9738}, --Sky 2
}
local notifIn = false
local notifOut = false
local closestZone = 1
local function ShowInfo(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, false)
end
Citizen.CreateThread(
	function()
		while self.PlayerPosition == nil do
			Citizen.Wait(0)
		end

		while not NetworkIsPlayerActive(PlayerId()) do
			Citizen.Wait(0)
		end
		while true do
			local x, y, z = self.PlayerPosition.xyz
			local minDistance = 10000
			for i = 1, #mz, 1 do
				dist = Vdist(mz[i].x, mz[i].y, mz[i].z, x, y, z)
				if dist < minDistance then
					minDistance = dist
					closestZone = i
				end
			end
			Citizen.Wait(1000)
		end
	end
)
Citizen.CreateThread(
	function()
		while not NetworkIsPlayerActive(PlayerId()) do
			Citizen.Wait(0)
		end
		while self.PlayerPosition == nil do
			Citizen.Wait(0)
		end
		while true do
			sleep = 1000
			local x, y, z = self.PlayerPosition.xyz
			local dist = Vdist(mz[closestZone].x, mz[closestZone].y, mz[closestZone].z, x, y, z)
			if dist <= 10.2 then
				sleep = 0
				if not notifIn then
					NetworkSetFriendlyFireOption(false)
					ClearPlayerWantedLevel(PlayerId())
					ShowInfo("Lmfao you went into a greenzone! what are you pussy?")
					notifIn = true
					notifOut = false
				end
			else
				if not notifOut then
					NetworkSetFriendlyFireOption(true)
					ShowInfo("You have left the greenzone cuh!")
					SetEntityInvincible(playerPed, false)
					notifOut = true
					notifIn = false
				end
				sleep = 1000
			end
			if notifIn then
				SetEntityInvincible(playerPed, true)
				DisableControlAction(2, 37, true)
				DisablePlayerFiring(self.PlayerPed, true)
				DisableControlAction(0, 106, true)
				DisableControlAction(0, 140, true)
			end
			Citizen.Wait(sleep)
		end
	end
)
