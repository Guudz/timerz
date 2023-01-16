local ind = {l = false, r = false}
local CintoSeguranca = false
local sBuffer = {}
local vBuffer = {}

--[[local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local voice = {
	levels = {
		default = 5.0,
		shout = 12.0,
		whisper = 1.0,
		current = 0
	},
	keys = {
		distance 	= 'HOME',
	}
}

Citizen.CreateThread(function()
	RequestAnimDict('facials@gen_male@variations@normal')
	RequestAnimDict('mp_facial')
	while true do
		Citizen.Wait(300)
		local playerID = PlayerId()

		for _,player in ipairs(GetActivePlayers()) do
			local boolTalking = NetworkIsPlayerTalking(player)
	
			if player ~= playerID then
				if boolTalking then
					PlayFacialAnim(GetPlayerPed(player), 'mic_chatter', 'mp_facial')
				elseif not boolTalking then
					PlayFacialAnim(GetPlayerPed(player), 'mood_normal_1', 'facials@gen_male@variations@normal')
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
		local isTalking = false
		local voiceDistance = nil
		while true do
			Citizen.Wait(1)
			if NetworkIsPlayerTalking(PlayerId()) and not isTalking then 
				isTalking = not isTalking
				SendNUIMessage({ action = 'isTalking', value = isTalking })
			elseif not NetworkIsPlayerTalking(PlayerId()) and isTalking then 
				isTalking = not isTalking
				SendNUIMessage({ action = 'isTalking', value = isTalking })
			end
			if IsControlJustPressed(1, Keys[voice.keys.distance]) then
				voice.levels.current = (voice.levels.current + 1) % 3
			if voice.levels.current == 0 then
				NetworkSetTalkerProximity(voice.levels.default)
				voiceDistance = 'normal'
			elseif voice.levels.current == 1 then
				NetworkSetTalkerProximity(voice.levels.shout)
				voiceDistance = 'shout'
			elseif voice.levels.current == 2 then
				NetworkSetTalkerProximity(voice.levels.whisper)
				voiceDistance = 'whisper'
			end
			SendNUIMessage({ action = 'setVoiceDistance', value = voiceDistance })
		end
		if voice.levels.current == 0 then
			voiceDistance = 'normal'
		elseif voice.levels.current == 1 then
			voiceDistance = 'shout'
		elseif voice.levels.current == 2 then
			voiceDistance = 'whisper'
		end
	end
end)--]]

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		SendNUIMessage({
			show = IsPauseMenuActive(),
			colete = GetPedArmour(ped),
			vida = (((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100)) * 100)
		})
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if(IsPedInAnyVehicle(Ped)) then
			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar and GetPedInVehicleSeat(PedCar, -1) == Ped then
				-- Speed
				DisplayRadar(true)
				local velocidade = GetEntitySpeed(PedCar)
				carSpeed = math.ceil(velocidade*2.636936)
				SendNUIMessage({
					showhud = true,
					speed = carSpeed
				})

				-- Lights
				_,feuPosition,feuRoute = GetVehicleLightsState(PedCar)
				if(feuPosition == 1 and feuRoute == 0) then
					SendNUIMessage({
						feuPosition = true
					})
				else
					SendNUIMessage({
						feuPosition = false
					})
				end
				if(feuPosition == 1 and feuRoute == 1) then
					SendNUIMessage({
						feuRoute = true
					})
				else
					SendNUIMessage({
						feuRoute = false
					})
				end

				local VehIndicatorLight = GetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()))
				if IsControlJustPressed(1, 57) then -- F9 is pressed
					ind.l = not ind.l
					SetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()), 0, ind.l)
				end
				if IsControlJustPressed(1, 56) then -- F10 is pressed
					ind.r = not ind.r
					SetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()), 1, ind.r)
				end

				if(VehIndicatorLight == 0) then
					SendNUIMessage({
						clignotantGauche = false,
						clignotantDroite = false,
					})
				elseif(VehIndicatorLight == 1) then
					SendNUIMessage({
						clignotantGauche = true,
						clignotantDroite = false,
					})
				elseif(VehIndicatorLight == 2) then
					SendNUIMessage({
						clignotantGauche = false,
						clignotantDroite = true,
					})
				elseif(VehIndicatorLight == 3) then
					SendNUIMessage({
						clignotantGauche = true,
						clignotantDroite = true,
					})
				end

			else
				DisplayRadar(false)
				SendNUIMessage({
					showhud = false
				})
			end
		else
			DisplayRadar(false)
			SendNUIMessage({
				showhud = false
			})
		end

		Citizen.Wait(100)
	end
end)

-- Consume fuel factor
Citizen.CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if(IsPedInAnyVehicle(Ped)) then
			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar and GetPedInVehicleSeat(PedCar, -1) == Ped then
				carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
				fuel = GetVehicleFuelLevel(PedCar)
				rpm = GetVehicleCurrentRpm(PedCar)
				SendNUIMessage({
					showfuel = true,
					fuel = fuel
				})
			end
		end
		Citizen.Wait(100)
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- CINTO DE SEGURANÇA
-----------------------------------------------------------------------------------------------------------------------------------------
IsCar = function(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end	

Fwv = function (entity)
	local hr = GetEntityHeading(entity) + 90.0
	if hr < 0.0 then
		hr = 360.0 + hr
	end
	hr = hr * 0.0174533
	return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

local segundos = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped)

		if car ~= 0 and (ExNoCarro or IsCar(car)) then
			ExNoCarro = true
			if CintoSeguranca then
				DisableControlAction(0,75)
			end

			sBuffer[2] = sBuffer[1]
			sBuffer[1] = GetEntitySpeed(car)

			if sBuffer[2] ~= nil and not CintoSeguranca and GetEntitySpeedVector(car,true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityHealth(ped,GetEntityHealth(ped)-150)
				SetEntityCoords(ped,co.x+fw.x,co.y+fw.y,co.z-0.47,true,true,true)
				SetEntityVelocity(ped,vBuffer[2].x,vBuffer[2].y,vBuffer[2].z)
				segundos = 20
			end

			vBuffer[2] = vBuffer[1]
			vBuffer[1] = GetEntityVelocity(car)

			if IsControlJustReleased(1,47) then
				TriggerEvent("cancelando",true)
				if CintoSeguranca then
					TriggerEvent("vrp_sound:source",'unbelt',0.5)
					SetTimeout(2000,function()
						CintoSeguranca = false
						SendNUIMessage({cintohud = false})
						TriggerEvent("cancelando",false)
					end)
				else
					TriggerEvent("vrp_sound:source",'belt',0.5)
					SetTimeout(3000,function()
						CintoSeguranca = true
						SendNUIMessage({cintohud = true})
						TriggerEvent("cancelando",false)
					end)
				end
			end
		elseif ExNoCarro then
			ExNoCarro = false
			CintoSeguranca = false
			sBuffer[1],sBuffer[2] = 0.0,0.0
		end
	end
end)