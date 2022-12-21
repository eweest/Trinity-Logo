-- ABOUT SCRIPT
script_name("Trinity Logo")
script_version("2.0")
script_author("eweest")
script_description("05.12.2022")
script_url("vk.com/gtatrinitymods")

-- ASSETS [START]
-- SCREEN RESOLUTION
local sX, sY = getScreenResolution()

local script = thisScript()
local scriptName = string.gsub(script.name, "%s", "-")

-- Lib's
local lib, sampev = pcall(require, "lib.samp.events")
assert(lib, "{FF3232}Отсутствует библитека \"lib.samp.events\"")
local sampev = require("lib.samp.events")

local lib, imgui = pcall(require, "imgui")
assert(lib, "{FF3232}Отсутствует библитека \"imgui\"")

local lib, encoding = pcall(require, "encoding")
assert(lib, "{FF3232}Отсутствует библитека \"encoding\"")
encoding.default = "CP1251"
u8 = encoding.UTF8

local cmdHelp = "/logo"

-- Chat
local chatMsg = {
	["tag"] = "Trinity Mods",
	["done"] = {color = "0xFFCC00", colorText = "FFFFFF", soundID = 1083},
	["warning"] = {color = "0xFF9832", colorText = "9E9E9E", soundID = 1085},
	["error"] = {color = "0xFF3232", colorText = "9E9E9E", soundID = 1055},
	["trinity"] = {color = "0x75C225", colorText = "FFFFFF", soundID = 0},
}

-- IP Servers Trinity
local trinitygtaIP = {rpg = "185.169.134.83", rp1 = "185.169.134.84", rp2 = "185.169.134.85"}

-- Path
local DIRECT = getWorkingDirectory()
local FOLDER_MAIN_PATH = "\\Trinity GTA Mods\\"
local SCRIPT_FOLDER_PATH = script.name .. "\\"
local TEXTURES_PATH = "textures\\"
local SETTINGS_PATH = "settings.json"

-- github path
local github_url = {
	update = "https://raw.githubusercontent.com/eweest/" .. scriptName .. "/main/assets/update.json",
	file = "https://raw.githubusercontent.com/eweest/" .. scriptName .. "/main/" .. scriptName .. ".lua",
	texture = "https://github.com/eweest/" .. scriptName .. "/raw/main/assets/textures/"
}

-- textures
local load_texture = {}
local texture = {}
local texture_names = {"logo-mods", "logo-color", "logo-1", "logo-2", "logo-original", "logo-newyear"}

for k, textureName in ipairs(texture_names) do -- Load Textures from github
	texture[textureName] = {textureName .. ".png", github_url.texture .. "" .. textureName .. ".png"}
end

-- Config "settings.json"
local config = { 
	["rpg"] = {style = 3, posX = 100, posY = 100, view = true, view_standart = true, color = "0xFFFFFFFF", newyearbg = true},
	["rp1"] = {style = 3, posX = 100, posY = 100, view = true, view_standart = true, color = "0xFFFFFFFF", newyearbg = true},
	["rp2"] = {style = 3, posX = 100, posY = 100, view = true, view_standart = true, color = "0xFFFFFFFF", newyearbg = true},
	update = false
}

-- Check Folders
if not doesDirectoryExist(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH) then -- Create script folder
	createDirectory(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH)
end
if not doesDirectoryExist(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. TEXTURES_PATH) then -- Create textures folder
	createDirectory(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. TEXTURES_PATH)
end
-- Download Textures
for _, nameUrl in pairs(texture) do -- Download textures
	if not doesFileExist(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. TEXTURES_PATH .. nameUrl[1]) then
		downloadUrlToFile(nameUrl[2], DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. TEXTURES_PATH .. nameUrl[1])
		print("Текстура успешно загружены! Название:{FFCC00}" .. nameUrl[1]) -- Debug in console
	end
