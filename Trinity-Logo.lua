-- ABOUT SCRIPT
script_name("Trinity Logo")
script_version("1.2")
script_author("eweest")
script_url("https://vk.com/gtatrinitymods")

---- ASSETS [START]

-- LIB
local se = require("lib.samp.events")

-- CHAT
local TAG = "[Trinity Mods]: "
local CMD_HELP = "/logo"
local COLOR_CHAT = {
	["DONE"] = "0xFFCC00",
	["ERROR"] = "0xFF3232",
}

local loadTexture = {}
-- local td_posX, td_posY = sampTextdrawGetPos(499)
-- local sX, sY = convertGameScreenCoordsToWindowScreenCoords(td_posX, td_posY)

-- PATHS
local DIRECT = getWorkingDirectory()
local CONFIG_PATH = "/config/"
local FOLDER_MAIN_PATH = "Trinity GTA Mods/"
local FOLDER_PATH = thisScript().name .. "/"
local TEXTURES_PATH = "textures/"
local DB_PATH = "settings.json"
-- GIT-HUB PATH
local GIT_REP_AND_NAME = "Trinity-Logo"
local UPDATE_JSON_PATH = "https://raw.githubusercontent.com/eweest/" .. GIT_REP_AND_NAME .. "/main/update.json"
local UPDATE_FILE_PATH = "https://raw.githubusercontent.com/eweest/" .. GIT_REP_AND_NAME .. "/main/" .. GIT_REP_AND_NAME .. ".lua"


-- TEXTURES
local TEXTURES = {	-- NAME, URL
	-- LOGO TYPE 1 (COLOR)
	["LOGO_MODS"] = {"logo-mods.png", "https://i.ibb.co/D50j1RP/logo-mods.png"},
	["LOGO_W"] = {"logo-white.png", "https://i.ibb.co/tbtw1kW/logo-white.png"},
	["LOGO_TR1"] = {"logo-tr-1.png", "https://i.ibb.co/fQMnQYN/logo-tr-1.png"},
	["LOGO_TR2"] = {"logo-tr-2.png", "https://i.ibb.co/SKGc2g5/logo-tr-2.png"},
	["LOGO_GOLD"] = {"logo-gold.png", "https://i.ibb.co/YD0TZ4L/logo-gold.png"},
	-- BORDERS LOGO 
	["BORDER"] = {"border.png", "https://i.ibb.co/pyhSGWM/border.png"},
	["BORDER_ALT"] = {"border-alt.png", "https://i.ibb.co/QKB2DzH/border-alt.png"},
}

-- SOUNDS
local SOUNDS = {
	["ERROR"] = 1055,
	["DONE"] = 1083,
	["CANCEL"] = 1085
}

