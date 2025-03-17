require("enemy")
require("towersmenu")
require("tower")

map = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
    {1, 1, "down", 0, "right", 1, "down", 0, "right", 1, "down", 0, "right", 1, "down", 2},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 2},
    {0, 0, "right", 1, "up", 0, "right", 1, "up", 0, "right", 1, "up", 0, 1, 2},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2},
    {0, 0, "down", 1, "left", 0, "down", 1, "left", 0, "down", 1, "left", 0, 1, 2},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 2},
    {1, 1, "left", 0, "up", 1, "left", 0, "up", 1, "left", 0, "up", 1, "left", 2},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2}
}

function love.load()
    Enemy:load()
    TowerMenu:load()
    Tower:load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    background = love.graphics.newImage("towerdefensemapone.png")
    backgroundScaleX = 5
    backgroundScaleY = 5
    scrollSpeed = 10
    tileSize = 5
end

function love.update(dt)
    cursorX, cursorY = love.mouse.getPosition()
    Enemy:update(dt)
    TowerMenu:update(dt)
    Tower:update(dt) 
    if cursorY > 620 and towerInMenuY > - ((#towersInMenu - 4) * 180) - 20 then
        towerInMenuY = towerInMenuY - 1 * scrollSpeed
    elseif cursorY < 100 and towerInMenuY < 0 then
        towerInMenuY = towerInMenuY + 1 * scrollSpeed
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, backgroundScaleX, backgroundScaleY)
    Enemy:draw()
    TowerMenu:draw()
    Tower:draw()
end

function love.keypressed(key)
    if key == "e" and isHolding == false then
        table.insert(towers, createTower(1))
        isHolding = true
    elseif key == "w" then
        table.insert(enemies, createEnemy(1, 2, 3))
    elseif key == "=" then
        enemySpeed = enemySpeed + 1
    elseif key == "-" then
        enemySpeed = enemySpeed - 1
    end
end