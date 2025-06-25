--This is where we define the recipes for the alchemy system.

local raw = {
    ["Air+Earth"] = "Dust",
    ["Air+Earth+Fire"] = "Ash",
    ["Air+Earth+Water"] = "Volcanic Rock",
    ["Air+Fire"] = "Heatwave",
    ["Air+Fire+Water"] = "Steam Cloud",
    ["Air+Water"] = "Rain",
    ["Earth+Fire"] = "Glass",
    ["Earth+Fire+Water"] = "Magma",
    ["Earth+Water"] = "Mud",
    ["Fire+Water"] = "Steam",
    ["Magma+Mud"] = "Volcano",

    -- More unique recipes:
    ["Air+Mud"] = "Clay",
    ["Earth+Rain"] = "Plant",
    ["Fire+Mud"] = "Brick",
    ["Air+Glass"] = "Lens",
    ["Fire+Glass"] = "Lightbulb",
    ["Earth+Steam"] = "Geyser",
    ["Air+Steam"] = "Cloud",
    ["Fire+Rain"] = "Rainbow",
    ["Earth+Plant"] = "Tree",
    ["Tree+Fire"] = "Charcoal",
    ["Tree+Water"] = "Paper",
    ["Plant+Mud"] = "Swamp",
    ["Swamp+Energy"] = "Life",
    ["Air+Life"] = "Bird",
    ["Earth+Life"] = "Beast",
    ["Water+Life"] = "Fish",
    ["Fire+Life"] = "Phoenix",
    ["Mud+Plant"] = "Moss",
    ["Steam+Energy"] = "Engine",
    ["Lens+Lightbulb"] = "Projector",
    ["Cloud+Energy"] = "Storm",
    ["Storm+Earth"] = "Tornado",
    ["Geyser+Mud"] = "Hot Spring"
}

local function normalizeRecipeKeys(recipes)
    local normalized = {}
    for key, value in pairs(recipes) do
        local names = {}
        for name in string.gmatch(key, "([^+]+)") do
            table.insert(names, name)
        end
        table.sort(names)
        local sortedKey = table.concat(names, "+")
        normalized[sortedKey] = value
    end
    return normalized
end
return normalizeRecipeKeys(raw)