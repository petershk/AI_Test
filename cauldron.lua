local Cauldron = {}
Cauldron.__index = Cauldron

function Cauldron:new(x, y, w, h)
    local obj = {
        x = x,
        y = y,
        w = w,
        h = h
    }
    setmetatable(obj, self)
    return obj
end

function Cauldron:draw()
    love.graphics.setColor(0.3, 0.2, 0.1)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Cauldron", self.x, self.y - 20, self.w, "center")
end

function Cauldron:contains(x, y)
    return x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h
end

local function findElementByIngredients(ingredientNames, elements)
    table.sort(ingredientNames)
    for name, data in pairs(elements) do
        if data.recipe and #data.recipe > 0 then
            local recipe = {}
            for i, v in ipairs(data.recipe) do
                recipe[i] = v
            end
            table.sort(recipe)
            if #recipe == #ingredientNames then
                local match = true
                for i = 1, #recipe do
                    if recipe[i] ~= ingredientNames[i] then
                        match = false
                        break
                    end
                end
                if match then
                    return name
                end
            end
        end
    end
    return nil
end

function Cauldron:combine(ingredients, elements, IngredientClass, resultArea, findNextOpenResultSlot)
    local inCauldron = {}
    local indices = {}
    for i, ing in ipairs(ingredients) do
        if ing.inCauldron then
            table.insert(inCauldron, ing.name)
            table.insert(indices, i)
        end
    end
    if #inCauldron >= 2 then
        local newName = findElementByIngredients(inCauldron, elements)
        if newName then
            -- Remove used ingredients (from last to first to avoid index shift)
            for i = #indices, 1, -1 do
                table.remove(ingredients, indices[i])
            end
            -- Add new ingredient to the right of the cauldron
            local x, y = findNextOpenResultSlot()
            if not x or not y then
                x, y = resultArea.x, resultArea.y
            end
            table.insert(ingredients, IngredientClass:new(newName, x, y, elements[newName].color))
            -- Reset cauldron status
            for _, ing in ipairs(ingredients) do
                ing.inCauldron = false
            end
            return "Created: " .. newName
        else
            return "Unknown combination"
        end
    else
        return "Put at least 2 ingredients in the cauldron!"
    end
end


return Cauldron