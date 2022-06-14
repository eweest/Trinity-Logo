-- ABOUT SCRIPT
script_name("Trinity Logo")
script_version("1.4")
script_author("eweest")
script_description("14.06.2022")
script_url("vk.com/gtatrinitymods")

---- ASSETS [START]

-- LIB
local sampev = require("lib.samp.events")

-- CHAT
local TAG = "[Trinity Mods]: "
local CMD_HELP = "/logo"
local COLOR_CHAT = {
	["DONE"] = "0xFFCC00",
	["ERROR"] = "0xFF3232",
}

local TRINITYGTA_IP = {
	["RPG"] = "185.169.134.83",
	["RP1"] = "185.169.134.84",
	["RP2"] = "185.169.134.85"
}

local loadTexture = {}

-- PATHS
local DIRECT = getWorkingDirectory()
local CONFIG_PATH = "/config/"
local FOLDER_MAIN_PATH = "Trinity GTA Mods/"
local FOLDER_PATH = thisScript().name .. "/"
local TEXTURES_PATH = "textures/"
local DB_PATH = "settings.json"
-- GIT-HUB PATH
local GIT_REP_AND_NAME = "Trinity-Logo"
local UPDATE_JSON_PATH = "https://raw.githubusercontent.com/eweest/" .. GIT_REP_AND_NAME .. "/main/assets/update.json"
local UPDATE_FILE_PATH = "https://raw.githubusercontent.com/eweest/" .. GIT_REP_AND_NAME .. "/main/" .. GIT_REP_AND_NAME .. ".lua"

-- TEXTURES
local TEXTURES = {	-- NAME, URL
	-- LOGO TYPE 1 (COLOR)
	["LOGO_MODS"] = {"logo-mods.png", "https://github.com/eweest/Trinity-Logo/raw/main/assets/textures/logo-mods.png"},
	["LOGO_W"] = {"logo-white.png", "https://github.com/eweest/Trinity-Logo/raw/main/assets/textures/logo-white.png"},
	["LOGO_TR1"] = {"logo-tr-1.png", "https://github.com/eweest/Trinity-Logo/raw/main/assets/textures/logo-tr-1.png"},
	["LOGO_TR2"] = {"logo-tr-2.png", "https://github.com/eweest/Trinity-Logo/raw/main/assets/textures/logo-tr-2.png"},
	["LOGO_GOLD"] = {"logo-gold.png", "https://github.com/eweest/Trinity-Logo/raw/main/assets/textures/logo-gold.png"},
	-- BORDERS LOGO 
	["BORDER"] = {"border.png", "https://github.com/eweest/Trinity-Logo/raw/main/assets/textures/border.png"},
	["BORDER_ALT"] = {"border-alt.png", "https://github.com/eweest/Trinity-Logo/raw/main/assets/textures/border-alt.png"},
}
-- FONTS
local FONTS = {
	["BARS"] = renderCreateFont("Arial", 8, 5),
	["NUMBER"] = renderCreateFont("Pricedown Rus", 32, 4),
	["NUMBER-1"] = renderCreateFont("Arial", 14, 5),
}
-- SOUNDS
local SOUNDS = {
	["ERROR"] = 1055,
	["DONE"] = 1083,
	["CANCEL"] = 1085
}

-- CONFIG "settings.json"
local CONFIG = { 
	["RPG"] = {
		["TYPE"] = 3,
		["posX"] = 130,
		["posY"] = 1030,
		["BORDER"] = false,
		["VIEW"] = true,
		["COLOR"] = "FFFFFF"
	},
	["RP1"] = {
		["TYPE"] = 3,
		["posX"] = 130,
		["posY"] = 1030,
		["BORDER"] = false,
		["VIEW"] = true,
		["COLOR"] = "FFFFFF"
	},
	["RP2"] = {
		["TYPE"] = 3,
		["posX"] = 130,
		["posY"] = 1030,
		["BORDER"] = false,
		["VIEW"] = true,
		["COLOR"] = "FFFFFF"
	},

	["AUTOUPDATE"] = false
}


-- SCRIPT FOLDER
if not doesDirectoryExist(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH) then
	createDirectory(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH)
end
-- TEXTURES FOLDER
if not doesDirectoryExist(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH) then
	createDirectory(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH)
end

-- TEXTURES DOWNLOAD
for TEXTURE, NAME_URL in pairs(TEXTURES) do
	if not doesFileExist(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. NAME_URL[1]) then
		downloadUrlToFile(NAME_URL[2], DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. NAME_URL[1])
		print("Текстура успешно загружены! Название:{FFCC00}" .. NAME_URL[1]) -- DEBUG
	end
