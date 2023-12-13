require("lists")

local valid_underground = {}
for _, value in pairs(get_list_settings("underground")) do
    valid_underground[value.u] = true
end

local function player(event)
    return game.players[event.player_index]
end

local function get_type(entity)
    if entity.type == "entity-ghost" then
        return entity.ghost_type
    end
    return entity.type
end

local function get_name(entity)
    if entity.type == "entity-ghost" then
        return entity.ghost_name
    end
    return entity.name
end

local function replace_entity(old, new_name)
    local new = {
        position = old.position,
        direction = old.direction,
        force = old.force,
        create_build_effect_smoke = false,
        spill = false,
    }

    local surface = old.surface

    if old.type == "entity-ghost" then
        new.name = "entity-ghost"
        new.inner_name  = new_name
        old.destroy{raise_destroy = true}
        surface.create_entity(new)
    else
        new.name = new_name
        local fluidbox = old.fluidbox[1]
        old.destroy{raise_destroy = true}
        local new_entity = surface.create_entity(new)
        new_entity.fluidbox[1] = fluidbox
    end
end

local function split_name(name)
    local base, tag = string.match(name, "(.+)%-%((.+)%)")
    if not base then
        base = name
        tag = ""
    end
    return base, tag
end

local UNDERGROUNDS = {
    --1
    [""]     = {"-(r)", "-(l)"},
    ["r"]    = {"-(u)", ""    },
    ["u"]    = {"-(l)", "-(r)"},
    ["l"]    = {""    , "-(u)"},
    --2
    ["rl"]   = {"-(ud)", "-(ld)"},
    ["ud"]   = {"-(dr)", "-(rl)"},
    ["dr"]   = {"-(ru)", "-(ud)"},
    ["ru"]   = {"-(ul)", "-(dr)"},
    ["ul"]   = {"-(ld)", "-(ru)"},
    ["ld"]   = {"-(rl)", "-(ul)"},
    --3
    ["rdl"]  = {"-(dlu)", "-(urd)"},
    ["dlu"]  = {"-(lur)", "-(rdl)"},
    ["lur"]  = {"-(urd)", "-(dlu)"},
    ["urd"]  = {"-(rdl)", "-(lur)"},
    --4
    ["drul"] = {},
    --2f
    ["s"] = {"-(b)", "-(b)"},
    ["b"] = {"-(s)", "-(s)"},
    --3f
    ["t"] = {},
    --4f
    ["4"] = {},
}

local function rotate(event, set)
    local player = player(event)
    local selected = player.selected
    if selected and selected.force == player.force and get_type(selected) == "pipe-to-ground" then
        local base, tag = split_name(get_name(selected))

        if not valid_underground[base] then return end

        local new_tag = UNDERGROUNDS[tag][set]
        if new_tag then
            replace_entity(selected, base .. new_tag)
        end
    end
end

script.on_event("cf-rotate-underground", function(event)
    rotate(event, 2)
end)

script.on_event("cf-reverse-rotate-underground", function(event)
    rotate(event, 1)
end)

local valid_tank = {}
for _, value in pairs(get_list_settings("valve")) do
    valid_tank[value.p] = true
end

local VALVES = {
    ["o9"]  = {nil,   "o8"},
    ["o8"]  = {"o9",  "o7"},
    ["o7"]  = {"o8",  "o6"},
    ["o6"]  = {"o7",  "o5"},
    ["o5"]  = {"o6",  "o4"},
    ["o4"]  = {"o5",  "o3"},
    ["o3"]  = {"o4",  "o2"},
    ["o2"]  = {"o3",  "o1"},
    ["o1"]  = {"o2",  "one"},
    ["one"] = {"o1",  "u1"},
    ["u1"]  = {"one", "u2"},
    ["u2"]  = {"u1",  "u3"},
    ["u3"]  = {"u2",  "u4"},
    ["u4"]  = {"u3",  "u5"},
    ["u5"]  = {"u4",  "u6"},
    ["u6"]  = {"u5",  "u7"},
    ["u7"]  = {"u6",  "u8"},
    ["u8"]  = {"u7",  "u9"},
    ["u9"]  = {"u8",  nil},
}

local function set_valve(event, set)
    local player = player(event)
    local selected = player.selected
    if selected and selected.force == player.force and get_type(selected) == "storage-tank" then
        local base, tag = split_name(get_name(selected))

        if not valid_tank[base] then return end

        local new_tag = VALVES[tag][set]
        if new_tag then
            replace_entity(selected, base .. "-(" .. new_tag .. ")")
        end
    end
end

script.on_event("cf-minus-valve", function(event)
    set_valve(event, 2)
end)

script.on_event("cf-plus-valve", function(event)
    set_valve(event, 1)
end)

commands.add_command("cf-replace-pipe", nil, function (command)
    if not command.parameter then return end
    local find, replace = string.match(command.parameter, "(%S+) (%S+)")
    if not (find and game.entity_prototypes[find] and replace and game.entity_prototypes[replace]) then
        player(command).print({"cf.replace-usage"})
        return
    end
    
    game.print({"cf.replace-message", find, replace})
    for _, surface in pairs(game.surfaces) do
        for _, entity in pairs(surface.find_entities_filtered{name = find}) do
            replace_entity(entity, replace)
        end
    end
end)
--[[
local function unlocks_recipes(list, type, technologies, recipes)
    for _, value in pairs(list) do
        if value.t and technologies[value.t] and technologies[value.t].researched then
            for _, effect in pairs(technologies[value.t].effects) do
                if effect.type == "unlock-recipe" then
                    local base, tag = split_name(effect.recipe)
                    if base == value[type] then
                        game.print("unlocking: " .. effect.recipe)
                        recipes[effect.recipe].enabled = true
                    end
                end
            end
        end
    end
end

commands.add_command("cf-fix-unlocks", nil, function (command)
    for _, force in pairs(game.forces) do
        unlocks_recipes(get_list_settings("underground"), "u", force.technologies, force.recipes)
        unlocks_recipes(get_list_settings("valve"), "p", force.technologies, force.recipes)
    end
end)
]]