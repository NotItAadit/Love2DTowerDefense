Tower = {}

function Tower:load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    basicTowerImage = love.graphics.newImage("towerone.png")
    fireTowerImage = love.graphics.newImage("towertwo.png")
    arrowImage = love.graphics.newImage("arrow.png")
    fireballImage = love.graphics.newImage("fireball.png")
    scaleX = 5
    scaleY = 5
    originalX = x
    originalY = y
    bullets = {}
    isHolding = false
    playShootAnimation = false
    shootAnimSpeed = 50
    towerAnimSpeed = 10
end

function getEnemyScreenPosition(enemy)
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

    local enemyWidth = enemyImage:getWidth() * enemy.scaleX
    local enemyHeight = enemyImage:getHeight() * enemy.scaleY
    local enemyCenterX = screenX + enemyWidth / 2
    local enemyCenterY = screenY + enemyHeight / 2

    return enemyCenterX, enemyCenterY
end

function isEnemyInRadius(tower, enemy)
    local enemyScreenX, enemyScreenY = getEnemyScreenPosition(enemy)
    local dx = tower.x - enemyScreenX
    local dy = tower.y - enemyScreenY
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance <= tower.radius
end

function getEnemyScreenPosition(enemy)
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

    local enemyWidth = enemyImage:getWidth() * enemy.scaleX
    local enemyHeight = enemyImage:getHeight() * enemy.scaleY
    local enemyCenterX = screenX + enemyWidth / 2
    local enemyCenterY = screenY + enemyHeight / 2

    return enemyCenterX, enemyCenterY
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

function createTower(shootSpeed, image, type, bulletSpeed, bulletImage)
    return {
    shootSpeed = shootSpeed,
    draggable = true,
    canPlace = true,
    x = 0,
    y = 0,
    scaleX = 5,
    scaleY = 5,
    scaleY,
    radius = 200,
    timer = 0,
    hierarchy = 0,
    image = image,
    type = type,
    bulletSpeed = bulletSpeed,
    bulletImage = bulletImage,
    animateOffset = 0
    }
end

function createBullet(damage, x, y, dx, dy, speed, scale, angle, bulletImage)
    return {
        damage = damage,
        x = x,
        y = y,
        dx = dx,
        dy = dy,
        speed = speed,
        scale = scale,
        angle = angle,
        bulletImage = bulletImage
    }
end

function drawTower(tower)
    local towerWidth, towerHeight = basicTowerImage:getWidth() * 5, basicTowerImage:getHeight() * 5

    if tower.canPlace == false then
        love.graphics.setColor(1, 0, 0, 0.5)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.draw(tower.image, tower.x - towerWidth - tower.animateOffset, tower.y - towerHeight - tower.animateOffset, 0, tower.scaleX, tower.scaleY)
    love.graphics.setColor(1, 1, 1, 1)

    if mouseX ~= nil and mouseY ~= nil then
        local dx = tower.x - towerWidth / 2 - mouseX
        local dy = tower.y - towerHeight / 2 - mouseY
        local distance = math.sqrt(dx * dx + dy * dy)
    

        if distance <= 100 then 
            if tower.canPlace and isHolding == false then
                love.graphics.setColor(1, 1, 1, 0.5) 
                love.graphics.circle("fill", tower.x - towerWidth / 2, tower.y - towerHeight / 2, tower.radius)
                love.graphics.setColor(1, 1, 1, 1) 
            end
        end
    end
    love.graphics.print(tostring(tower.timer), tower.x, tower.y)
end