end
-- Json Path
if not doesFileExist(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. SETTINGS_PATH) then -- Create "Settings" file
	local file = io.open(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. SETTINGS_PATH, "w")
	file:write(encodeJson(config))
	io.close(file)
	print("{FF3232}[ERROR]{CCCCCC} Файл настроек {FFCC00}'" .. SETTINGS_PATH .. "'{CCCCCC} не найден!") -- Debug in console
end

if doesFileExist(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. SETTINGS_PATH) then -- Read "Settings" file
	local file = io.open(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. SETTINGS_PATH, 'r')
	if file then
		data = decodeJson(file:read("*a"))
		io.close(file)
	end
	print("Файл настроек {FFCC00}'" .. SETTINGS_PATH .. "'{CCCCCC} успешно загружен!") -- Debug in console
end

-- -- imGUI Elements
local imgui_windows = {
	main = imgui.ImBool(false),
	checkbox = {
		view = imgui.ImBool(false),
		view_standart = imgui.ImBool(false),
		update = imgui.ImBool(data.update),
	},
	radiobutton = {
		style = imgui.ImInt(),
	},
}

local color = {}
local isSaveChanges = false
-- ASSETS [END]

-- MAIN [START]
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	-- Check update
	if data.update then
		data.update = true
		autoupdate(github_url.update, chatMsg.tag, github_url.file)
	else
		print("Автообновление Отключено.")
	end
	-- Check for Trinity Servers
	local IP = sampGetCurrentServerAddress()

	if IP:find(trinitygtaIP.rpg) or IP:find(trinitygtaIP.rp1) or IP:find(trinitygtaIP.rp2) then
		-- Load textures
		for textures, path in pairs(texture) do
			load_texture[textures] = renderLoadTextureFromFile(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. TEXTURES_PATH .. path[1])
		end
		-- Check server for config
		if IP:find(trinitygtaIP.rpg) then isServer = "rpg" end
		if IP:find(trinitygtaIP.rp1) then isServer = "rp1" end
		if IP:find(trinitygtaIP.rp2) then isServer = "rp2" end
		--
		isTrinityServer = true
		sendToChatMsg(string.format("Ресурс {FFCC00}%s (v%s){FFFFFF} запущен. Автор: {FFCC00}%s{FFFFFF}. Помощь {FFCC00}%s", script.name, script.version, unpack(script.authors), cmdHelp), "done")

	else
		sendToChatMsg(string.format("Ресурс {FFCC00}%s{9E9E9E} не запущен. Вы играете не на {FFFFFF}Trinity{75C225}GTA{FFFFFF}.", script.name), "warning")
		isTrinityServer = false 
		unloadScript()
	end

	sampRegisterChatCommand("logo", function()
		-- lua_thread.create(changePosition)
		-- changePosition()
		imgui_windows.main.v  = not imgui_windows.main.v
		imgui.Process = imgui_windows.main.v
	end)

	-- BODY [START]
	while true do wait(0)
		if isTrinityServer then
			if imgui_windows.main.v == false then
				imgui.Process = false
			end
			local spawnPlayer = sampIsLocalPlayerSpawned()
			if spawnPlayer then
				createLogo()
				changePosition()
			end
		end
	end
	-- BODY [END]
	wait(-1)
end
-- MAIN [END]

