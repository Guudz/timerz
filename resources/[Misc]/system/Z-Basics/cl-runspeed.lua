SetRunSprintMultiplierForPlayer(PlayerId(),1.01) -- dont need to execute every tick
Citizen.CreateThread(function()
    while true do  
    Citizen.Wait(0)  

            SetPedMoveRateOverride(PlayerPedId(),1.0)   -- need to execute every tick
    end
end)