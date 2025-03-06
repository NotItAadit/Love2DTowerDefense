TowerMenu = {}

function TowerMenu:load()
    self.towersMenu = love.graphics.newImage("towersmenu.png")
    self.data = love.image.newImageData("towersmenu.png")
    self.originalX = 1200
    self.x = self.originalX
    self.y = 0
    self.mouseX = 0
    self.mouseY = 0
    self.width = self.towersMenu:getWidth()
    self.height = self.towersMenu:getHeight()
    self.isHovered = false
    self.menuExtended = true
    self.speed = 20
end

function TowerMenu:update(dt)
    self.mouseX, self.mouseY = love.mouse.getPosition()
    self.isHovered = self.mouseX >= self.x
end

function TowerMenu:draw()
    love.graphics.draw(self.towersMenu, self.x, self.y, 0, 5, 5)
    love.graphics.print(self.mouseX, 0, 0)
    love.graphics.print(self.mouseY, 0, 10)
    love.graphics.print(tostring(self.x), 0, 30)
    love.graphics.print(tostring(self.x + self.width), 0, 40)
    love.graphics.print(tostring(self.isHovered), 0, 50)

    if self.isHovered then
        if(self.x > (love.graphics.getWidth() - self.width * 5)) then
            self.x = self.x - self.speed
        end
    else
        if(self.x < self.originalX) then
            self.x = self.x + self.speed
        end
    end
end