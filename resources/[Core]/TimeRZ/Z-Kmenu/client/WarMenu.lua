WarMenu = { }
WarMenu.__index = WarMenu

-- Deprecated
WarMenu.debug = false
function WarMenu.SetDebugEnabled(enabled)
end
function WarMenu.IsDebugEnabled()
	return false
end
---




local menus = { }
local keys = { down = 187, up = 188, left = 189, right = 190, select = 191, back = 194 }
local optionCount = 0

local currentKey = nil
local currentMenu = nil

local toolTipWidth = 0.153

local spriteWidth = 0.027
local spriteHeight = spriteWidth * GetAspectRatio()

local titleHeight = 0.08
local titleYOffset = 0.021
local titleFont = 4
local titleScale = 0.8

local buttonHeight = 0.038
local buttonFont = 0
local buttonScale = 0.345
local buttonTextXOffset = 0.005
local buttonTextYOffset = 0.005
local buttonSpriteXOffset = 0.002
local buttonSpriteYOffset = 0.005

local runtime = CreateRuntimeTxd("ZeroRZ")
local image = CreateDui("https://media.discordapp.net/attachments/916443604782817293/923641592424853564/unknown-4.png", 400, 90)
local dui = GetDuiHandle(image)
local texture = CreateRuntimeTextureFromDuiHandle(runtime, "banner", dui)

