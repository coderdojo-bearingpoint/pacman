-- -- -- -- -- --
-- COMMON --
-- -- -- -- -- --

-- game settings --
local gameMode
local delta

-- resolution --
local screenX
local screenY
local offsetX
local offsetY
local areaX = 1000
local areaY = 800
local activeResolution
local numerOfResolutions

-- sound --
local sound
local soundText

-- debug --
local debugMode
local debugModeText

-- buttons --
local isEscPressed
local isSpacePressed
local isEnterPressed
local isUpPressed
local isDownPressed
local isLeftPressed
local isRightPressed

-- fonts --
local fontBig
local fontMedium
local fontSmall

-- images --

-- game variables --


function loadStuff()
	fontBig = love.graphics.newFont(48)
	fontMedium = love.graphics.newFont(36)
	fontSmall = love.graphics.newFont(14)

	resetMenu()

	createResolutions()
	changeResolution(1)

	sound = false
	changeSoundSetting()
	debugMode = false
	changeDebugSetting()

	love.keyboard.setKeyRepeat(true)
end

-- game settings functions --

function createResolutions()
	-- creates a table of accepted resolutions --
	resolutions = {}

	resolutions[1] = {}
	resolutions[1].x = 1440
	resolutions[1].y = 900
	resolutions[1].name = "1440x900"

	resolutions[2] = {}
	resolutions[2].x = 1600
	resolutions[2].y = 900
	resolutions[2].name = "1600x900"

	resolutions[3] = {}
	resolutions[3].x = 1680
	resolutions[3].y = 1050
	resolutions[3].name = "1680x1050"

	resolutions[4] = {}
	resolutions[4].x = 1920
	resolutions[4].y = 1080
	resolutions[4].name = "1920x1800"

	resolutions[5] = {}
	resolutions[5].x = 2560
	resolutions[5].y = 1440
	resolutions[5].name = "2560x1440"

	numerOfResolutions = 5
end


function changeResolution(res)
	-- changes resolution --
	love.window.setMode(resolutions[res].x, resolutions[res].y, {fullscreen=true, fullscreentype="normal"})
	offsetX = (resolutions[res].x - areaX) / 2
	offsetY = (resolutions[res].y - areaY) / 2
	activeResolution = res
end

function white()
	love.graphics.setColor(255, 255, 255, 255)
end

function red()
	love.graphics.setColor(255, 0, 0, 255)
end

function blue()
	love.graphics.setColor(0, 0, 255, 255)
end

function greenAlpha()
	love.graphics.setColor(0, 255, 0, 127)
end

function yellowAlpha()
	love.graphics.setColor(255, 255, 0, 127)
end

function redAlpha()
	love.graphics.setColor(255, 0, 0, 127)
end

function changeSoundSetting()
	if sound then
		sound = false
		soundText = "Off"
	else
		sound = true
		soundText = "On"
	end
end

function changeDebugSetting()
	if debugMode then
		debugMode = false
		debugModeText = "Off"
	else
		debugMode = true
		debugModeText = "On"
	end
end




-- -- -- -- -- --
-- MENU --
-- -- -- -- -- --

local menuBgR = 0
local menuBgG = 0
local menuBgB = 0

local menuMode
local menuActive

local menuTimer
local menuEnabled
local menuPositions = 4

function resetMenu()
	menuActive = 1
	menuTimer = 0
	menuEnabled = false
end

-- DRAW FUNCTIONS --

function drawArea()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle("line", offsetX, offsetY, areaX, areaY)
end

function drawMenu()
	if menuMode == "main" then
		drawMainMenu()
	end
	if menuMode == "settings" then
		drawSettings()
	end
	if menuMode == "credits" then
		drawCredits()
	end
	drawGameDebugInfo()
end

function drawMainMenu()
	drawArea()
	love.graphics.setBackgroundColor(menuBgR, menuBgG, menuBgB)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(fontBig)
	love.graphics.print("PACMAN 0.1 alpha", offsetX+160, offsetY+100)
	love.graphics.setFont(fontMedium)
	if menuActive == 1 then red() else white() end
	love.graphics.print("NEW GAME", offsetX+200, offsetY+300)
	if menuActive == 2 then red() else white() end
	love.graphics.print("GAME SETTINGS", offsetX+200, offsetY+350)
	if menuActive == 3 then red() else white() end
	love.graphics.print("CREDITS", offsetX+200, offsetY+400)
	if menuActive == 4 then red() else white() end
	love.graphics.print("QUIT", offsetX+200, offsetY+450)
	--love.graphics.print("Press space to continue", 700, 465)
end

