TowerMenu = {}

function TowerMenu:load()
    self.towersMenu = love.graphics.newImage("towersmenu.png")
    self.data = love.image.newImageData("towersmenu.png")
    self.basicTowerImage = love.graphics.newImage("towerone.png")
    self.fireTowerImage = love.graphics.newImage("towertwo.png")
    self.originalX = 1280
    self.x = self.originalX
    self.y = 0
    towerInMenuY = 0
    self.width = self.towersMenu:getWidth()
    self.height = self.towersMenu:getHeight()
    towerMenuHovered = false
    self.menuExtended = true
    self.speed = 20
    scrollY = 0

    towersInMenu = {}
    self:createTower(self.basicTowerImage, "archer")
    self:createTower(self.fireTowerImage, "fire")
    self:createTower(self.basicTowerImage)
    self:createTower(self.basicTowerImage)
    self:createTower(self.basicTowerImage)
    self:createTower(self.basicTowerImage)
end

function TowerMenu:update(dt)
    self.mouseX, self.mouseY = love.mouse.getPosition()

    for i=#towersInMenu, 1, -1 do
        TowerMenu:updateTower(towersInMenu[i], i, dt)
    end
end

function TowerMenu:draw()
    love.graphics.draw(self.towersMenu, self.x, self.y, 0, 5, 5)

    for i = #towersInMenu, 1, -1 do
        self:drawTower(towersInMenu[i], i)
    end
end

function TowerMenu:createTower(towerImage, type)
    local tower = {
        image = towerImage,
        x = (self.x + (self.width * 5) / 2 - (towerImage:getWidth() * 5) / 2),
        y = (self.y + (self.height * 5) / 2 - (towerImage:getHeight() * 5) / 2),
        scaleX = 10,
 
        scaleY = 10,
        hovered = false,
        width = towerImage:getWidth(),
        height = towerImage:getHeight(),
        type = type
    }
    table.insert(towersInMenu, tower)
end

function TowerMenu:drawTower(tower, index)
    love.graphics.draw(tower.image, tower.x, tower.y, 0, tower.scaleX, tower.scaleY)  
end

function TowerMenu:updateTower(tower, index, dt) 
    if mouseX ~= nil and mouseY ~= nil and mouseX > tower.x and mouseX < (tower.x + tower.width*5) and mouseY > tower.y and mouseY < (tower.y + tower.height*5) then
        tower.hovered = true
    else
        tower.hovered = false
    end

    tower.x = self.x + (self.width * 5) / 2 - (tower.image:getWidth() * 5) / 2 + 30
    tower.y = towerInMenuY + (180 * (index - 1)) + 20
    tower.scaleX = 5.5
    tower.scaleY = 5.5
end