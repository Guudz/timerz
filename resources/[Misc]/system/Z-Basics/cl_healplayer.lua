Healcooldown = false

RegisterCommand('h', function(source, args, rawCommand)
    if Healcooldown == false then
        notify("~g~Healed")
        SetEntityHealth(GetPlayerPed(-1), 200)
        Healcooldown = true
        Wait(5000)
        Healcooldown = false
    end
    if Healcooldown == true then
        notify("~r~ You have to wait 5 seconds since the last use of this command")
    end
end)


ArmourCoolDown = false

RegisterCommand('a', function(source, args, rawCommand)
    if ArmourCoolDown == false then
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            notify("~r~Player can't apply armour while in a vehicle.")
        else
            notify("~b~100% armour applied - Wait 5 secs to apply again")
            AddArmourToPed(GetPlayerPed(-1), 100)
            ArmourCoolDown = true
            Wait(5000)
            ArmourCoolDown = false
        end
    end
    if ArmourCoolDown == true then
        notify("~r~ You have to wait 5 seconds since the last use of this command") 
    end

end)



function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true,false)
end

AddEventHandler('playerSpawned',function()
    SetEntityMaxHealth(GetPlayerPed(-1), 200) 
    SetEntityHealth(GetPlayerPed(-1), 200)
end)

AddEventHandler('playerSpawned',function()
    AddArmourToPed(GetPlayerPed(-1), 200)
end)