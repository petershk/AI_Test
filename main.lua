local Ingredient = require("ingredient")
local Cauldron = require("cauldron")
local recipes = require("recipes")
local elements = require("elements")

local ingredients = {
    Ingredient:new("Water", 50, 100, elements.Water.color),
    Ingredient:new("Fire", 50, 200, elements.Fire.color),
    Ingredient:new("Earth", 50, 300, elements.Earth.color),
    Ingredient:new("Air", 50, 400, elements.Air.color),
}

local cauldron = Cauldron:new(400, 250, 200, 100)
local dragging = nil
local result = ""
local combineButton = {x = 400, y = 400, w = 120, h = 40}



local baseElements = {"Water", "Fire", "Earth", "Air"}
local maxBaseCount = 2 -- Maximum number of each base element allowed
local spawnTimer = 0
local spawnInterval = 5 -- seconds

function love.load()
    love.window.setTitle("Alchemist: Merge Game")
    love.window.setMode(800, 600)
end

function love.update(dt)
    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnInterval then
        spawnBaseElement()
        spawnTimer = 0
    end
end

function love.draw()
    cauldron:draw()
    for _, ing in ipairs(ingredients) do
        ing:draw()
    end
    drawResult()
    drawCombineButton()
    drawSpawnTimer()
end

function drawResult()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Result: " .. result, 50, 500)
end

function drawCombineButton()
    love.graphics.setColor(0.2, 0.6, 0.2)
    love.graphics.rectangle("fill", combineButton.x, combineButton.y, combineButton.w, combineButton.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Combine", combineButton.x, combineButton.y + 10, combineButton.w, "center")
end

function drawSpawnTimer()
    love.graphics.setColor(1, 1, 1)
    local available = false
    for _, name in ipairs(baseElements) do
        if countBaseElement(name) < maxBaseCount then
            available = true
            break
        end
    end
    if available then
        local timeLeft = math.ceil(spawnInterval - spawnTimer)
        love.graphics.print("Next base ingredient in: " .. timeLeft .. "s", 50, 60)
    else
        love.graphics.print("No more base ingredients will spawn.", 50, 60)
    end
end

function love.mousepressed(x, y)
    dragging = getIngredientAt(x, y)
    if isInside(x, y, combineButton) then
        combineIngredients()
    end
end

function love.mousemoved(x, y, dx, dy)
    if dragging then
        ingredients[dragging].x = x - 50
        ingredients[dragging].y = y - 20
    end
end

function love.mousereleased(x, y)
    if dragging then
        updateIngredientCauldronStatus(dragging, x, y)
        dragging = nil
    end
end

function getIngredientAt(x, y)
    for i, ing in ipairs(ingredients) do
        if ing:isAt(x, y) then
            return i
        end
    end
    return nil
end

function updateIngredientCauldronStatus(index, x, y)
    local ing = ingredients[index]
    ing.inCauldron = cauldron:contains(x, y)
end

function isInside(x, y, rect)
    return x > rect.x and x < rect.x + rect.w and y > rect.y and y < rect.y + rect.h
end


function combineIngredients()
    result = cauldron:combine(
        ingredients,
        elements,
        Ingredient,
        resultArea,
        findNextOpenResultSlot
    )
end

function countBaseElement(name)
    local count = 0
    for _, ing in ipairs(ingredients) do
        if ing.name == name then
            count = count + 1
        end
    end
    return count
end


-- Define spawn area and grid
local spawnArea = {x = 30, y = 90, w = 350, h = 400}
local colWidth, rowHeight = 120, 50
local maxCols = math.floor(spawnArea.w / colWidth)
local maxRows = math.floor(spawnArea.h / rowHeight)

-- Define result spawn area and grid (to the right of the cauldron)
local resultArea = {x = 620, y = 90, w = 150, h = 400}
local resultColWidth, resultRowHeight = 120, 50
local resultMaxCols = math.floor(resultArea.w / resultColWidth)
local resultMaxRows = math.floor(resultArea.h / resultRowHeight)
function findNextOpenResultSlot()
    -- Build a grid of occupied slots in the result area
    local occupied = {}
    for _, ing in ipairs(ingredients) do
        if ing.x >= resultArea.x and ing.x < resultArea.x + resultArea.w and
           ing.y >= resultArea.y and ing.y < resultArea.y + resultArea.h then
            local col = math.floor((ing.x - resultArea.x) / resultColWidth)
            local row = math.floor((ing.y - resultArea.y) / resultRowHeight)
            occupied[col .. "," .. row] = true
        end
    end
    -- Find the first unoccupied slot
    for col = 0, resultMaxCols - 1 do
        for row = 0, resultMaxRows - 1 do
            if not occupied[col .. "," .. row] then
                local x = resultArea.x + col * resultColWidth
                local y = resultArea.y + row * resultRowHeight
                return x, y
            end
        end
    end
    return nil, nil -- No space left
end


function findNextOpenSpawnSlot()
    -- Build a grid of occupied slots
    local occupied = {}
    for _, ing in ipairs(ingredients) do
        local col = math.floor((ing.x - spawnArea.x) / colWidth)
        local row = math.floor((ing.y - spawnArea.y) / rowHeight)
        occupied[col .. "," .. row] = true
    end
    -- Find the first unoccupied slot
    for col = 0, maxCols - 1 do
        for row = 0, maxRows - 1 do
            if not occupied[col .. "," .. row] then
                local x = spawnArea.x + col * colWidth
                local y = spawnArea.y + row * rowHeight
                return x, y
            end
        end
    end
    return nil, nil -- No space left
end

function spawnBaseElement()
    -- Pick a random base element that has less than maxBaseCount
    local available = {}
    for _, name in ipairs(baseElements) do
        if countBaseElement(name) < maxBaseCount then
            table.insert(available, name)
        end
    end
    if #available > 0 then
        local name = available[love.math.random(#available)]
        local x, y = findNextOpenSpawnSlot()
        if x and y then
            table.insert(ingredients, Ingredient:new(name, x, y, elements[name].color))
        end
    end
end

-- Returns the element name if a recipe matches, or nil
local function findElementByIngredients(ingredientNames, elements)
    table.sort(ingredientNames)
    for name, data in pairs(elements) do
        if data.recipe and #data.recipe > 0 then
            local recipe = {table.unpack(data.recipe)}
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