function updateTower(tower, dt, index)
    tileSize = 80

    if mouseX ~= nil and mouseY ~= nil then
        mousePixelX = (math.ceil((mouseX) / tileSize) * tileSize)
        mousePixelY = (math.ceil((mouseY) / tileSize) * tileSize)
    end

    if tower.draggable then
        animateHolding(tower, dt)

        if mouseX ~= nil and mouseY ~= nil then
            tower.x = mousePixelX + 5
            tower.y = mousePixelY

                if map[mousePixelY / 80][mousePixelX / 80] ~= 0 then
                    tower.canPlace = false
                else
                    tower.canPlace = true
                end

                if tower.draggable then
                    if mouseDown == false then
                        tower.x = mousePixelX + love.math.random(-3, 3)
                        tower.y = mousePixelY
                        animateOffset = 0
                        tower.scaleX = 5
                        tower.scaleY = 5
                        if tower.canPlace then
                            tower.draggable = false
                            isHolding = false
                        else
                            table.remove(towers, index)
                            isHolding = false
                        end
                    end
                end
        end
    else
        if tower.scaleX < 5 then
            tower.scaleX = tower.scaleX + 0.1 * dt * towerAnimSpeed
            tower.scaleY = tower.scaleY + 0.1 * dt * towerAnimSpeed
        elseif tower.scaleX > 5 or tower.scaleY > 5 then
            tower.scaleX = 5
            tower.scaleY = 5
        end
    end

    tower.timer = tower.timer + dt

    local targetEnemy = furthestEnemyInRadius(tower, enemies)
    if tower.timer >= tower.shootSpeed and tower.draggable == false then
        if targetEnemy then
            local targetX, targetY = getEnemyScreenPosition(targetEnemy)
            local dx = (targetX + (targetEnemy.image:getWidth() / 2)) - tower.x
            local dy = (targetY + (targetEnemy.image:getWidth() / 2)) - tower.y
            local distance = math.sqrt(dx * dx + dy * dy)
            if distance > 0 then
                dx = dx / distance
                dy = dy / distance
            else
                dx, dy = 0, 0
            end
            local angle = (math.atan2(dy, dx))

            -- Actual SHOOTING
            if tower.type == "archer" then
                table.insert(bullets, createBullet(1, tower.x - basicTowerImage:getWidth() / 2, tower.y - basicTowerImage:getHeight() / 2, dx, dy, tower.bulletSpeed, 5, angle, arrowImage))
            elseif tower.type == "fire" then
                table.insert(bullets, createBullet(1.5, tower.x, tower.y, dx, dy, tower.bulletSpeed, 5, angle, fireballImage))
            end

            tower.timer = 0
            playShootAnimation = true
        end
    end
end


function Tower:update(dt)
    for j = #enemies, 1, -1 do
        enemies[j].scaleX = 5
        enemies[j].scaleY = 5
    end

    for i = #towers, 1, -1 do
        updateTower(towers[i], dt, i)
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
                enemyScreenX = enemyScreenX + enemy.xOffset
                enemyScreenY = enemyScreenY - enemy.yOffset

                -- Check if bullet is inside enemy's hitbox
                if bullet.x >= enemyScreenX and bullet.x <= enemyScreenX + enemy.hitboxX and
                   bullet.y >= enemyScreenY and bullet.y <= enemyScreenY + enemy.hitboxY then
                    -- Deal damage
                    enemy.health = enemy.health - bullet.damage
                    enemy.stunned = true
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
            bullet.bulletImage,
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

function animateShoot(tower, dt)
    if tower.scaleY > 4.5 and playShootAnimation then
        tower.scaleY = tower.scaleY - 0.1 * dt * shootAnimSpeed
    elseif tower.scaleY < 5 then  
        tower.scaleY = tower.scaleY + 0.1 * dt * shootAnimSpeed
        playShootAnimation = false
    end

    if tower.scaleY > 5 then
        tower.scaleY = 5
    end
end

function animateHolding(tower, dt)
    if shrink then
        tower.scaleX = tower.scaleX - 0.1 * dt * towerAnimSpeed
        tower.scaleY = tower.scaleY - 0.1 * dt * towerAnimSpeed
        tower.animateOffset = tower.animateOffset - 1 * dt * towerAnimSpeed
    else
        tower.scaleX = tower.scaleX + 0.1 * dt * towerAnimSpeed
        tower.scaleY = tower.scaleY + 0.1 * dt * towerAnimSpeed
        tower.animateOffset = tower.animateOffset + 1 * dt * towerAnimSpeed
    end

    if tower.scaleX <= 4.5 then
        tower.scaleX = 4.5
        tower.scaleY = 4.5
        shrink = false
    elseif tower.scaleX >= 5 then
        tower.scaleX = 5
        tower.scaleY = 5
        shrink = true
    end
end