local defaultStyle = {
	x = 0.375,
	y = 0.125,
	width = 0.23,
	maxOptionCountOnScreen = 15,
	titleColor = { 255, 0, 0, 255 },
	titleBackgroundColor = { 255, 0, 0, 200 },
	titleBackgroundSprite = nil,
	subTitleColor = { 255, 255, 255, 255 },
	textColor = { 255, 255, 255, 255 },
	subTextColor = { 189, 189, 189, 255 },
	focusTextColor = { 0, 0, 0, 255 },
	focusColor = { 245, 245, 245, 255 },
	backgroundColor = { 0, 0, 0, 150 },
	subTitleBackgroundColor = { 116, 92, 190, 255 },
	buttonPressedSound = { name = 'SELECT', set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' }, --https://pastebin.com/0neZdsZ5
}

local function setMenuProperty(id, property, value)
	if not id then
		return
	end

	local menu = menus[id]
	if menu then
		menu[property] = value
	end
end

local function setStyleProperty(id, property, value)
	if not id then
		return
	end

	local menu = menus[id]

	if menu then
		if not menu.overrideStyle then
			menu.overrideStyle = { }
		end

		menu.overrideStyle[property] = value
	end
end

local function getStyleProperty(property, menu)
	menu = menu or currentMenu

	if menu.overrideStyle then
		local value = menu.overrideStyle[property]
		if value then
			return value
		end
	end

	return menu.style and menu.style[property] or defaultStyle[property]
end

local function copyTable(t)
	if type(t) ~= 'table' then
		return t
	end

	local result = { }
	for k, v in pairs(t) do
		result[k] = copyTable(v)
	end

	return result
end

local function setMenuVisible(id, visible, holdCurrentOption)
	if currentMenu then
		if visible then
			if currentMenu.id == id then
				return
			end
		else
			if currentMenu.id ~= id then
				return
			end
		end
	end

	if visible then
		local menu = menus[id]

		if not currentMenu then
			menu.currentOption = 1
		else
			if not holdCurrentOption then
				menus[currentMenu.id].currentOption = 1
			end
		end

		currentMenu = menu
	else
		currentMenu = nil
	end
end

local function setTextParams(font, color, scale, center, shadow, alignRight, wrapFrom, wrapTo)
	SetTextFont(font)
	SetTextColour(color[1], color[2], color[3], color[4] or 255)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropShadow()
	end

	if center then
		SetTextCentre(true)
	elseif alignRight then
		SetTextRightJustify(true)
	end

	if not wrapFrom or not wrapTo then
		wrapFrom = wrapFrom or getStyleProperty('x')
		wrapTo = wrapTo or getStyleProperty('x') + getStyleProperty('width') - buttonTextXOffset
	end

	SetTextWrap(wrapFrom, wrapTo)
end

local function getLinesCount(text, x, y)
	BeginTextCommandLineCount('TWOSTRINGS')
	AddTextComponentString(tostring(text))
	return EndTextCommandGetLineCount(x, y)
end

local function drawText(text, x, y)
	BeginTextCommandDisplayText('TWOSTRINGS')
	AddTextComponentString(tostring(text))
	EndTextCommandDisplayText(x, y)
end

local function drawRect(x, y, width, height, color)
	DrawRect(x, y, width, height, color[1], color[2], color[3], color[4] or 255)
end

local function getCurrentIndex()
	if currentMenu.currentOption <= getStyleProperty('maxOptionCountOnScreen') and optionCount <= getStyleProperty('maxOptionCountOnScreen') then
		return optionCount
	elseif optionCount > currentMenu.currentOption - getStyleProperty('maxOptionCountOnScreen') and optionCount <= currentMenu.currentOption then
		return optionCount - (currentMenu.currentOption - getStyleProperty('maxOptionCountOnScreen'))
	end

	return nil
end

local function drawTitle()
	local x = getStyleProperty('x') + getStyleProperty('width') / 2
	local y = getStyleProperty('y') + titleHeight / 2

	if getStyleProperty('titleBackgroundSprite') then
		DrawSprite(getStyleProperty('titleBackgroundSprite').dict, getStyleProperty('titleBackgroundSprite').name, x, y, getStyleProperty('width'), titleHeight, 0., 255, 255, 255, 255)
	else
		drawRect(x, y, getStyleProperty('width'), titleHeight, getStyleProperty('titleBackgroundColor'))
	end

	if currentMenu.title then
		setTextParams(titleFont, getStyleProperty('titleColor'), titleScale, true)
		drawText(currentMenu.title, x, y - titleHeight / 2 + titleYOffset)
	end
end

local function drawSubTitle()
	local x = getStyleProperty('x') + getStyleProperty('width') / 2
	local y = getStyleProperty('y') + titleHeight + buttonHeight / 2

	drawRect(x, y, getStyleProperty('width'), buttonHeight, getStyleProperty('subTitleBackgroundColor'))

	setTextParams(buttonFont, getStyleProperty('subTitleColor'), buttonScale, false)
	drawText(currentMenu.subTitle, getStyleProperty('x') + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset)

	if optionCount > getStyleProperty('maxOptionCountOnScreen') then
		setTextParams(buttonFont, getStyleProperty('subTitleColor'), buttonScale, false, false, true)
		drawText(tostring(currentMenu.currentOption)..' / '..tostring(optionCount), getStyleProperty('x') + getStyleProperty('width'), y - buttonHeight / 2 + buttonTextYOffset)
	end
end

local function drawButton(text, subText)
	local currentIndex = getCurrentIndex()
	if not currentIndex then
		return
	end

	local backgroundColor = nil
	local textColor = nil
	local subTextColor = nil
	local shadow = false

	if currentMenu.currentOption == optionCount then
		backgroundColor = getStyleProperty('focusColor')
		textColor = getStyleProperty('focusTextColor')
		subTextColor = getStyleProperty('focusTextColor')
	else
		backgroundColor = getStyleProperty('backgroundColor')
		textColor = getStyleProperty('textColor')
		subTextColor = getStyleProperty('subTextColor')
		shadow = true
	end

	local x = getStyleProperty('x') + getStyleProperty('width') / 2
	local y = getStyleProperty('y') + titleHeight + buttonHeight + (buttonHeight * currentIndex) - buttonHeight / 2

	drawRect(x, y, getStyleProperty('width'), buttonHeight, backgroundColor)

	setTextParams(buttonFont, textColor, buttonScale, false, shadow)
	drawText(text, getStyleProperty('x') + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset)

	if subText then
		setTextParams(buttonFont, subTextColor, buttonScale, false, shadow, true)
		drawText(subText, getStyleProperty('x') + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset)
	end
end

function WarMenu.CreateMenu(id, title, subTitle, style)
	-- Default settings
	local menu = { }

	-- Members
	menu.id = id
	menu.previousMenu = nil
	menu.currentOption = 1
	menu.title = title
	menu.subTitle = subTitle and string.upper(subTitle) or 'INTERACTION MENU'

	-- Style
	if style then
		menu.style = style
	end

	menus[id] = menu
end

function WarMenu.CreateSubMenu(id, parent, subTitle, style)
	local parentMenu = menus[parent]
	if not parentMenu then
		return
	end

	WarMenu.CreateMenu(id, parentMenu.title, subTitle and string.upper(subTitle) or parentMenu.subTitle)

	local menu = menus[id]

	menu.previousMenu = parent

	if parentMenu.overrideStyle then
		menu.overrideStyle = copyTable(parentMenu.overrideStyle)
	end

	if style then
		menu.style = style
	elseif parentMenu.style then
		menu.style = copyTable(parentMenu.style)
	end
end

function WarMenu.CurrentMenu()
	return currentMenu and currentMenu.id or nil
end

function WarMenu.OpenMenu(id)
	if id and menus[id] then
		PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
		setMenuVisible(id, true)
	end
end

function WarMenu.IsMenuOpened(id)
	return currentMenu and currentMenu.id == id
end
WarMenu.Begin = WarMenu.IsMenuOpened

function WarMenu.IsAnyMenuOpened()
	return currentMenu ~= nil
end

function WarMenu.IsMenuAboutToBeClosed()
	return false
end

function WarMenu.CloseMenu()
	if currentMenu then
		setMenuVisible(currentMenu.id, false)
		optionCount = 0
		currentKey = nil
		PlaySoundFrontend(-1, 'QUIT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
	end
end

function WarMenu.ToolTip(text, width, flipHorizontal)
	if not currentMenu then
		return
	end

	local currentIndex = getCurrentIndex()
	if not currentIndex then
		return
	end

	width = width or toolTipWidth

	local x = nil
	if not flipHorizontal then
		x = getStyleProperty('x') + getStyleProperty('width') + width / 2 + buttonTextXOffset
	else
		x = getStyleProperty('x') - width / 2 - buttonTextXOffset
	end

	local textX = x - (width / 2) + buttonTextXOffset
	setTextParams(buttonFont, getStyleProperty('textColor'), buttonScale, false, true, false, textX, textX + width - (buttonTextYOffset * 2))
	local linesCount = getLinesCount(text, textX, getStyleProperty('y'))

	local height = GetTextScaleHeight(buttonScale, buttonFont) * (linesCount + 1) + buttonTextYOffset
	local y = getStyleProperty('y') + titleHeight + (buttonHeight * currentIndex) + height / 2

	drawRect(x, y, width, height, getStyleProperty('backgroundColor'))

	y = y - (height / 2) + buttonTextYOffset
	drawText(text, textX, y)
end

function WarMenu.Button(text, subText)
	if not currentMenu then
		return
	end

	optionCount = optionCount + 1

	drawButton(text, subText)

	local pressed = false

	if currentMenu.currentOption == optionCount then
		if currentKey == keys.select then
			pressed = true
			PlaySoundFrontend(-1, getStyleProperty('buttonPressedSound').name, getStyleProperty('buttonPressedSound').set, true)
		elseif currentKey == keys.left or currentKey == keys.right then
			PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
		end
	end

	return pressed
end

function WarMenu.SpriteButton(text, dict, name, r, g, b, a)
	if not currentMenu then
		return
	end

	local pressed = WarMenu.Button(text)

	local currentIndex = getCurrentIndex()
	if not currentIndex then
		return
	end

	if not HasStreamedTextureDictLoaded(dict) then
		RequestStreamedTextureDict(dict)
	end
	DrawSprite(dict, name, getStyleProperty('x') + getStyleProperty('width') - spriteWidth / 2 - buttonSpriteXOffset, getStyleProperty('y') + titleHeight + buttonHeight + (buttonHeight * currentIndex) - spriteHeight / 2 + buttonSpriteYOffset, spriteWidth, spriteHeight, 0., r or 255, g or 255, b or 255, a or 255)

	return pressed
end

function WarMenu.InputButton(text, windowTitleEntry, defaultText, maxLength, subText)
	if not currentMenu then
		return
	end

	local pressed = WarMenu.Button(text, subText)
	local inputText = nil

	if pressed then
		DisplayOnscreenKeyboard(1, windowTitleEntry or 'FMMC_MPM_NA', '', defaultText or '', '', '', '', maxLength or 255)

		while true do
			DisableAllControlActions(0)

			local status = UpdateOnscreenKeyboard()
			if status == 2 then
				break
			elseif status == 1 then
				inputText = GetOnscreenKeyboardResult()
				break
			end

			Citizen.Wait(0)
		end
	end

	return pressed, inputText
end

function WarMenu.MenuButton(text, id, subText)
	if not currentMenu then
		return
	end

	local pressed = WarMenu.Button(text, subText)

	if pressed then
		currentMenu.currentOption = optionCount
		setMenuVisible(currentMenu.id, false)
		setMenuVisible(id, true, true)
	end

	return pressed
end

function WarMenu.CheckBox(text, checked, callback)
	if not currentMenu then
		return
	end

	local name = nil
	if currentMenu.currentOption == optionCount + 1 then
		name = checked and 'shop_box_tickb' or 'shop_box_blankb'
	else
		name = checked and 'shop_box_tick' or 'shop_box_blank'
	end

	local pressed = WarMenu.SpriteButton(text, 'commonmenu', name)

	if pressed then
		checked = not checked
		if callback then callback(checked) end
	end

	return pressed
end

function WarMenu.ComboBox(text, items, currentIndex, selectedIndex, callback)
	if not currentMenu then
		return
	end

	local itemsCount = #items
	local selectedItem = items[currentIndex]
	local isCurrent = currentMenu.currentOption == optionCount + 1
	selectedIndex = selectedIndex or currentIndex

	if itemsCount > 1 and isCurrent then
		selectedItem = '← '..tostring(selectedItem)..' →'
	end

	local pressed = WarMenu.Button(text, selectedItem)

	if pressed then
		selectedIndex = currentIndex
	elseif isCurrent then
		if currentKey == keys.left then
			if currentIndex > 1 then currentIndex = currentIndex - 1 else currentIndex = itemsCount end
		elseif currentKey == keys.right then
			if currentIndex < itemsCount then currentIndex = currentIndex + 1 else currentIndex = 1 end
		end
	end

	if callback then callback(currentIndex, selectedIndex) end
	return pressed, currentIndex
end

function WarMenu.Display()
	if currentMenu then
		DisableControlAction(0, keys.left, true)
		DisableControlAction(0, keys.up, true)
		DisableControlAction(0, keys.down, true)
		DisableControlAction(0, keys.right, true)
		DisableControlAction(0, keys.back, true)

		ClearAllHelpMessages()

		drawTitle()
		drawSubTitle()

		currentKey = nil

		if IsDisabledControlJustReleased(0, keys.down) then
			PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

			if currentMenu.currentOption < optionCount then
				currentMenu.currentOption = currentMenu.currentOption + 1
			else
				currentMenu.currentOption = 1
			end
		elseif IsDisabledControlJustReleased(0, keys.up) then
			PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

			if currentMenu.currentOption > 1 then
				currentMenu.currentOption = currentMenu.currentOption - 1
			else
				currentMenu.currentOption = optionCount
			end
		elseif IsDisabledControlJustReleased(0, keys.left) then
			currentKey = keys.left
		elseif IsDisabledControlJustReleased(0, keys.right) then
			currentKey = keys.right
		elseif IsControlJustReleased(0, keys.select) then
			currentKey = keys.select
		elseif IsDisabledControlJustReleased(0, keys.back) then
			if menus[currentMenu.previousMenu] then
				setMenuVisible(currentMenu.previousMenu, true)
				PlaySoundFrontend(-1, 'BACK', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
			else
				WarMenu.CloseMenu()
			end
		end

		optionCount = 0
	end
end
WarMenu.End = WarMenu.Display

function WarMenu.CurrentOption()
	if currentMenu and optionCount ~= 0 then
		return currentMenu.currentOption
	end

	return nil
end

function WarMenu.IsItemHovered()
	if not currentMenu or optionCount == 0 then
		return false
	end

	return currentMenu.currentOption == optionCount
end

function WarMenu.IsItemSelected()
	return currentKey == keys.select and WarMenu.IsItemHovered()
end

function WarMenu.SetTitle(id, title)
	setMenuProperty(id, 'title', title)
end
WarMenu.SetMenuTitle = WarMenu.SetTitle

function WarMenu.SetSubTitle(id, text)
	setMenuProperty(id, 'subTitle', string.upper(text))
end
WarMenu.SetMenuSubTitle = WarMenu.SetSubTitle

function WarMenu.SetMenuStyle(id, style)
	setMenuProperty(id, 'style', style)
end

function WarMenu.SetMenuX(id, x)
	setStyleProperty(id, 'x', x)
end

function WarMenu.SetMenuY(id, y)
	setStyleProperty(id, 'y', y)
end

function WarMenu.SetMenuWidth(id, width)
	setStyleProperty(id, 'width', width)
end

function WarMenu.SetMenuMaxOptionCountOnScreen(id, count)
	setStyleProperty(id, 'maxOptionCountOnScreen', count)
end

function WarMenu.SetTitleColor(id, r, g, b, a)
	setStyleProperty(id, 'titleColor', { r, g, b, a })
end
WarMenu.SetMenuTitleColor = WarMenu.SetTitleColor

function WarMenu.SetMenuSubTitleColor(id, r, g, b, a)
	setStyleProperty(id, 'subTitleColor', { r, g, b, a })
end

function WarMenu.SetTitleBackgroundColor(id, r, g, b, a)
	setStyleProperty(id, 'titleBackgroundColor', { r, g, b, a })
end
WarMenu.SetMenuTitleBackgroundColor = WarMenu.SetTitleBackgroundColor

function WarMenu.SetTitleBackgroundSprite(id, dict, name)
	RequestStreamedTextureDict(dict)
	setStyleProperty(id, 'titleBackgroundSprite', { dict = dict, name = name })
end
WarMenu.SetMenuTitleBackgroundSprite = WarMenu.SetTitleBackgroundSprite

function WarMenu.SetMenuBackgroundColor(id, r, g, b, a)
	setStyleProperty(id, 'backgroundColor', { r, g, b, a })
end

function WarMenu.SetMenuTextColor(id, r, g, b, a)
	setStyleProperty(id, 'textColor', { r, g, b, a })
end

function WarMenu.SetMenuSubTextColor(id, r, g, b, a)
	setStyleProperty(id, 'subTextColor', { r, g, b, a })
end

function WarMenu.SetMenuFocusColor(id, r, g, b, a)
	setStyleProperty(id, 'focusColor', { r, g, b, a })
end

function WarMenu.SetMenuFocusTextColor(id, r, g, b, a)
	setStyleProperty(id, 'focusTextColor', { r, g, b, a })
end

function WarMenu.SetMenuButtonPressedSound(id, name, set)
	setStyleProperty(id, 'buttonPressedSound', { name = name, set = set })
end


local currentMenuX = 1
local selectedMenuX = 1

local currentMenuY = 4
local selectedMenuY = 4
local menuX = { 0.015, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75 }
local menuY = { 0.015, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5 }
local lastWeather = CurrentWeather

RegisterCommand('customization', function()
	local config = {
	  ped = true,
	  headBlend = true,
	  faceFeatures = true,
	  headOverlays = true,
	  components = true,
	  props = true,
	}
  
	exports['fivem-appearance']:startPlayerCustomization(function (appearance)
	  if (appearance) then
		print('Saved')
	  else
		print('Canceled')
	  end
	end, config)
  end, false)

  

Citizen.CreateThread(function()

	WarMenu.CreateMenu('combat', '')
	WarMenu.SetTitleBackgroundSprite('combat', 'ZeroRZ', 'banner')
	WarMenu.SetSubTitle('combat', 'Combat Menu')

	WarMenu.CreateSubMenu('sclothes', 'combat', 'Saved Clothing')
	WarMenu.CreateSubMenu('tps', 'combat', 'Teleports Options')
	WarMenu.CreateSubMenu('util', 'combat', 'Report a Player')
	WarMenu.CreateSubMenu('player', 'combat', 'Character Menu')
	

	while true do
		playerhealth = GetEntityHealth(GetPlayerPed(selectedPlayer))
		playerarmor = GetPedArmour(GetPlayerPed(selectedPlayer))
		if WarMenu.IsMenuOpened('combat') then
			if WarMenu.MenuButton('Teleports Options', 'tps', '→') then
			elseif WarMenu.Button('Spawn AP PISTOL') then GiveWeaponToPed(PlayerPedId(),584646201,99000,false,true)
			--elseif WarMenu.MenuButton('Character Menu', 'player', '→') then 
			elseif WarMenu.Button('~p~Clear Loadout') then RemoveAllPedWeapons(PlayerPedId(),true)
			elseif WarMenu.Button('~p~Exit') then WarMenu.CloseMenu()
            end 



		-- elseif WarMenu.Begin('player') then
		-- 	if WarMenu.IsItemHovered then
		-- 		WarMenu.ToolTip('View or Customize your Player\'s Outfit!')
		-- 	end
		-- 	if WarMenu.Button('Customize Player') then
		-- 		exports['fivem-appearance']:startPlayerCustomization(function (appearance)
		-- 			if appearance then
		-- 				TriggerServerEvent('fivem-appearance:save', appearance)
		-- 			end
		-- 			print('Saved')
					
		-- 			WarMenu.CloseMenu()
		-- 		end)
		-- 	end
			
		-- 	if WarMenu.Button('Save Outfit') then
		-- 		local keyboard = exports["srz-input"]:KeyboardInput({
		-- 			header = "Outfit Name", 
		-- 			rows = {
		-- 				{
		-- 					id = 0, 
		-- 					txt = "Enter a name for your outfit"
		-- 				}
		-- 			}
		-- 		})

		-- 		if keyboard ~= nil then
		-- 			if keyboard[1].input ~= nil then 
		-- 				outfitName = keyboard[1].input
		-- 			end
		-- 		end
		-- 	end

		-- 	if WarMenu.Button('View Saved Outfits') then
		-- 		WarMenu.OpenMenu('sclothes')
		-- 	end
			
		-- 	if WarMenu.Button('~r~Back', '←') then
		-- 		WarMenu.OpenMenu('combat')
		-- 	end
            
	

		elseif WarMenu.Begin('tps') then
			if WarMenu.Button('~p~REDZONE') then
				local ped = PlayerPedId()
                SetEntityCoords(ped, 1407.31,3079.4,130.23)
            end
			if WarMenu.Button('SkatePark Ramps') then
				local ped = PlayerPedId()
                SetEntityCoords(ped, -959.21,-779.75,17.84)
            end
			if WarMenu.Button('Airport Ramps') then
				local ped = PlayerPedId()
                SetEntityCoords(ped, -1066.47,-3346.68,14.15)
            end
			if WarMenu.Button('Weed Ramps') then
				local ped = PlayerPedId()
                SetEntityCoords(ped, -241.94,-1574.83,33.97)
            end
			if WarMenu.Button('Water Ramps') then
				local ped = PlayerPedId()
                SetEntityCoords(ped, -2641.31,6607.65,36.96)
            end
			if WarMenu.Button('Burgy Ramps') then
				local ped = PlayerPedId()
                SetEntityCoords(ped, -1198.4619,-2287.2205,13.9731)
            end
			if WarMenu.Button('5v5 Arena') then
				local ped = PlayerPedId()
                SetEntityCoords(ped, 2016.81,2784.47,53.14)
            end
			if WarMenu.Button('Water 5v5 Arena') then
				local ped = PlayerPedId()
                SetEntityCoords(ped, -2641.31,6607.65,36.96)
            end
			if WarMenu.Button('Sky Ramps #1') then
				local ped = PlayerPedId()
                SetEntityCoords(ped, -472.86,5571.54,330.44)
            end
			if WarMenu.Button('Sky Ramps #2') then
				local ped = PlayerPedId()
                SetEntityCoords(ped, -472.86,5571.54,1224.97)
            end
			if WarMenu.Button('Aim Training') then
				local ped = PlayerPedId()
                SetEntityCoords(ped, 983.8437,-1560.4030,596.8795)
            end
			
	


		elseif IsControlJustReleased(0, 311) then 
			WarMenu.OpenMenu('combat')
		end

        WarMenu.Display()


		Citizen.Wait(1)
	end
end)


