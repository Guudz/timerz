-- Discord
Citizen.CreateThread(function()
    
    while true do
        local player = GetPlayerPed(-1)
        Citizen.Wait(5*1000)

        SetDiscordAppId(922493436135886948) -- Replace 0 with your application client id.

        -- Where the player is located
        SetRichPresece( GetPlayerName(source).. "en train de se battre 🔪".. GetStreetNameFromHashKey( table.unpack ( GetEntityCoords(player) )) )

        
        SetDiscordRichPresenceAsset("1024") -- The name of the big picture you added in the application.
        SetDiscordRichPresenceAssetText("Joueurs: " .. GetPlayerName(source))

        SetDiscordRichPresenceAssetSmall("512") -- The name of the small picture you added in the application.
        SetDiscordRichPresenceAssetSmallText("Ping: " .. GetPlayerPing(source))
        
    end

end)
