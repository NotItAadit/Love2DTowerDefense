Enemy = {}

function Enemy:load()
    enemies = {}
    enemySpeed = 1;
    love.graphics.setDefaultFilter("nearest", "nearest")
    enemyImageRight = love.graphics.newImage("slime.png")
    enemyImageDown = love.graphics.newImage("slimefront.png")
    enemyImageUp = love.graphics.newImage("slimeup.png")
    enemyImageLeft = love.graphics.newImage("slimeleft.png")
    enemyImage = enemyImageRight
end

function Enemy:update(dt)
    for i=#enemies, 1, -1 do
        updateEnemy(enemies[i], dt)
    end
end

function Enemy:draw()
    for i=#enemies, 1, -1 do
        drawEnemy(enemies[i])
    end
end

function updateEnemy(enemy, dt)
    local nextX, nextY = enemy.x, enemy.y
    if enemy.direction == "right" then
        nextX = nextX + 1
    elseif enemy.direction == "left" then
        nextX = nextX - 1
    elseif enemy.direction == "up" then
        nextY = nextY - 1
    elseif enemy.direction == "down" then
        nextY = nextY + 1
    end

    if nextX >= 1 and nextX <= #map[1] and nextY >= 1 and nextY <= #map then
        local nextTile = map[nextY][nextX]
        if nextTile ~= 0 then
            enemy.progress = enemy.progress + enemySpeed * dt
            if enemy.progress >= 1 then
                enemy.x = nextX
                enemy.y = nextY
                enemy.progress = 0
                enemy.distance = enemy.distance + 1

                if nextTile == "right" then
                    enemy.direction = "right"
                elseif nextTile == "left" then
                    enemy.direction = "left"
                elseif nextTile == "up" then
                    enemy.direction = "up"
                elseif nextTile == "down" then
                    enemy.direction = "down"
                end
            end
        else
            table.remove(enemies, enemy)
        end
    end

    if enemy.health <= 0 then
        table.remove(enemies, enemy)
    end
end

function drawEnemy(enemy)
    local tileSize = 80
    local x = (enemy.x - 1) * tileSize + enemy.progress * tileSize * (enemy.direction == "right" and 1 or enemy.direction == "left" and -1 or 0)
    local y = ((enemy.y - 1) * tileSize + enemy.progress * tileSize * (enemy.direction == "down" and 1 or enemy.direction == "up" and -1 or 0))
    if(enemy.direction == "right") then
        enemyImage = enemyImageRight
    elseif(enemy.direction == "left") then  
        enemyImage = enemyImageLeft
    elseif(enemy.direction == "up") then
        enemyImage = enemyImageUp
    elseif(enemy.direction == "down") then
        enemyImage = enemyImageDown
    end
    love.graphics.draw(enemyImage, x + enemy.offset, y - enemy.offset, 0, enemy.scaleX, enemy.scaleY)
    love.graphics.rectangle("line", x, y, enemy.hitboxX, enemy.hitboxY)
    love.graphics.print(#enemies, 0, 20)
    love.graphics.print(enemySpeed, 0, 60)
end

function createEnemy(x, y, health)
    return {
        x = x,
        y = y,
        health = health,
        direction = "right",
        speed = enemySpeed,
        progress = 0,
        offset = 0,
        distance = 0,
        scaleX = 5,
        scaleY = 5,
        hitboxX = enemyImage:getWidth() * 5,
        hitboxY = enemyImage:getHeight() * 5,
    }
end