function imgui.OnDrawFrame()
	if imgui_windows.main.v then
		imgui.SetNextWindowPos(imgui.ImVec2((sX-300)/2, (sY-580)/2), imgui.Cond.FirstUseEver)
		imgui.Begin(u8 "##main_1", imgui_windows.main, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
		-- MENU [START]
		imgui.BeginChild(u8 "##block_1", imgui.ImVec2(300, 520), true, imgui.WindowFlags.AlwaysUseWindowPadding)
			imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImVec4(0, 0, 0, 0.2))
			-- BLOCK 1 [START]
			imgui.BeginChild(u8 "##block_settings", imgui.ImVec2(280, 220), false, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.AlwaysAutoResize)
			imgui.CreateText(u8 "Основные настройки", "left", "text")
			imgui.Separator()
			-- local isServer = "rp1"
				local checkboxView = imgui.ImBool(data[isServer].view)
				if imgui.Checkbox(u8(data[isServer].view and "Отключить" or "Включить") .. u8 " логотип (Новый)", checkboxView) then
					data[isServer].view = not data[isServer].view
					isSaveChanges = true
				end
				-- local checkboxViewStandart = imgui.ImBool(data[isServer].view_standart)
				-- if imgui.Checkbox(u8(data[isServer].view_standart and "Отключить" or "Включить") .. u8 " логотип (Стандартный)", checkboxViewStandart) then
				-- 	data[isServer].view_standart = not data[isServer].view_standart
				-- 	isSaveChanges = true
				-- end
				-- imgui.SetCursorPosX(10)
				if data[isServer].style == 2 then
					local a, r, g, b = explodeARGB(data[isServer].color)
					color[1] = imgui.ImFloat4(r/ 255, g/ 255, b/ 255, a/ 255)
					if imgui.ColorEdit4(u8"Изменить цвет логотипа", color[1], imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.AlphaBar) then
						local colorARGB = joinARGB(color[1].v[4]* 255, color[1].v[1]* 255, color[1].v[2]* 255, color[1].v[3]* 255)
						data[isServer].color = colorARGB
						isSaveChanges = true
					end
				else
					imgui.CreateText(u8 "Цвет изменяется только в стиле №2.\n ", "center", "disabled", true, u8"Выберите стиль №2 чтобы изменить цвет.")
				end
				if imgui.Button(u8"Изменить позицию", imgui.ImVec2(260, 30)) then
					setPosition = true
					isSaveChanges = true
				end
				if imgui.CollapsingHeader(u8"Дополнительные настройки") then
					local checkboxViewNewyearBg = imgui.ImBool(data[isServer].newyearbg)
					if imgui.Checkbox(u8(data[isServer].newyearbg and "Отключить" or "Включить") .. u8 " зимний фон", checkboxViewNewyearBg) then
						data[isServer].newyearbg = not data[isServer].newyearbg
						isSaveChanges = true
					end
					if imgui.Button(u8"Сброс ресурса", imgui.ImVec2(0, 30)) then
						removeFilesCache()
						reloadScript()
						sendToChatMsg(string.format("Вы произвели полную очистку кэша и сброса настроек ресурса {FFCC00}%s{9E9E9E}.", script.name), "warning", true)
					end
					imgui.CreateDescription(u8"Данное действие произведет удаление всех файлов кэша и файла настроек и перезапустит скрипт. Используейте в случае неккоректной работы ресурса.")
					imgui.SameLine()
					if imgui.Button(u8"Скачать кэш", imgui.ImVec2(140, 30)) then
						os.execute(("explorer.exe \"%s\""):format("https://github.com/eweest/Trinity-Logo/archive/refs/heads/main.zip"))
					end
					imgui.CreateDescription(u8"Перейти на страницу загрузки кэша и установить в ручную.\nТребуется при неккоректной загрузки файлов ресурсом.")
				end
			imgui.EndChild()
			-- BLOCK 2 [START]
			imgui.BeginChild(u8 "##block_style", imgui.ImVec2(280, 80), false, imgui.WindowFlags.AlwaysUseWindowPadding)
				imgui.CreateText(u8 "Стилистика", "left", "text")
				imgui.Separator()
				local radioButtonStyle = imgui.ImInt(data[isServer].style)
				for k, setStyle in ipairs({1,2,3,4}) do
					if imgui.RadioButton(tostring(setStyle), radioButtonStyle, setStyle) then
						if setStyle == 1 then data[isServer].style = 1; isSaveChanges = true
						elseif setStyle == 2 then data[isServer].style = 2; isSaveChanges = true
						elseif setStyle == 3 then data[isServer].style = 3; isSaveChanges = true
						elseif setStyle == 4 then data[isServer].style = 4; isSaveChanges = true
						end
					end
					imgui.SameLine()
				end
				imgui.NewLine()
				-- 
			imgui.EndChild()
			-- BLOCK 3 [START]
			imgui.BeginChild(u8 "##block_update", imgui.ImVec2(280, 140), false, imgui.WindowFlags.AlwaysUseWindowPadding)
				imgui.CreateText(u8 "О скрипте", "left", "text") imgui.SameLine() imgui.CreateText(u8 "[?]", "right", "disabled")
				imgui.CreateDescription(u8[[1. При замене логотипа на свой, используйте размеры 256x128 пикселей. 
2. В стиле №3 слово "GTA" менят цвет в зависимости от сервера на котором вы играете.
3. Кэш ресурса находиться по пути ..\moonloader\Trinity GTA Mods\Trinity Logo.
4. Когда вы делаете скриншот на F8, логотип меняется на стандартный. При условии что стандартный логотип не выключен.
]])
				imgui.Separator()
				imgui.CreateText(u8 "Автор:", "left", "disabled") imgui.SameLine()
				if imgui.CreateText(unpack(script.authors), "right", "link", true, u8 "Вконтакте") then
					os.execute(("explorer.exe \"%s\""):format("http://vk.com/eweest"))
				end
				imgui.CreateText(u8 "Актуальная версия:", "left", "disabled") imgui.SameLine() imgui.CreateText(script.version, "right", "text")
				imgui.CreateText(u8 "Дата последнего обновления:", "left", "disabled") imgui.SameLine() imgui.CreateText(script.description, "right", "text")
				if imgui.Checkbox(u8 "Автообновление " .. u8(data.update and "включено" or "отключено"), imgui_windows.checkbox.update) then
					data.update = not data.update
					isSaveChanges = true
				end
			imgui.EndChild()
			imgui.PopStyleColor(1)
			-- BLOCK 3 [END]
			if imgui.Button(isSaveChanges and u8"Были изменения, сохранить?" or u8"Настройки сохранены", imgui.ImVec2(200, 30)) then
				saveDataBase()
				isSaveChanges = false
			end
			imgui.CreateDescription(u8"Файл настроек находиться по пути:\n ..\\moonloader\\Trinity GTA Mods\\"..script.name)
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0, 0, 0, 0.2))
			if imgui.Button(u8"Закрыть", imgui.ImVec2(75, 30)) then -- Close button
				imgui_windows.main.v = false
			end
			if isSaveChanges then
				imgui.CreateDescription(u8"Сохраните настройки перед закрытием.")
			end
			imgui.PopStyleColor(1)
		imgui.EndChild()
		-- 
		imgui.BeginChild(u8 "##block_2", imgui.ImVec2(300, 80), true, imgui.WindowFlags.AlwaysUseWindowPadding)
			imgui.CreateText(u8 "Logo", "center", "disabled", true, u8 "Версия: 2.0")
			if imgui.CreateText(u8 "Trinity GTA Mods (c) 2022", "center", "link", true, u8 "Created with <3 by eweest") then
				os.execute(("explorer.exe \"%s\""):format("http://vk.com/gtatrinitymods"))
			end
			if imgui.CreateText(u8 "Нашли баг? Сообщите нам", "center", "link", true, u8 "Перейти в раздел для решения проблемы") then
				os.execute(("explorer.exe \"%s\""):format("https://vk.com/topic-213596631_49199291"))
			end
		imgui.EndChild()
		-- MENU [END]
		imgui.End()
	end