end

-- JSON PATH
	if not doesFileExist(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. DB_PATH) then -- Create "Settings" file
		local file = io.open(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. DB_PATH, "w")
		file:write(encodeJson(CONFIG))
		io.close(file)

		print("{FF3232}[ERROR]{CCCCCC} Файл настроек {FFCC00}'" .. DB_PATH .. "'{CCCCCC} не найден!") -- DEBUG
	end

	if doesFileExist(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. DB_PATH) then -- Read "Settings" file
		local file = io.open(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. DB_PATH, 'r')
		if file then
			DB = decodeJson(file:read("*a"))
			io.close(file)
		end

		print("Файл настроек {FFCC00}'" .. DB_PATH .. "'{CCCCCC} успешно загружен!") -- DEBUG
	end
---- ASSETS [END]

-- MAIN [START]
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	-- CHECK UPDATE
	if DB["AUTOUPDATE"] then
		DB["AUTOUPDATE"] = true
		autoupdate(UPDATE_JSON_PATH, TAG, UPDATE_FILE_PATH)
	else
		print("Автообновление Отключено.")
	end

	-- TRINITY SERVERS
	local IP = sampGetCurrentServerAddress()

	-- CHECK ALL TRINITY SERVERS
	if IP:find(TRINITYGTA_IP["RPG"]) or IP:find(TRINITYGTA_IP["RP1"]) or IP:find(TRINITYGTA_IP["RP2"]) then
		-- LOAD TEXTURES
		for TEXTURE, PATH in pairs(TEXTURES) do
			local TEXTURE_PATH = ( DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH )

			loadTexture[TEXTURE] = renderLoadTextureFromFile(TEXTURE_PATH .. PATH[1])
		end
		-- CHECK TRINITY SERVERS
		if IP:find(TRINITYGTA_IP["RPG"]) then
			GET_SERVER = "RPG"
		elseif IP:find(TRINITYGTA_IP["RP1"]) then
			GET_SERVER = "RP1"
		elseif IP:find(TRINITYGTA_IP["RP2"]) then
			GET_SERVER = "RP2" 
		end
		--
		TRINITYGTA = true
		sampAddChatMessage(TAG .. thisScript().name .."{FFFFFF} запущен. Автор: {FFCC00}eweest{FFFFFF}. Версия: {FFCC00}" .. thisScript().version .. "{FFFFFF}. Помощь {FFCC00}" .. CMD_HELP, COLOR_CHAT["DONE"])
	else
		TRINITYGTA = false 
		sampAddChatMessage(TAG .. "{FFFFFF}Скрипт {FFCC00}" .. thisScript().name .. " (v" .. thisScript().version .. ") {FFFFFF}не запущен, так как вы играете не на Trinity GTA.", COLOR_CHAT["DONE"])
		unloadScript()
	end

	-- COMMANDS
	sampRegisterChatCommand("logo", function(cmd) -- HELP
		-- TYPES
		if (cmd == "type 1") then -- TYPE 1
			if (DB[GET_SERVER]["TYPE"] ~= 1) then
				DB[GET_SERVER]["TYPE"] = 1
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа изменен. Стиль: {FFCC00} #1.", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
			else
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа {FFCC00}#1{FFFFFF} уже используется!", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
			end
			saveDB()
		elseif (cmd == "type 2") then -- TYPE 2
			if (DB[GET_SERVER]["TYPE"] ~= 2) then
				DB[GET_SERVER]["TYPE"] = 2
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа изменен. Стиль: {FFCC00} #2.", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
			else
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа {FFCC00}#2{FFFFFF} уже используется!", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
			end
			saveDB()
		elseif (cmd == "type 3") then -- TYPE 3
			if (DB[GET_SERVER]["TYPE"] ~= 3) then
				DB[GET_SERVER]["TYPE"] = 3
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа изменен. Стиль: {FFCC00} #3.", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
			else
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа {FFCC00}#3{FFFFFF} уже используется!", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
			end
			saveDB()
		elseif (cmd == "type 4") then -- TYPE 4
			if (DB[GET_SERVER]["TYPE"] ~= 4) then
				DB[GET_SERVER]["TYPE"] = 4
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа изменен. Стиль: {FFCC00} #4.", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
			else
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа {FFCC00}#4{FFFFFF} уже используется!", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
			end
			saveDB()
		elseif (cmd == "border" or cmd == "b") then -- BORDER
			if DB[GET_SERVER]["TYPE"] <= 4 then
				DB[GET_SERVER]["BORDER"] = not DB[GET_SERVER]["BORDER"]
				if DB[GET_SERVER]["BORDER"] then
					addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
					sampAddChatMessage(TAG .."{FFFFFF}Обводка логотипа {32FF32}включена.", COLOR_CHAT["DONE"])
					DB[GET_SERVER]["BORDER"] = true
				else
					addOneOffSound(0.0, 0.0, 0.0, SOUNDS["CANCEL"])	
					sampAddChatMessage(TAG .."{FFFFFF}Обводка логотипа {FF3232}отключена.", COLOR_CHAT["DONE"])
					DB[GET_SERVER]["BORDER"] = false
				end
			else
				sampAddChatMessage(TAG .."{FFFFFF}Обводка логотипа доступна только в стиле {FFCC00}#1-4{FFFFFF}.", COLOR_CHAT["DONE"])
			end
			saveDB()
		elseif (cmd == "view" or cmd == "vw") then -- VIEW MODE
			DB[GET_SERVER]["VIEW"] = not DB[GET_SERVER]["VIEW"]
			if DB[GET_SERVER]["VIEW"] then
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
				sampAddChatMessage(TAG .."{FFFFFF}Логотип {32FF32}включен.", COLOR_CHAT["DONE"])
				DB[GET_SERVER]["VIEW"] = true
			else
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["CANCEL"])	
				sampAddChatMessage(TAG .."{FFFFFF}Логотип {FF3232}отключен.", COLOR_CHAT["DONE"])
				DB[GET_SERVER]["VIEW"] = false
			end
		saveDB()
		elseif (cmd == "update" or cmd == "up") then -- UPDATE
			DB["AUTOUPDATE"] = not DB["AUTOUPDATE"]
			if DB["AUTOUPDATE"] then
				DB["AUTOUPDATE"] = true
				sampAddChatMessage(TAG .."{FFFFFF}Автообновление {32FF32}включено{FFFFFF}.", COLOR_CHAT["DONE"])
			else
				DB["AUTOUPDATE"] = false
				sampAddChatMessage(TAG .."{FFFFFF}Автообновление {FF3232}отключено{FFFFFF}.", COLOR_CHAT["DONE"])
			end
			saveDB()
			reloadScript()

		elseif (cmd == "reset") then -- RESET SETTINGS
			os.remove(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. DB_PATH)
			addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
			sampAddChatMessage(string.format("%s{FFFFFF}Файл с настройками {FFCC00}%s {FF3232}сброшен{FFFFFF}.", TAG, DB_PATH), COLOR_CHAT["DONE"])
			reloadScript()

		elseif #cmd == 0 then -- OPEN HELP MENU
			createWindowHelp()
			addOneOffSound(0.0, 0.0, 0.0, 1139)
		else
			if cmd:find("^type") then -- ERROR TYPE
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
				sampAddChatMessage(TAG .."{FFFFFF}Вы ввели некорректно команду. Введите: {FFCC00}" .. CMD_HELP .. " type (1-4)", COLOR_CHAT["ERROR"])
			elseif cmd ~= "" or cmd ~= nil then
				local cX, cY = cmd:match("(%d+)[^%d]+(%d+)")
				if cmd:find("^pos") and cmd:len("%l") then -- CHANGE POSITION
					if cX ~= nil and cX ~= "" and cY ~= nil and cY ~= "" then
						DB[GET_SERVER]["posX"] = tonumber(cX)
						DB[GET_SERVER]["posY"] = tonumber(cY)
						sampAddChatMessage(TAG .. "{FFFFFF}Положение логотипа сохранено. Координаты X-Y{FFCC00} " .. cX .. "-" .. cY .. "px", COLOR_CHAT["DONE"])
						addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
					else
						setPosition = true
						sampAddChatMessage(TAG .. "{FFFFFF}Для сохранения, нажмите {FFCC00}Левую Кнопку Мыши {FFFFFF}или{FFCC00} ENTER.", COLOR_CHAT["DONE"])
						sampAddChatMessage(TAG .. "{FFFFFF}Информация: Чтобы переместить по координатам. Введите {FFCC00}" .. CMD_HELP .. " (pos)ition X-Y", COLOR_CHAT["DONE"])
					end
					saveDB()
				end
				local COLOR = cmd:match("color (%w+)")
				if cmd:find("^color") and (DB[GET_SERVER]["TYPE"] == 2) then -- CHANGE COLOR
					if COLOR ~= nil and COLOR ~= "" and COLOR:len() == 6 then
						DB[GET_SERVER]["COLOR"] = COLOR
						addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
						sampAddChatMessage(string.format("%s{FFFFFF}Цвет логотипа изменен. Цвет [ {%s}#%s{FFFFFF} ]", TAG, COLOR, COLOR), COLOR_CHAT["DONE"])
					else
						addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
						sampAddChatMessage(string.format("%s{FFFFFF}Вы ввели некорректно команду, либо код цвета. Введите: {FFCC00}%s color FFFFFF", TAG, CMD_HELP), COLOR_CHAT["ERROR"])
					end
					saveDB()
				elseif cmd:find("^color") and (DB[GET_SERVER]["TYPE"] ~= 2) then
					addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
					sampAddChatMessage(string.format("%s{FFFFFF}Цвет логотипа можно менять только во {FFCC00}#2{FFFFFF} стиле.", TAG), COLOR_CHAT["ERROR"])
				end
			else -- ERROR CMD
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
				sampAddChatMessage(TAG .."{FFFFFF}Неизвестная команда. Введите {FFCC00}" .. CMD_HELP, COLOR_CHAT["ERROR"])
			end
		end
	end)

