-- This Script Made By Exp#0001
-- Discord :http://invite.brav.cc

local server_name = "TimeRZ"
local discord = "http://discord.gg/timerz"
local server_logo = "https://media.discordapp.net/attachments/916443604782817293/925521387005812736/bannerFivem.png?width=1440&height=154"

local card = {
  type = "AdaptiveCard",
  ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
  version = "1.2",
  body = { {
    type = "Container",
    items = { {
      type = "Image",
      url = server_logo,
      horizontalAlignment = "Center",
      width = "1440px",
      height = "154px"
    }, {
      type = "TextBlock",
      text = "Bienvenue sur " .. server_name .. " ,Bon jeux :)",
      wrap = true,
      horizontalAlignment = "Center",
      size = "Large",
      fontType = "Default",
      weight = "Bolder"
    }, {
      type = "ColumnSet",
      columns = { {
        type = "Column",
        width = "stretch",
        items = { {
          type = "ActionSet",
          actions = { {
            type = "Action.OpenUrl",
            title = "Accès au Discord",
            url = discord
          } }
        } }
      }, {
        type = "Column",
        width = "stretch",
        items = { {
          type = "ActionSet",
          actions = { {
            type = "Action.Submit",
            title = "Jouer"
          } }
        } }
      } }
    } }
  } }
}


local function OnPlayerConnecting(name, setKickReason, deferrals)
  local player = source
  deferrals.defer()
  -- mandatory wait!
  Wait(1000)

  function callback()
    deferrals.done();
  end

deferrals.presentCard(card,callback)

end

AddEventHandler("playerConnecting", OnPlayerConnecting)

-- This Script Made By Exp#0001
-- Discord :http://invite.brav.cc