end

function createLogo()
	if not data[isServer].view or isKeyDown(0x77) then
		standartLogoHide = false
		sampTextdrawSetString(standartLogoID, "gta-trinity.com")
	else
		standartLogoHide = true
		sampTextdrawSetString(standartLogoID, " ")
	end

	local sizeX, sizeY = 256, 64
	local posX, posY = data[isServer].posX, data[isServer].posY 

	local logo_colors = {
		WHITE = "0xFFFFFFFF",
		BLACK = "0xFF000000",
		LIMEGREEN = "0xFF34CE34", -- RPG
		FIREBRICK = "0xFFB42224", -- RP1
		ORANGE = "0xFFFCA604", -- RP2
	}

	if isServer == "rpg" then colorGTA = logo_colors.LIMEGREEN
	elseif isServer == "rp1" then colorGTA = logo_colors.FIREBRICK
	elseif isServer == "rp2" then colorGTA = logo_colors.ORANGE
	end

	if data[isServer].view then
		if standartLogoHide then
			if data[isServer].style == 1 then
				renderDrawTexture(load_texture["logo-mods"], posX, posY, sizeX, sizeY, 0, logo_colors.WHITE) -- Logo Mods
			elseif data[isServer].style == 2 then
				renderDrawTexture(load_texture["logo-color"], posX, posY, sizeX, sizeY, 0, data[isServer].color) -- Logo Colored
			elseif data[isServer].style == 3 then
				renderDrawTexture(load_texture["logo-1"], posX, posY, sizeX, sizeY, 0, logo_colors.WHITE) -- logo White (Trinity)
				renderDrawTexture(load_texture["logo-2"], posX, posY, sizeX, sizeY, 0, colorGTA) -- Logo white (GTA)
			elseif data[isServer].style == 4 then
				renderDrawTexture(load_texture["logo-original"], posX, posY, sizeX, sizeY, 0, logo_colors.WHITE) -- logo Original (Trinity)
			end
			if data[isServer].newyearbg then
				renderDrawTexture(load_texture["logo-newyear"], posX, posY, sizeX, sizeY, 0, logo_colors.WHITE) -- Border
			end
		end
	end
