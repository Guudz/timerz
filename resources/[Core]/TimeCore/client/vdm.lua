	for _, i in ipairs(GetActivePlayers()) do
	if i ~= PlayerId() then
	  local closestPlayerPed = GetPlayerPed(i)
	  local veh = GetVehiclePedIsIn(closestPlayerPed, false)
	  SetEntityNoCollisionEntity(veh, GetPlayerPed(-1), false, false)
	end
end
