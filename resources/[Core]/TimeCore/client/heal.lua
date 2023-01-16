hcooldown = false

RegisterCommand('h', function(source, args, rawCommand)
    if hcooldown == false then 
        Notify( "You have refilled your Armor" )
        SetEntityHealth(GetPlayerPed(-1), 200)
        hcooldown = true
        Wait(10000)
        hcooldown = false
    end
    if hcooldown == true then
        Notify( "Wait a little bit until you can apply Armor again!" )     
    end
end)


acooldown = false

RegisterCommand('a', function(source, args, rawCommand)
    if acooldown == false then
        Notify( "You have refilled your Armor" )                
        AddArmourToPed(GetPlayerPed(-1), 100)
        acooldown = true
        Wait(10000)
        acooldown = false

    end
    if acooldown == true then
        Notify( "Wait 10 seconds until you can Regain Armor again!" )   
    end
end)

