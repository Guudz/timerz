self = {}
Citizen.CreateThread(function()
    while true do
        self.PlayerPed = PlayerPedId()
        self.PlayerPosition = GetEntityCoords(self.PlayerPed)
        Citizen.Wait(1500)
    end
end)

local mz = {
	{["x"] = 0.0892, ["y"] = -0.0826, ["z"] = 26.68}, --Spawn
	{["x"] = -55.86, ["y"] = -1840.88, ["z"] = 26.68}, --Redzone
	{["x"] = -55.86, ["y"] = -1840.88, ["z"] = 26.68}, --Spawn
	{["x"] = -55.86, ["y"] = -1840.88, ["z"] = 26.68}, --Spawn
	{["x"] = -55.86, ["y"] = -1840.88, ["z"] = 26.68}, --Spawn
	{["x"] = -55.86, ["y"] = -1840.88, ["z"] = 26.68}, --Spawn
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
			Citizen.Wait(7)
		end

		while not NetworkIsPlayerActive(PlayerId()) do
			Citizen.Wait(7)
		end
		while true do
			local x, y, z = self.PlayerPosition.xyz
			local minDistance = 100000
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
			Citizen.Wait(7)
		end
		while self.PlayerPosition == nil do
			Citizen.Wait(7)
		end
		while true do
			sleep = 1000
			local x, y, z = self.PlayerPosition.xyz
			local dist = Vdist(mz[closestZone].x, mz[closestZone].y, mz[closestZone].z, x, y, z)
			if dist <= 50.0 then
				sleep = 5
				if not notifIn then
					NetworkSetFriendlyFireOption(false)
					ClearPlayerWantedLevel(PlayerId())
					SetCurrentPedWeapon(self.PlayerPed, GetHashKey("WEAPON_UNARMED"), true)
					ShowInfo("Lmfao you went into a greenzone! what are you pussy?")
					notifIn = true
					notifOut = false
				end
			else
				if not notifOut then
					NetworkSetFriendlyFireOption(true)
					ShowInfo("You have left the greenzone cuh!")
					notifOut = true
					notifIn = false
				end
				sleep = 1000
			end
			if notifIn then
				DisableControlAction(2, 37, true)
				DisablePlayerFiring(self.PlayerPed, true)
				DisableControlAction(0, 106, true)
				DisableControlAction(0, 140, true)
			end
			Citizen.Wait(sleep)
		end
	end
)
