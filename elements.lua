local elements = {
    Water = {
        color = {0, 0, 1},
        recipe = {},
    },
    Fire = {
        color = {1, 0, 0},
        recipe = {},
    },
    Earth = {
        color = {0.5, 0.25, 0},
        recipe = {},
    },
    Air = {
        color = {0.8, 0.8, 0.8},
        recipe = {},
    },
    Mud = {
        color = {0.4, 0.3, 0.2},
        recipe = {"Earth", "Water"},
    },
    Steam = {
        color = {0.8, 0.8, 1},
        recipe = {"Fire", "Water"},
    },
    Glass = {
        color = {0.9, 0.9, 1},
        recipe = {"Earth", "Fire"},
    },
    Dust = {
        color = {0.9, 0.8, 0.6},
        recipe = {"Air", "Earth"},
    },
    Clay = {
        color = {0.7, 0.5, 0.4},
        recipe = {"Air", "Mud"},
    },
    Plant = {
        color = {0.2, 0.7, 0.2},
        recipe = {"Earth", "Rain"},
    },
    Brick = {
        color = {0.8, 0.3, 0.2},
        recipe = {"Fire", "Mud"},
    },
    Lens = {
        color = {0.95, 0.95, 1},
        recipe = {"Air", "Glass"},
    },
    Lightbulb = {
        color = {1, 1, 0.7},
        recipe = {"Fire", "Glass"},
    },
    Geyser = {
        color = {0.7, 0.9, 1},
        recipe = {"Earth", "Steam"},
    },
    Cloud = {
        color = {0.9, 0.9, 1},
        recipe = {"Air", "Steam"},
    },
    Rainbow = {
        color = {1, 0.5, 1},
        recipe = {"Fire", "Rain"},
    },
    Tree = {
        color = {0.2, 0.5, 0.2},
        recipe = {"Earth", "Plant"},
    },
    Charcoal = {
        color = {0.2, 0.2, 0.2},
        recipe = {"Tree", "Fire"},
    },
    Paper = {
        color = {1, 1, 0.9},
        recipe = {"Tree", "Water"},
    },
    Swamp = {
        color = {0.3, 0.4, 0.2},
        recipe = {"Plant", "Mud"},
    },
    -- Continue adding more elements as needed...
}

return elements