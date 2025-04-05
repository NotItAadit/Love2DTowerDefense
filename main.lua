map = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {1, 1, "down", 0, "right", 1, "down", 0, "right", 1, "down", 0, "right", 1, "down", 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, "right", 1, "up", 0, "right", 1, "up", 0, "right", 1, "up", 0, 1, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, "down", 1, "left", 0, "down", 1, "left", 0, "down", 1, "left", 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {1, 1, "left", 0, "up", 1, "left", 0, "up", 1, "left", 0, "up", 1, "left", 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

require "enemy"
require "towersmenu"
require "tower"
push = require "push"
local gameWidth, gameHeight = 1580, 720
local windowWidth, windowHeight = love.window.getDesktopDimensions()
push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})


function love.load()
    Enemy:load()
    TowerMenu:load()
    Tower:load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    mapOne = love.graphics.newImage("towerdefensemapone.png")
    mapOneV2 = love.graphics.newImage("towerdefensemaponev2.png")
    background = mapOneV2
    backgroundScaleX = 5
    backgroundScaleY = 5
    scrollSpeed = 10
    tileSize = 5
    towers = {}
    drawYay = false
    mouseX, mouseY = 0, 0
    mouseDown = false
end

function love.update(dt)
    mouseX, mouseY = push:toGame(love.mouse.getPosition())
    Enemy:update(dt)
    TowerMenu:update(dt)
    Tower:update(dt) 
    -- if cursorY > 620 and towerInMenuY > - ((#towersInMenu - 4) * 180) - 20 then
    --     towerInMenuY = towerInMenuY - 1 * scrollSpeed
    -- elseif cursorY < 100 and towerInMenuY < 0 then
    --     towerInMenuY = towerInMenuY + 1 * scrollSpeed
    -- end

    if love.keyboard.isDown("down") and towerInMenuY > - ((#towersInMenu - 4) * 180) - 20 then
        towerInMenuY = towerInMenuY - 1 * scrollSpeed
    elseif love.keyboard.isDown("up") and towerInMenuY < 0 then
        towerInMenuY = towerInMenuY + 1 * scrollSpeed
    end
end 

function love.draw()
    push:start()
    
    if isHolding then
        love.graphics.setColor(1, 1, 1, 0.75)
    end

    -- love.graphics.setColor(0.8, 0.2, 0.2, 1)
    love.graphics.draw(background, 0, 0, 0, backgroundScaleX, backgroundScaleY)
    love.graphics.setColor(1, 1, 1, 1)

    Enemy:draw()
    TowerMenu:draw()
    Tower:draw()

    push:finish()
end

function love.keypressed(key)
    if key == "e" and isHolding == false then
        table.insert(towers, createTower(1, basicTowerImage, "archer", 2000))
        isHolding = true
    elseif key == "w" then
        table.insert(enemies, createEnemy(1, 2, 10))
    elseif key == "=" then
        enemySpeed = enemySpeed + 1
    elseif key == "-" then
        enemySpeed = enemySpeed - 1
    elseif key == "r" then
        if background == mapOne then
            background = mapOneV2
        else
            background = mapOne
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and isHolding == false then
        mouseDown = true

        for i=#towersInMenu, 1, -1 do 
            if towersInMenu[i].hovered == true then
                if towersInMenu[i].type == "archer" then
                    table.insert(towers, createTower(1, basicTowerImage, "archer", 1000))
                    isHolding = true
                    mousePressed = true
                elseif towersInMenu[i].type == "fire" then
                    table.insert(towers, createTower(1, fireTowerImage, "fire", 1000))
                    isHolding = true
                    mousePressed = true
                end
            end
        end
    end
end

function love.touchpressed(x, y, button, istouch, presses)
    if button == 1 and isHolding == false then
        mouseDown = true

        for i=#towersInMenu, 1, -1 do 
            if towersInMenu[i].hovered == true then
                if towersInMenu[i].type == "archer" then
                    table.insert(towers, createTower(1, basicTowerImage, "archer", 1000))
                    isHolding = true
                    mousePressed = true
                elseif towersInMenu[i].type == "fire" then
                    table.insert(towers, createTower(1, fireTowerImage, "fire", 1000))
                end
            end
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        mouseDown = false
    end
end

function love.touchreleased(x, y, button, istouch, presses)
    if button == 1 then
        mouseDown = false
    end
end
