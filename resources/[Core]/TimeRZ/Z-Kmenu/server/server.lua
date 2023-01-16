RegisterCommand("saveoutfit", function(source, args)
    local argString = table.concat(args, " ")

    MySQL.Async.fetchAll("INSERT INTO main(id, name, args) VALUES (@source, @name, @args)"
   {["@source"] = source, ["@name"] = GetPlayerName(source), ["@args"] = argString},
   function(result)
       TriggerClientEvent("output", source, "^2"..argString.. "^0")
   end)
end)