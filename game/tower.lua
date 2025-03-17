Tower = {}

function Tower:load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    towerImage = love.graphics.newImage("towerone.png")
    arrowImage = love.graphics.newImage("arrow.png")
    scaleX = 5
    scaleY = 5
    originalX = x
    originalY = y
    bulletSpeed = 2000
    towers = {}
    bullets = {}
    isHolding = false
end

function getEnemyScreenPosition(enemy)
    local tileSize = 80
    local screenX = (enemy.x - 1) * tileSize
    local screenY = (enemy.y - 1) * tileSize

    -- Adjust position based on enemy's movement progress
    if enemy.direction == "right" then
        screenX = screenX + enemy.progress * tileSize
    elseif enemy.direction == "left" then
        screenX = screenX - enemy.progress * tileSize
    elseif enemy.direction == "down" then
        screenY = screenY + enemy.progress * tileSize
    elseif enemy.direction == "up" then
        screenY = screenY - enemy.progress * tileSize
    end

    -- Get the correct enemy image based on direction
    local enemyImage
    if enemy.direction == "right" then
        enemyImage = enemyImageRight
    elseif enemy.direction == "left" then
        enemyImage = enemyImageLeft
    elseif enemy.direction == "up" then
        enemyImage = enemyImageUp
    elseif enemy.direction == "down" then
        enemyImage = enemyImageDown
    end

    -- Calculate the enemy's center position
    local enemyWidth = enemyImage:getWidth() * enemy.scaleX
    local enemyHeight = enemyImage:getHeight() * enemy.scaleY
    local enemyCenterX = screenX + enemyWidth / 2
    local enemyCenterY = screenY + enemyHeight / 2

    return enemyCenterX, enemyCenterY
end

function isEnemyInRadius(tower, enemy)
    local tileSize = 80

    local screenX = (enemy.x - 1) * tileSize
    local screenY = (enemy.y - 1) * tileSize

    if enemy.direction == "right" then
        screenX = screenX + enemy.progress * tileSize
    elseif enemy.direction == "left" then
        screenX = screenX - enemy.progress * tileSize
    elseif enemy.direction == "down" then
        screenY = screenY + enemy.progress * tileSize
    elseif enemy.direction == "up" then
        screenY = screenY - enemy.progress * tileSize
    end

    screenX = screenX + enemy.offset
    screenY = screenY - enemy.offset

    local dx = tower.x - screenX
    local dy = tower.y - screenY

    local distance = math.sqrt(dx * dx + dy * dy)
    return distance <= tower.radius
end

function furthestEnemyInRadius(tower, enemies)
    local maxDistance = -1
    local furthestEnemy = nil

    for i = #enemies, 1, -1 do 
        local enemy = enemies[i]
        if isEnemyInRadius(tower, enemy) then
            if enemy.distance > maxDistance then
                maxDistance = enemy.distance
                furthestEnemy = enemy
            end
        end
    end  

    return furthestEnemy
end

function createTower(shootSpeed)
    return {
    shootSpeed = shootSpeed,
    draggable = true,
    canPlace = true,
    x = 0,
    y = 0,
    radius = 200,
    timer = 0,
    hierarchy = 0
    }
end

function createBullet(damage, x, y, dx, dy, speed, scale, angle)
    return {
        damage = damage,
        x = x,
        y = y,
        dx = dx,
        dy = dy,
        speed = speed,
        scale = scale,
        angle = angle
    }
end

function drawTower(tower)
    local towerWidth, towerHeight = towerImage:getWidth() * 5, towerImage:getHeight() * 5
    love.graphics.draw(towerImage, tower.x - towerWidth / 2, tower.y - towerHeight / 2, 0, scaleX, scaleY)

    local mouseX, mouseY = love.mouse.getPosition()
    local dx = tower.x - mouseX
    local dy = tower.y - mouseY
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance <= 100 then 
        if(tower.canPlace and isHolding == false) then
            love.graphics.setColor(1, 1, 1, 0.5) 
            love.graphics.circle("fill", tower.x, tower.y, tower.radius)
            love.graphics.setColor(1, 1, 1, 1) 
        end
    end
end