function drawSettings()
	drawArea()
	love.graphics.setBackgroundColor(menuBgR, menuBgG, menuBgB)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(fontBig)
	love.graphics.print("PACMAN 0.2 alpha", offsetX+160, offsetY+100)
	love.graphics.setFont(fontMedium)
	white()
	love.graphics.print("RESOLUTION", offsetX+200, offsetY+300)
	love.graphics.print("SOUND", offsetX+200, offsetY+350)
	love.graphics.print("DEV MODE", offsetX+200, offsetY+400)
	if menuActive == 1 then red() else white() end
	love.graphics.print(tostring(resolutions[activeResolution].name), offsetX+450, offsetY+300)
	if menuActive == 2 then red() else white() end
	love.graphics.print(tostring(soundText), offsetX+450, offsetY+350)
	if menuActive == 3 then red() else white() end
	love.graphics.print(tostring(debugModeText), offsetX+450, offsetY+400)
	if menuActive == 4 then red() else white() end
	love.graphics.print("SAVE", offsetX+450, offsetY+450)
end

function drawCredits()
	drawArea()
	love.graphics.setBackgroundColor(menuBgR, menuBgG, menuBgB)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(fontBig)
	love.graphics.print("PACMAN 0.1 alpha", offsetX+160, offsetY+100)
	love.graphics.setFont(fontMedium)
	love.graphics.print("CREDITS", offsetX+200, offsetY+300)
	love.graphics.print("Game by Pawel Blach", offsetX+200, offsetY+400)
	love.graphics.print("Press space", offsetX+200, offsetY+500)
end

-- UPDATE FUNCTIONS --

function menuTimerWait()
	if menuTimer > 0.2 then
		menuEnabled = true
	else
		menuEnabled = false
	end
end

function menuTimerAdd()
	menuTimer = menuTimer + delta
end

function updateMenu()
	menuTimerWait()
	if isEscPressed then
		if menuEnabled then
			love.event.push( 'quit' )
		end
	end
	if menuMode == "main" then
		updateMainMenu()
	end
	if menuMode == "settings" then
		updateSettings()
	end
	if menuMode == "credits" then
		updateCredits()
	end
	if isUpPressed and (menuActive > 1) then
		if menuEnabled then
			menuActive = menuActive - 1
			menuTimer = 0
		end
	end
	if isDownPressed and (menuActive < menuPositions) then
		if menuEnabled then
			menuActive = menuActive + 1
			menuTimer = 0
		end
	end
	menuTimerAdd()
end

function updateMainMenu()
	if isEnterPressed and menuEnabled then
		if menuActive == 1 then
			initGame()
		end
		if menuActive == 2 then
			menuMode = "settings"
			menuPositions = 4
			resetMenu()
		end
		if menuActive == 3 then
			menuMode = "credits"
			resetMenu()
		end
		if menuActive == 4 then
			love.event.push( 'quit' )
		end
	end
end

function updateSettings()
	if isEnterPressed and menuEnabled then
		if menuActive == 1 then
			if activeResolution < numerOfResolutions then
				activeResolution = activeResolution + 1
			else
				activeResolution = 1
			end
			menuTimer = 0
		end
		if menuActive == 2 then
			changeSoundSetting()
			menuTimer = 0
		end
		if menuActive == 3 then
			changeDebugSetting()
			menuTimer = 0
		end
		if menuActive == 4 then
			changeResolution(activeResolution)
			menuPositions = 4
			resetMenu()
			menuMode = "main"
		end
	end
end

function updateCredits()
	if isSpacePressed then
		resetMenu()
		menuPositions = 4
		menuMode = "main"
	end
end



-- -- -- -- -- --
-- GAME --
-- -- -- -- -- --

local pacman
local mapSizeX
local mapSizeY
local gridSize = 24
local gridX = 28
local gridY = 31
local gridOffsetX
local gridOffsetY

function initPacman()
	pacman = {}
	pacman.mapX = 4
	pacman.mapY = 8
	pacman.x = pacman.mapX * gridSize + gridSize * 0.5
	pacman.y = pacman.mapY * gridSize + gridSize * 0.5
	pacman.speed = 10
	pacman.direction = 4
	pacman.nextDirection = 4
	pacman.movement = 0
end

function initMap()
	map = {}
	for i = 0, gridX, 1 do
		map[i] = {}
		for j = 0, gridY, 1 do
			map[i][j] = false
		end
	end
end

function initGame()
	gameMode = "game"
	initPacman()
	initMap()
	gridOffsetX = (areaX * 0.5) - (gridX * gridSize * 0.5) + offsetX
	gridOffsetY = (areaY * 0.5) - (gridY * gridSize * 0.5) + offsetY
end

-- DRAW FUNCTIONS --