-- CONFIG "settings.json"
local CONFIG = { 
	["TYPE"] = 3,
	["posX"] = 110,
	["posY"] = 1020,
	["BORDER"] = false,
	["VIEW"] = true
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
	end
end

-- JSON PATH
if not doesFileExist(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. DB_PATH) then
	local file = io.open(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. DB_PATH, "w")
	file:write(encodeJson(CONFIG))
	io.close(file)
end

if doesFileExist(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. DB_PATH) then
	local file = io.open(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. DB_PATH, 'r')
	if file then
		DB = decodeJson(file:read("*a"))
		io.close(file)
	end
end
---- ASSETS [END]

-- MAIN [START]
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(20*1000) end
	-- CHECK UPDATE
	autoupdate(UPDATE_JSON_PATH, TAG, UPDATE_FILE_PATH)

	-- TRINITY SERVERS
	local IP = sampGetCurrentServerAddress()
	local TRINITYGTA_IP = {
		["RPG"] = "185.169.134.83",
		["RP1"] = "185.169.134.84",
		["RP2"] = "185.169.134.85"
	}
	-- CHECK TRINITY SERVERS
	if IP:find(TRINITYGTA_IP["RPG"]) or IP:find(TRINITYGTA_IP["RP1"]) or IP:find(TRINITYGTA_IP["RP2"]) then
		-- LOAD TEXTURES
		for TEXTURE, PATH in pairs(TEXTURES) do
			local TEXTURE_PATH = ( DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH )

			loadTexture[TEXTURE] = renderLoadTextureFromFile(TEXTURE_PATH .. PATH[1])
		end
		--
		TRINITYGTA = true
		sampAddChatMessage(TAG .. thisScript().name .."{FFFFFF} запущен. Автор: {FFCC00}eweest{FFFFFF}. Версия: {FFCC00}" .. thisScript().version .. "{FFFFFF}. Помощь {FFCC00}" .. CMD_HELP, COLOR_CHAT["DONE"])
		-- CHECK TEXTDRAW COLOR
		_, _, TD_COLOR = sampTextdrawGetLetterSizeAndColor(499)
	else
		TRINITYGTA = false 
		sampAddChatMessage(TAG .. "{FFFFFF}Скрипт " .. thisScript().name .. " (v" .. thisScript().version .. ") не запущен, так как вы игрыете не на Trinity GTA.", COLOR_CHAT["DONE"])
	end


	-- COMMANDS
	sampRegisterChatCommand("logo", function(cmd) -- HELP
		if (cmd == "position" or cmd == "pos") then -- POSITION
			sampAddChatMessage(TAG .. "{FFFFFF}Для сохранения, нажмите {FFCC00}Левую Кнопку Мыши {FFFFFF}или{FFCC00} ENTER.", COLOR_CHAT["DONE"])
			setPosition = true

		elseif (cmd == "type 1") then -- TYPE 1
			if (DB["TYPE"] ~= 1) then
				DB["TYPE"] = 1
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа изменен. Вариант: {FFCC00} 1.", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
			else
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа {FFCC00}1{FFFFFF} уже используется!", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
			end
			saveDataBase()
		elseif (cmd == "type 2") then -- TYPE 2
			if (DB["TYPE"] ~= 2) then
				DB["TYPE"] = 2
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа изменен. Вариант: {FFCC00} 2.", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
			else
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа {FFCC00}2{FFFFFF} уже используется!", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
			end
			saveDataBase()
		elseif (cmd == "type 3") then -- TYPE 3
			if (DB["TYPE"] ~= 3) then
				DB["TYPE"] = 3
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа изменен. Вариант: {FFCC00} 3.", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
			else
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа {FFCC00}3{FFFFFF} уже используется!", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
			end
			saveDataBase()
		elseif (cmd == "type 4") then -- TYPE 4
			if (DB["TYPE"] ~= 4) then
				DB["TYPE"] = 4
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа изменен. Вариант: {FFCC00} 4.", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
			else
				sampAddChatMessage(TAG .."{FFFFFF}Стиль логотипа {FFCC00}4{FFFFFF} уже используется!", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
			end
			saveDataBase()
		elseif (cmd == "border" or cmd == "b") then -- BORDER
			if DB["TYPE"] <= 4 then
				DB["BORDER"] = not DB["BORDER"]
				if DB["BORDER"] then
					addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
					sampAddChatMessage(TAG .."{FFFFFF}Обводка логотипа {32FF32}включена.", COLOR_CHAT["DONE"])
					DB["BORDER"] = true
				else
					addOneOffSound(0.0, 0.0, 0.0, SOUNDS["CANCEL"])	
					sampAddChatMessage(TAG .."{FFFFFF}Обводка логотипа {FF3232}отключена.", COLOR_CHAT["DONE"])
					DB["BORDER"] = false
				end
			else
				sampAddChatMessage(TAG .."{FFFFFF}Обводка логотипа доступна только в стиле {FFCC00}1-4{FFFFFF}.", COLOR_CHAT["DONE"])
			end
			saveDataBase()
		elseif (cmd == "view" or cmd == "vw") then -- VIEW MODE
			DB["VIEW"] = not DB["VIEW"]
			if DB["VIEW"] then
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["DONE"])
				sampAddChatMessage(TAG .."{FFFFFF}Логотип {32FF32}включен.", COLOR_CHAT["DONE"])
				DB["VIEW"] = true
			else
				addOneOffSound(0.0, 0.0, 0.0, SOUNDS["CANCEL"])	
				sampAddChatMessage(TAG .."{FFFFFF}Логотип {FF3232}отключен.", COLOR_CHAT["DONE"])
				DB["VIEW"] = false
			end
			saveDataBase()
		elseif #cmd == 0 then -- OPEN HELP MENU
			cmdHelpCMD()
			addOneOffSound(0.0, 0.0, 0.0, 1139)
		else -- ERROR COMMAND
			addOneOffSound(0.0, 0.0, 0.0, SOUNDS["ERROR"])
			sampAddChatMessage(TAG .."{FFFFFF}Неизвестная команда. Введите {FFCC00}" .. CMD_HELP, COLOR_CHAT["ERROR"])
		end
	end)

-- BODY [START]
	while true do wait(0)
		-- SET POSITION
		if setPosition then
		local posX, posY = getCursorPos()
			showCursor(true, true)
			DB["posX"], DB["posY"] = posX-100, posY-20
			renderDrawBoxWithBorder(DB["posX"]-10, DB["posY"]-10, 180, 68, 0x3300FF00, 10, 0xAAFF0000) -- MOVE BORDER

			if isKeyDown(0x01) or isKeyDown(0x0D) then -- LMB or ENTER
				showCursor(false, false)
				sampAddChatMessage(TAG .. "{FFFFFF}Положение логотипа - сохранено.", COLOR_CHAT["DONE"])
				addOneOffSound(0.0, 0.0, 0.0, 1057)
				setPosition = false
				saveDataBase()
			end
		end
		-- 
		if TRINITYGTA == true then
			--| CREATE LOGO
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
	local posX, posY = DB["posX"], DB["posY"]

	local COLORS = {
		["WHITE"] = "0xFFFFFFFF",
		["GTA"] = "0xFFFFFFFF",
		["BLACK"] = "0xFF000000",
		["FIREBRICK"] = "0XFFB42224", -- RP1
		["ORANGE"] = "0XFFfca604", -- RP2
		["LimeGreen"] = "0XFF34CE34", -- RPG
	}


	-- local _, _, TD_COLOR = sampTextdrawGetLetterSizeAndColor(499) -- #b42224
	-- sampAddChatMessage(TAG .. TD_COLOR, COLOR_CHAT["DONE"])

	if TD_COLOR == 4289864226 then
		COLORS["GTA"] = COLORS["FIREBRICK"] 
	elseif TD_COLOR == 4281649444 then
		COLORS["GTA"] = COLORS["LimeGreen"] 
	elseif TD_COLOR == 4294940945 then
		COLORS["GTA"] = COLORS["ORANGE"] 
	end

	if DB["VIEW"] == true then
		-- if DB["TYPE"] then
			if DB["BORDER"] == true and DB["TYPE"] == 1 then
				renderDrawTexture(loadTexture["BORDER_ALT"], posX, posY, sizeX, sizeY, 0, COLORS["BLACK"]) -- BORDER ALT
			else
				if DB["BORDER"] == true and DB["TYPE"] > 1 then
					renderDrawTexture(loadTexture["BORDER"], posX, posY, sizeX, sizeY, 0, COLORS["BLACK"]) -- BORDER
				end
			end

			if DB["TYPE"] == 1 then
				renderDrawTexture(loadTexture["LOGO_MODS"], posX, posY, sizeX, sizeY, 0, COLORS["WHITE"]) -- LOGO MODS
			elseif DB["TYPE"] == 2 then
				renderDrawTexture(loadTexture["LOGO_W"], posX, posY, sizeX, sizeY, 0, COLORS["WHITE"]) -- LOGO WHITE
			elseif DB["TYPE"] == 3 then
				renderDrawTexture(loadTexture["LOGO_TR1"], posX, posY, sizeX, sizeY, 0, COLORS["WHITE"]) -- LOGO GREEN
				renderDrawTexture(loadTexture["LOGO_TR2"], posX, posY, sizeX, sizeY, 0, COLORS["GTA"]) -- LOGO GREEN
			elseif DB["TYPE"] == 4 then
				renderDrawTexture(loadTexture["LOGO_GOLD"], posX, posY, sizeX, sizeY, 0, COLORS["WHITE"]) -- LOGO GOLD
			end
		end
	end
-- CREATE TEXTURES [END]

--| HELP WINDOW [START]
local TITLE = "Помощь по: {FFFFFF}"
local TITLE_COLOR = "{AFE7FF}"
local TEXT_CMD = [[
{ffcc00}Основные команды:{ffffff}

{AFE7FF}/logo{ffffff} - Окно помощи
{AFE7FF}/logo (pos)ition{ffffff} - Изменение позиции
{AFE7FF}/logo type [1-4]{ffffff} - Изменение стиля
{AFE7FF}/logo (b)order{ffffff} - Показать/Скрыть обводку
{AFE7FF}/logo view/(vw){ffffff} - Показать/Скрыть

{ffcc00}Полезные советы:{ffffff}
{AFE7FF}[1]{ffffff} При замене лого на свое, используйте размер {ffcc00}160x48{ffffff} пикселя.
{AFE7FF}[2]{ffffff} В стиле #3 "GTA" менят цвет в зависимости от сервера на котором вы играете.

{ffcc00}О скрипте:{ffffff}

{AFE7FF}Название (Версия){ffffff}		TRINITY Logo (v1.2)
{AFE7FF}Дата последнего обновления{ffffff}	01.06.2022
{AFE7FF}Автор скрипта{ffffff}			eweest
{AFE7FF}Наше сообщество{ffffff}			vk.com/gtatrinitymods
]]


function cmdHelpCMD()
	sampShowDialog(10001, TITLE_COLOR .. TITLE .. thisScript().name, TEXT_CMD, "X")
end
--| HELP WINDOW [END]

-- DELETE LOGO [START]
function se.onShowTextDraw(id, data)
	if data.text:find("gta%-trinity.ru") or data.text:find("gta%-trinity.ru")then
		data.text = ""
		sampTextdrawDelete(id)
		return {id, data}
	end
end
-- DELETE LOGO [STOP]

-- SAVE DATABASE
function saveDataBase()
	local file = io.open(DIRECT .. CONFIG_PATH .. FOLDER_MAIN_PATH .. FOLDER_PATH .. DB_PATH, "w")
	file:write(encodeJson(DB))
	file:close()
end
----

-- AUTO-UPDATE (cred: qrlk)
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
            if updateversion ~= thisScript().version then
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
                      print("Загрузка обновления завершена.")
                      sampAddChatMessage((prefix .. "{FFFFFF}Обновление {FFCC00}" .. thisScript().name .. "{FFFFFF} завершено!"), COLOR_CHAT["DONE"])
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix .. "Ошибка {FFFFFF}обновления. {FF3232}Код ошибки: #1. {FFFFFF}Запуск старой версии."), COLOR_CHAT["ERROR"])
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v' .. thisScript().version .. ": Обновление не требуется.")
            end
          end
        else
          print('v' .. thisScript().version .. ": Не могу проверить обновление. Смиритесь или проверьте самостоятельно на "..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end
----