-- BODY [START]
	while true do wait(0)
		-- SET POSITION
		if setPosition then
		local curX, curY = getCursorPos()
			showCursor(true, true)
			DB[GET_SERVER]["posX"], DB[GET_SERVER]["posY"] = curX - 100, curY - 20

			if isKeyDown(0x01) or isKeyDown(0x0D) then -- LMB or ENTER
				showCursor(false, false)
				sampAddChatMessage(TAG .. "{FFFFFF}Положение логотипа сохранено. Координаты X-Y{FFCC00} " .. DB[GET_SERVER]["posX"] .. "-" .. DB[GET_SERVER]["posY"] .. "px", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, 1057)
				setPosition = false
				saveDB()
			end
		end

		if TRINITYGTA == true then
			-- CREATE LOGO
			local spawnPlayer = sampIsLocalPlayerSpawned()
			if spawnPlayer then								
				createLogo()
			end
		end
	end

-- BODY [END]
	wait(-1)
end
-- MAIN [END]

-- CREATE TEXTURES [START]
function createLogo()
	local sizeX, sizeY = 160, 48
	local posX, posY = DB[GET_SERVER]["posX"], DB[GET_SERVER]["posY"]

	local ALPHA = "0xFF"
	local SETCOLOR = DB[GET_SERVER]["COLOR"]

	local COLORS = {
		["WHITE"] = "0xFFFFFFFF",
		["GTA"] = "0xFFFFFFFF",
		["BLACK"] = "0xFF000000",
		["LimeGreen"] = "0XFF34CE34", -- RPG
		["FIREBRICK"] = "0XFFB42224", -- RP1
		["ORANGE"] = "0XFFFCA604", -- RP2
	}

	if GET_SERVER == "RPG" then
		COLORS["GTA"] = COLORS["LimeGreen"] 
	elseif GET_SERVER == "RP1" then
		COLORS["GTA"] = COLORS["FIREBRICK"] 
	elseif GET_SERVER == "RP2" then
		COLORS["GTA"] = COLORS["ORANGE"] 
	end

	if DB[GET_SERVER]["VIEW"] then
		-- if DB["TYPE"] then
			if DB[GET_SERVER]["BORDER"] == true and DB[GET_SERVER]["TYPE"] == 1 then
				renderDrawTexture(loadTexture["BORDER_ALT"], posX, posY, sizeX, sizeY, 0, COLORS["BLACK"]) -- BORDER ALT
			else
				if DB[GET_SERVER]["BORDER"] == true and DB[GET_SERVER]["TYPE"] > 1 then
					renderDrawTexture(loadTexture["BORDER"], posX, posY, sizeX, sizeY, 0, COLORS["BLACK"]) -- BORDER
				end
			end

			if DB[GET_SERVER]["TYPE"] == 1 then
				renderDrawTexture(loadTexture["LOGO_MODS"], posX, posY, sizeX, sizeY, 0, COLORS["WHITE"]) -- LOGO MODS
			elseif DB[GET_SERVER]["TYPE"] == 2 then
				renderDrawTexture(loadTexture["LOGO_W"], posX, posY, sizeX, sizeY, 0, ALPHA .. SETCOLOR) -- LOGO WHITE
			elseif DB[GET_SERVER]["TYPE"] == 3 then
				renderDrawTexture(loadTexture["LOGO_TR1"], posX, posY, sizeX, sizeY, 0, COLORS["WHITE"]) -- LOGO GREEN
				renderDrawTexture(loadTexture["LOGO_TR2"], posX, posY, sizeX, sizeY, 0, COLORS["GTA"]) -- LOGO GREEN
			elseif DB[GET_SERVER]["TYPE"] == 4 then
				renderDrawTexture(loadTexture["LOGO_GOLD"], posX, posY, sizeX, sizeY, 0, COLORS["WHITE"]) -- LOGO GOLD
			end
		end
	end