end

-- ASSETS TOOLS
-- Send Message to Chat
function sendToChatMsg(text, typeMsg, sound)
	if sound then soundID = chatMsg[typeMsg].soundID else soundID = 0 end
	sampAddChatMessage(string.format("[%s]: {%s}%s", chatMsg.tag, chatMsg[typeMsg].colorText, text), chatMsg[typeMsg].color)
	addOneOffSound(0.0, 0.0, 0.0, soundID)
end

function changePosition()
	if setPosition then
		local cX, cY = getCursorPos()
		showCursor(true, true)
		data[isServer].posX, data[isServer].posY = cX- 100, cY- 20
		if isKeyDown(0x01) or isKeyDown(0x0D) then -- LMB or ENTER
			showCursor(false, false)
			sendToChatMsg(string.format("Положение изменено, сохраните настройки. Координаты X-Y:{FFCC00} %s-%s.", data[isServer].posX, data[isServer].posY), "warning", true)
			setPosition = false
		end
	end
end

function explodeARGB(argb)
  local a = bit.band(bit.rshift(argb, 24), 0xFF)
  local r = bit.band(bit.rshift(argb, 16), 0xFF)
  local g = bit.band(bit.rshift(argb, 8), 0xFF)
  local b = bit.band(argb, 0xFF)
  return a, r, g, b
end

function joinARGB(a, r, g, b)
  local argb = b
  argb = bit.bor(argb, bit.lshift(g, 8))
  argb = bit.bor(argb, bit.lshift(r, 16))
  argb = bit.bor(argb, bit.lshift(a, 24))
  return argb
end

function saveDataBase() -- Save for config file
	local file = io.open(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. SETTINGS_PATH, "w")
	file:write(encodeJson(data))
	file:flush()
	sendToChatMsg(string.format("Настройки ресурса {FFCC00}%s{FFFFFF} успешно сохранены.", script.name), "done", true)
	print("Файл настроек {FFCC00}\"" .. SETTINGS_PATH .. "\"{CCCCCC} успешно сохранен!")
	file:close()
