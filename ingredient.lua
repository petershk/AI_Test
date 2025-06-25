local Ingredient = {}
Ingredient.__index = Ingredient

function Ingredient:new(name, x, y, color)
    local obj = {
        name = name,
        x = x,
        y = y,
        color = color or {1, 1, 1}, -- Default color is white
        inCauldron = false
    }
    setmetatable(obj, self)
    return obj
end

function Ingredient:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, 100, 40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self.name, self.x + 10, self.y + 10)
end

function Ingredient:isAt(x, y)
    return x > self.x and x < self.x + 100 and y > self.y and y < self.y + 40
end

return Ingredient