-- CREATE TEXTURES [END]

-- HELP WINDOW [START]
local TITLE = "Помощь по: {FFFFFF}"
local TITLE_COLOR = "{AFE7FF}"
local TEXT_CMD = [[
{ffcc00}Основные команды:{ffffff}

{AFE7FF}/logo{ffffff} - Окно помощи
{AFE7FF}/logo (pos)ition/ (pos)ition [X-Y]{ffffff} - Изменение позиции мышью/ по координатам X-Y
{AFE7FF}/logo type [1-4]{ffffff} - Изменение стиля
{AFE7FF}/logo (b)order{ffffff} - Показать/Скрыть обводку
{AFE7FF}/logo color [HEX]{ffffff} - Установить цвет в формате HEX (прим. FF00FF)
{AFE7FF}/logo view (vw){ffffff} - Показать/Скрыть
{AFE7FF}/logo reset{ffffff} - Сброс всех настроек
{AFE7FF}/lgoo (up)date{ffffff} - Автообновление (Включить/Выключить)

{ffcc00}Полезные советы:{ffffff}

{AFE7FF}[1]{ffffff} При замене лого на свое, используйте размер {ffcc00}160x48{ffffff} пикселя.
{AFE7FF}[2]{ffffff} В стиле #3 "GTA" менят цвет в зависимости от сервера на котором вы играете.

{ffcc00}О скрипте:{ffffff}

{AFE7FF}Автор скрипта{ffffff}				eweest
]]

