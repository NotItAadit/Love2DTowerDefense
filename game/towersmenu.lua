TowerMenu = {}

function TowerMenu:load()
    self.towersMenu = love.graphics.newImage("towersmenu.png")
    self.data = love.image.newImageData("towersmenu.png")
    self.basicTowerImage = love.graphics.newImage("towerone.png") -- Consider using a different image for the tower
    self.originalX = 1200
    self.x = self.originalX
    self.y = 0
    towerInMenuY = 0
    self.mouseX = 0
    self.mouseY = 0
    self.width = self.towersMenu:getWidth()
    self.height = self.towersMenu:getHeight()
    self.isHovered = false
    self.menuExtended = true
    self.speed = 20
    scrollY = 0

    towersInMenu = {}
    self:createTower(self.basicTowerImage)
    self:createTower(self.basicTowerImage)
    self:createTower(self.basicTowerImage)
    self:createTower(self.basicTowerImage)
    self:createTower(self.basicTowerImage)
    self:createTower(self.basicTowerImage)
end

function TowerMenu:update(dt)
    self.mouseX, self.mouseY = love.mouse.getPosition()
    self.isHovered = self.mouseX >= self.x

    for i=#towersInMenu, 1, -1 do
        TowerMenu:updateTower(towersInMenu[i], dt)
    end
end

function TowerMenu:draw()
    love.graphics.draw(self.towersMenu, self.x, self.y, 0, 5, 5)

    if self.isHovered then
        if self.x > (love.graphics.getWidth() - self.width * 5) then
            self.x = self.x - self.speed
        end
    else
        if self.x < self.originalX then
            self.x = self.x + self.speed
        end
    end

    for i = #towersInMenu, 1, -1 do
        self:drawTower(towersInMenu[i], i)
    end

    love.graphics.print(tostring(#towers), 0, 0)
end

function TowerMenu:createTower(towerImage)
    local tower = {
        image = towerImage,
        x = (self.x + (self.width * 5) / 2 - (towerImage:getWidth() * 5) / 2),
        y = (self.y + (self.height * 5) / 2 - (towerImage:getHeight() * 5) / 2),
        scaleX = 5.5,
        scaleY = 5.5,
        hovered = false,
        width = towerImage:getWidth(),
        height = towerImage:getHeight(),
    }
    table.insert(towersInMenu, tower)
end

function TowerMenu:drawTower(tower, index)
    if tower.hovered == true then
        tower.x = (self.x + (self.width * 5) / 2 - (tower.image:getWidth() * 5) / 2) - (0.5 * tileSize) + 30
        tower.y = (towerInMenuY + (180 * (index - 1)) + 20) - (0.5 * tileSize)
        tower.scaleX = 6
        tower.scaleY = 6
    else
        tower.x = self.x + (self.width * 5) / 2 - (tower.image:getWidth() * 5) / 2 + 30
        tower.y = towerInMenuY + (180 * (index - 1)) + 20
        tower.scaleX = 5.5
        tower.scaleY = 5.5
    end

    love.graphics.draw(tower.image, tower.x, tower.y, 0, tower.scaleX, tower.scaleY)
    love.graphics.print(tostring(tower.hovered), tower.x, tower.y)
end

function TowerMenu:updateTower(tower, dt) 
    local mouseX, mouseY = love.mouse.getPosition()
    if mouseX > tower.x and mouseX < (tower.x + tower.width*5) and mouseY > tower.y and mouseY < (tower.y + tower.height*5) then
        tower.hovered = true
    else
        tower.hovered = false
    end
end