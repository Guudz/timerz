Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(3)
            SetPedDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
            SetGarbageTrucks(false)
            SetRandomBoats(false)
            SetCreateRandomCops(false)
            SetCreateRandomCopsNotOnScenarios(false)
            SetCreateRandomCopsOnScenarios(false)
        end
    end
)

Citizen.CreateThread(
    function()
    while true do
        Citizen.Wait(4)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local pid = PlayerId()
        RemoveVehiclesFromGeneratorsInArea(pos.x - 500.0, pos.y - 500.0, pos.z - 500.0, pos.x + 500.0, pos.y + 500.0, pos.z + 500.0)
        DisablePlayerVehicleRewards(pid)
       end
   end
)