end

function sampev.onShowTextDraw(id, data) -- Hook for find textdraw
	if data.text:find("gta%-trinity%.com") then
		standartLogoID = id
		return {id, data}
	end
end

-- AUTO-UPDATE (cred: qrlk / red: eweest)
function autoupdate(json_url, prefix, url)
	local dlstatus = require('moonloader').download_status
	local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
	if doesFileExist(json) then os.remove(json) end
	downloadUrlToFile(json_url, json,
	function(id, status, p1, p2)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			if doesFileExist(json) then
				local f = io.open(json, 'r')
				if f then
					local info = decodeJson(f:read('*a'))
					updatelink = info.updateurl
					updateversion = info.latest
					f:close()
					os.remove(json)
					if updateversion > thisScript().version then
						lua_thread.create(function()
						local dlstatus = require('moonloader').download_status
						sendToChatMsg(string.format("Найдено обновление для ресурса {FFCC00}%s.", script.name), "done", true)
						sendToChatMsg(string.format("Идет обновление c версии {FFCC00}%s{FFFFFF} на версию {FFCC00} %s.", script.version, updateversion), "done", false)
						wait(250)
							downloadUrlToFile(updatelink, thisScript().path, 
							function(id3, status1, p13, p23)
								if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
									print(string.format("Загружено %d из %d.", p13, p23))
								elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
									-- -- REMOVE FILES
									removeFilesCache()
									-- --
									print("{32FF32}Загрузка обновления завершена.")
									sendToChatMsg(string.format("Обновление ресурса {FFCC00}%s{FFFFFF} завершено!", script.name), "done", true)
									goupdatestatus = true 
									lua_thread.create(reloadScript()) -- RELOAD SCRIPT
								end
								if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
									if goupdatestatus == nil then
										sendToChatMsg("Ошибка обновления. Запуск старой версии...", "error", true)
										update = false
									end
								end
							end)
						end, prefix)
					else
						update = false
						print("{32FF32}v" .. thisScript().version .. ": Актуальная версия. {CCCCCC}Обновление не требуется.")
					end
				end
			else
				print("{FF3232}v" .. thisScript().version .. ": Не могу проверить обновление. {CCCCCC}Сообщите об этом в нашу группу.")
				update = false
			end
		end
	end)
	while update ~= false do wait(100) end
end
----

-- imGUI Functions
function imgui.CreateText(text, align, type, description, label)
	local width = imgui.GetWindowWidth()
	local size = imgui.CalcTextSize(text)

	if not align or align == "left" then imgui.CalcTextSize(text) end
	if align == "right" then imgui.SetCursorPosX(width - size.x - 15) end
	if align == "center" then imgui.SetCursorPosX(width/2 - size.x/2) end
	
	local cspos = imgui.GetCursorScreenPos()
	local cpos = imgui.GetCursorPos()
	local result = imgui.InvisibleButton(text, size)
	imgui.SetCursorPos(cpos)

	if not type or type == "text" then imgui.Text(text) end 
	if type == "disabled" then imgui.TextDisabled(text) end
	if type == "link" then 
		if imgui.IsItemHovered() then 
			imgui.TextDisabled(text)
			imgui.GetWindowDrawList():AddLine(imgui.ImVec2(cspos.x, cspos.y + size.y), imgui.ImVec2(cspos.x + size.x, cspos.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.TextDisabled])) 
		else 
			imgui.Text(text)
		end 
	end

	if description then
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.PushTextWrapPos(600)
			imgui.TextUnformatted(label)
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
		end
	end

	return result
end
-- 
function imgui.CreateDescription(text)
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(600)
		imgui.TextDisabled(u8"Подсказка:")
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end