if DB["AUTOUPDATE"] == true then
	text = "{32FF32}Включено"
else
	text = "{FF3232}Отключено"
end

local TEXT_NAME = "{AFE7FF}Название скрипта (Версия){ffffff}			" .. thisScript().name .. "{AFE7FF} [" .. thisScript().version .. "]"
local TEXT_URL = "{AFE7FF}Наше сообщество{ffffff}				" .. thisScript().url
local TEXT_DATE = "{AFE7FF}Дата последнего обновления{ffffff}		" .. thisScript().description
local TEXT_UPDATE = "{AFE7FF}Автообновление{ffffff}				" .. text
--
function createWindowHelp()
	sampShowDialog(10001, TITLE_COLOR .. TITLE .. thisScript().name, string.format("%s%s\n%s\n%s\n%s", TEXT_CMD, TEXT_URL, TEXT_NAME, TEXT_DATE, TEXT_UPDATE), "X")
end
-- HELP WINDOW [END]

-- DELETE LOGO [START]
function sampev.onShowTextDraw(id, data)
	if data.text:find("gta%-trinity.ru") or data.text:find("gta%-trinity.ru")then
		data.text = ""
		sampTextdrawDelete(id)
		return {id, data}
	end
end
-- DELETE LOGO [STOP]

-- SAVE DATABASE
function saveDB()
	local file = io.open(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. DB_PATH, "w")
	file:write(encodeJson(DB))
	file:flush()
	print("Файл настроек {FFCC00}'" .. DB_PATH .. "'{CCCCCC} успешно сохранен!")
	file:close()
end

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
						lua_thread.create(function(prefix)
						local dlstatus = require('moonloader').download_status
						sampAddChatMessage((prefix .. "{FFFFFF}Найдено обновление для скрипта {FFCC00}" .. thisScript().name .. "."), COLOR_CHAT["DONE"])
						sampAddChatMessage((prefix .. "{FFFFFF}Идет обновление c версии {FFCC00}" .. thisScript().version .. "{FFFFFF} на версию {FFCC00}" .. updateversion), COLOR_CHAT["DONE"])
						wait(250)
							downloadUrlToFile(updatelink, thisScript().path, 
							function(id3, status1, p13, p23)
								if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
									print(string.format("Загружено %d из %d.", p13, p23))
								elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
									-- REMOVE FILES
									for TEXTURE, NAME_URL in pairs(TEXTURES) do
										os.remove(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. NAME_URL[1])
									end
									os.remove(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH)
									--
									print("{32FF32}Загрузка обновления завершена.")
									sampAddChatMessage((prefix .. "{FFFFFF}Обновление {FFCC00}" .. thisScript().name .. "{FFFFFF} завершено!"), COLOR_CHAT["DONE"])
									goupdatestatus = true 
									lua_thread.create(reloadScript()) -- RELOAD SCRIPT
								end
								if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
									if goupdatestatus == nil then
										sampAddChatMessage((prefix .. "Ошибка {FFFFFF}обновления. Запуск старой версии..."), COLOR_CHAT["ERROR"])
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