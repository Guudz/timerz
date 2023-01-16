Citizen.CreateThread(function() 
    while true do   
		
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local lock = GetVehicleDoorLockStatus(veh)

            if lock == 7 then
                SetVehicleDoorsLocked(veh, 2)
            end
                 
            local pedd = GetPedInVehicleSeat(veh, -1)

            if pedd then                   
                SetPedCanBeDraggedOut(pedd, false)
            end             
        end   
        Citizen.Wait(1)	
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1407.48, 3084.75, 130.37, true) <= 22 then 
			Drawing.draw3DText(1407.48, 3084.75, 126.62 + 1.700, "Bienvenue sur TimeRZ !", 7, 0.1, 0.1)
			Drawing.draw3DText(1407.48, 3084.75, 128.10, "Reglement et Informations sur : discord.gg/timerz", 7, 0.1, 0.1)
			Drawing.draw3DText(1407.48, 3084.75, 128.60 - .700, "Pour modifier votre personnage utiliser votre touche ,", 6, 0.1, 0.1)
            Drawing.draw3DText(1407.48, 3084.75, 128.40 - .700, "Pour ouvir le menu principal utiliser votre touche k", 6, 0.1, 0.1)
		end
	end
end)


Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing

function Drawing.draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(116, 92, 190, 255)
    SetTextDropshadow(1, 1, 1, 0, 255)
    SetTextEdge(2, 0, 0, 0, 220)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