function updateTower(tower, dt)
    if tower.draggable then
        local tileSize = 80

        tower.x, tower.y = love.mouse.getPosition()
        placeX = (math.ceil((tower.x) / tileSize) * tileSize) - 40
        placeY = (math.ceil((tower.y - 40) / tileSize) * tileSize)
        adjustedPlaceX = ((placeX - 40) / tileSize) + 1
        adjustedPlaceY = (placeY / tileSize) + 1

        if placeX ~= nil and placeY ~= nil and adjustedPlaceX ~= nil and adjustedPlaceY ~= nil then
            tower.x = placeX
            tower.y = placeY
            
            if(map[adjustedPlaceY][adjustedPlaceX] ~= 0) then
                tower.canPlace = false
            else
                tower.canPlace = true
            end
    
            if love.mouse.isDown(1) and tower.draggable then
                tower.x = placeX
                tower.y = placeY
                if tower.canPlace then
                    tower.draggable = false
                    isHolding = false
              end
            end
        end

        tower.hierarchy = tower.y
    end

    tower.timer = tower.timer + dt

    if tower.timer >= tower.shootSpeed and tower.draggable == false then
        local targetEnemy = furthestEnemyInRadius(tower, enemies)
        if targetEnemy then
            -- Get the enemy's center position
            local targetX, targetY = getEnemyScreenPosition(targetEnemy)

            -- Calculate the direction vector from tower to enemy
            local dx = targetX - tower.x
            local dy = targetY - tower.y
            local distance = math.sqrt(dx * dx + dy * dy)

            -- Normalize the direction vector
            if distance > 0 then
                dx = dx / distance
                dy = dy / distance
            else
                dx, dy = 0, 0
            end

            -- Calculate the angle toward the enemy
            local angle = (math.atan2(dy, dx))

            -- Create a bullet with the calculated angle
            -- table.insert(bullets, {
            --     x = tower.x,
            --     y = tower.y,
            --     dx = dx,
            --     dy = dy,
            --     speed = bulletSpeed,
            --     scale = 5,
            --     angle = angle -- Store the angle for rotation
            -- })
            table.insert(bullets, createBullet(1, tower.x, tower.y, dx, dy, bulletSpeed, 5, angle))
            tower.timer = 0
        end
    end
end

function Tower:update(dt)
    for j = #enemies, 1, -1 do
        enemies[j].scaleX = 5
        enemies[j].scaleY = 5
    end

    for i = #towers, 1, -1 do
        updateTower(towers[i], dt)
    end

    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet.x = bullet.x + bullet.dx * bullet.speed * dt
        bullet.y = bullet.y + bullet.dy * bullet.speed * dt

        if bullet.x < 0 or bullet.x > love.graphics.getWidth() or
           bullet.y < 0 or bullet.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        else
            for j = #enemies, 1, -1 do
                local enemy = enemies[j]
                local tileSize = 80
                local enemyScreenX = (enemy.x - 1) * tileSize
                local enemyScreenY = (enemy.y - 1) * tileSize

                -- Adjust for movement progress and direction
                if enemy.direction == "right" then
                    enemyScreenX = enemyScreenX + enemy.progress * tileSize
                elseif enemy.direction == "left" then
                    enemyScreenX = enemyScreenX - enemy.progress * tileSize
                elseif enemy.direction == "down" then
                    enemyScreenY = enemyScreenY + enemy.progress * tileSize
                elseif enemy.direction == "up" then
                    enemyScreenY = enemyScreenY - enemy.progress * tileSize
                end

                -- Apply enemy's offset
                enemyScreenX = enemyScreenX + enemy.offset
                enemyScreenY = enemyScreenY - enemy.offset

                -- Check if bullet is inside enemy's hitbox
                if bullet.x >= enemyScreenX and bullet.x <= enemyScreenX + enemy.hitboxX and
                   bullet.y >= enemyScreenY and bullet.y <= enemyScreenY + enemy.hitboxY then
                    -- Deal damage
                    enemy.health = enemy.health - bullet.damage
                    if enemy.health <= 0 then
                        table.remove(enemies, j)
                    end
                    table.remove(bullets, i)
                    break -- Exit enemy loop after hit
                end
            end    
        end
    end
end

function Tower:draw()
    for i = #towers, 1, -1 do
        drawTower(towers[i])
    end

    for _, bullet in ipairs(bullets) do
        love.graphics.draw(
            arrowImage,
            bullet.x,
            bullet.y,
            bullet.angle, -- Use the stored angle for rotation
            bullet.scale,
            bullet.scale,
            arrowImage:getWidth() / 2, -- Center X
            arrowImage:getHeight() / 2 -- Center Y
        )
    end
end