function style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2
 
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.WindowPadding = ImVec2(10, 10)
	style.WindowRounding = 10
	style.FramePadding = ImVec2(10, 6)
	style.ItemSpacing = ImVec2(6, 8)
	style.ItemInnerSpacing = ImVec2(8, 6)
	style.IndentSpacing = 25
	style.ScrollbarSize = 15
	style.ScrollbarRounding = 15
	style.GrabMinSize = 15
	style.GrabRounding = 6
	style.ChildWindowRounding = 8
	style.FrameRounding = 8
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
 
	colors[clr.Text] = ImVec4(1, 1, 1, 1.00)
	colors[clr.TextDisabled] = ImVec4(1, 1, 1, 0.5)
	colors[clr.WindowBg] = ImVec4(0.12, 0.12, 1, 0)
	colors[clr.ChildWindowBg] = ImVec4(0.12, 0.12, 0.12, 1)
	colors[clr.TitleBgActive] = ImVec4(0.12, 0.12, 0.12, 1)
	colors[clr.TitleBg] = ImVec4(0.12, 0.12, 0.12, 0.8)
	-- colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 1)
	colors[clr.Button] = ImVec4(1, 1, 1, 0.16)
	colors[clr.ButtonHovered] = ImVec4(1, 1, 1, 0.08)
	colors[clr.ButtonActive] = ImVec4(1, 1, 1, 0.12)
	colors[clr.CloseButton] = ImVec4(1, 1, 1, 0.16)
	colors[clr.CloseButtonHovered] = ImVec4(1, 1, 1, 0.08)
	colors[clr.CloseButtonActive] = ImVec4(1, 1, 1, 0.12)
	colors[clr.ScrollbarBg] = ImVec4(0, 0, 0, 0.16)
	colors[clr.ScrollbarGrab] = ImVec4(1, 1, 1, 0.16)
	colors[clr.ScrollbarGrabHovered] = ImVec4(1, 1, 1, 0.08)
	colors[clr.ScrollbarGrabActive] = ImVec4(1, 1, 1, 0.12)
	colors[clr.SliderGrab] = ImVec4(1, 0.60, 0, 1)
	colors[clr.SliderGrabActive] = ImVec4(1, 0.60, 0, 0.6)
	colors[clr.FrameBg] = ImVec4(1, 1, 1, 0.08)
	colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
	colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 1)
	colors[clr.Border] = ImVec4(1, 1, 1, 0.1)
	colors[clr.CheckMark] = ImVec4(1, 1, 1, 1)
	-- colors[clr.CheckMarkHovered] = ImVec4(1, 1, 1, 1)
	colors[clr.Separator] = ImVec4(1, 1, 1, 0.08)
	-- colors[clr.BorderShadow] = ImVec4(0, 1, 1, 1)
	colors[clr.FrameBgHovered] = ImVec4(1, 1, 1, 0.16)
	colors[clr.FrameBgActive] = ImVec4(1, 1, 1, 0.12)
	-- colors[clr.MenuBarBg] = ImVec4(1, 1, 1, 1.00)
	-- colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.Header] = ImVec4(0, 0, 0, 0.16)
	colors[clr.HeaderHovered] = ImVec4(0, 0, 0, 0.4)
	colors[clr.HeaderActive] = ImVec4(0, 0, 0, 0.16)
	-- colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
	-- colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
	-- colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	-- colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
	-- colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
	-- colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
	-- colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	-- colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
	-- colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
style()

-- FUNC RELOAD SCRIPT
function reloadScript()
	lua_thread.create(function()
		wait(500) thisScript():reload()
	end)
end

-- FUNC UNLOAD SCRIPT
function unloadScript()
	lua_thread.create(function()
		thisScript():unload()
	end)
end

-- FUNC DELETE FILES CACHE
function removeFilesCache()
	for _, nameUrl in pairs(texture) do
		os.remove(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. TEXTURES_PATH .. nameUrl[1])
	end
	os.remove(DIRECT .. FOLDER_MAIN_PATH .. SCRIPT_FOLDER_PATH .. SETTINGS_PATH)
end