function drawGameDebugInfo()
	if debugMode then
		local debug_counter = 1
		local debug_offset = 15
		white()
		love.graphics.setFont(fontSmall)
   		love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, debug_counter*debug_offset)
   		if sound then
   			debug_counter = debug_counter + 1
   			love.graphics.print("Sound: On", 10, debug_counter*debug_offset)
   		end
   		if isUpPressed then
   			debug_counter = debug_counter + 1
   			love.graphics.print("Up pressed", 10, debug_counter*debug_offset)
   		end
   		if isDownPressed then
   			debug_counter = debug_counter + 1
   			love.graphics.print("Down pressed", 10, debug_counter*debug_offset)
   		end
   		if isLeftPressed then
   			debug_counter = debug_counter + 1
   			love.graphics.print("Left pressed", 10, debug_counter*debug_offset)
   		end
   		if isRightPressed then
   			debug_counter = debug_counter + 1
   			love.graphics.print("Right pressed", 10, debug_counter*debug_offset)
   		end
	end
	
end

function drawGrid()
	if debugMode then
		for i = 0, gridY, 1 do
			red()
			love.graphics.rectangle("fill", gridOffsetX, gridOffsetY+(i*gridSize), gridSize*gridX, 1)
			if (i < gridY) then
				white()
				love.graphics.setFont(fontSmall)
	   			love.graphics.print(tostring(i), gridOffsetX-20, gridOffsetY+(i*gridSize)+5)
	   		end
		end
		for i = 0, gridX, 1 do
			red()
			love.graphics.rectangle("fill", gridOffsetX+(i*gridSize), gridOffsetY, 1, gridSize*gridY)
			if (i < gridX) then
				white()
				love.graphics.setFont(fontSmall)
	   			love.graphics.print(tostring(i), gridOffsetX+(i*gridSize)+5, gridOffsetY-20)
	   		end
		end
	end
end

function drawPacman()
	--
	drawPacmanDebug()
end

function drawPacmanDebug()
	if debugMode then
		local debug_counter = 1
		local debug_offset = 15
		white()
		love.graphics.setFont(fontSmall)
   		love.graphics.print("Pacman mapY: "..tostring(pacman.mapY), 10, (resolutions[activeResolution].y - debug_counter * debug_offset))
   		debug_counter = debug_counter + 1
   		love.graphics.print("Pacman mapX: "..tostring(pacman.mapX), 10, (resolutions[activeResolution].y - debug_counter * debug_offset))
   		yellowAlpha()
   		love.graphics.rectangle("fill", pacman.mapX * gridSize + gridOffsetX, pacman.mapY * gridSize + gridOffsetY, gridSize, gridSize)
	end
end

function drawMaze()
	drawMazeDebug()
end

function drawMazeDebug()
	if debugMode then
		blue()
		--
	end
end


function drawGame()
	drawMaze()
	drawPacman()
	drawGrid()
	drawGameDebugInfo()
end

-- UPDATE FUNCTIONS --

function updatePacman()
	if isUpPressed then
		pacman.nextDirection = 1
	end
	if isDownPressed then
		pacman.nextDirection = 3
	end
	if isLeftPressed then
		pacman.nextDirection = 4
	end
	if isRightPressed then
		pacman.nextDirection = 2
	end
end

function updateGame()
	if isEscPressed == true then
		love.event.push( 'quit' )
	end
end





-- LUA DEFAULT FUNCTIONS --

function love.load()
	loadStuff()
	gameMode = "menu"
	menuMode = "main"
end

function love.draw()
   	if gameMode == "menu" then
   		drawMenu()
   	end
   	if gameMode == "game" then
   		drawGame()
   	end   	
end

function love.update(dt)
	delta = dt
	if gameMode == "menu" then
		updateMenu()
	end
	if gameMode == "game" then
		updateGame()
	end
end

function love.focus(bool)
end

function love.keypressed( key, unicode )
	if key == "escape" then
		isEscPressed = true
	end
	if key == " " then
		isSpacePressed = true
	end
	if key == "return" then
		isEnterPressed = true
	end
	if key == "up" then
		isUpPressed = true
	end
	if key == "down" then
		isDownPressed = true
	end
	if key == "left" then
		isLeftPressed = true
	end
	if key == "right" then
		isRightPressed = true
	end
end

function love.keyreleased( key, unicode )
	if key == "escape" then
		isEscPressed = false
	end
	if key == " " then
		isSpacePressed = false
	end
	if key == "return" then
		isEnterPressed = false
	end
	if key == "up" then
		isUpPressed = false
	end
	if key == "down" then
		isDownPressed = false
	end
	if key == "left" then
		isLeftPressed = false
	end
	if key == "right" then
		isRightPressed = false
	end
end

function love.quit()
end