require("lists")

local new_things = {}

local function get_group(recipe_name)
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then
        error("recipe '" .. recipe_name .. "' not found")
    end
    local group = recipe.subgroup
    if group then return group end
    local cata = recipe.normal or recipe.expensive or recipe
    local item = cata.result or cata.results[1].name or cata.results[1][1]
    if not item then
        error("item not found for '" .. recipe.name .. "': " .. serpent.block(recipe))
    end
    return data.raw.item[item].subgroup
end

local Groups = get_list_settings("groups") --into_table(settings.startup["cf-groups"].value)
-- error(serpent.block(Groups))
local order = 97 -- a
for _, list in pairs(Groups) do
    local old_group
    if list["p"] and list["p"][1] then
        old_group = get_group(list["p"][1])
    end
    if not old_group then
        old_group = get_group(list["u"][1])
    end

    local new_group = table.deepcopy(data.raw["item-subgroup"][old_group])
    -- if not new_group then error("no sub group found in " .. list["p"][1] .. " or " .. list["u"][1]) end
    if new_group then
        new_group.name = new_group.name .. "-" .. string.char(order)
        new_group.order = new_group.order .. "-" .. string.char(order)
        order = order + 1

        table.insert(new_things, new_group)

        local sub_order = 97
        for _, value in pairs(list["p"]) do
            local recipe = data.raw.recipe[value]
            if not recipe then
                error("recipe '" .. value .. "' not found")
            end
            recipe.subgroup = new_group.name
            recipe.order = "a" .. string.char(sub_order)
            sub_order = sub_order + 1
        end
        for _, value in pairs(list["u"]) do
            local recipe = data.raw.recipe[value]
            if not recipe then
                error("recipe '" .. value .. "' not found")
            end
            recipe.subgroup = new_group.name
            recipe.order = "c" .. string.char(sub_order)
            sub_order = sub_order + 1
        end
    end
end

local function merge_names(base, new)
    local prefix = base:gsub("%-.*", "")
    if new:find(prefix) then
        return new
    end
    return prefix .. "-" .. new
end

local UP =    {0, { 0, -1}}
local RIGHT = {1, { 1,  0}}
local DOWN =  {2, { 0,  1}}
local LEFT =  {3, {-1,  0}}

local UNDERGROUNDS = {
    --1
    {type = "", item = "", order = "aa", name = "", connections = {DOWN}},
    {type = "", name = "-(r)", connections = {RIGHT}},
    {type = "", name = "-(u)", connections = {UP}},
    {type = "", name = "-(l)", connections = {LEFT}},
    --2
    {type = "2", recipe = 2, item = "cf.double", order = "ab", name = "-(rl)", connections = {RIGHT, LEFT}},
    {type = "2", name = "-(ud)", connections = {UP, DOWN}},
    {type = "2", name = "-(dr)", connections = {DOWN, RIGHT}},
    {type = "2", name = "-(ru)", connections = {RIGHT, UP}},
    {type = "2", name = "-(ul)", connections = {UP, LEFT}},
    {type = "2", name = "-(ld)", connections = {LEFT, DOWN}},
    --3
    {type = "3", recipe = 3, item = "cf.triple", order = "ac", name = "-(rdl)", connections = {RIGHT, DOWN, LEFT}},
    {type = "3", name = "-(dlu)", connections = {DOWN, LEFT, UP}},
    {type = "3", name = "-(lur)", connections = {LEFT, UP, RIGHT}},
    {type = "3", name = "-(urd)", connections = {UP, RIGHT, DOWN}},
    --4
    {type = "4", recipe = 4, item = "cf.quad", order = "ad", name = "-(drul)", connections = {DOWN, RIGHT, UP, LEFT}},
    --2
    {
        type = "",
        recipe = 2,
        item = "cf.double-flat",
        order = "ba",
        name = "-(s)",
        connections = {UP, DOWN},
        pics = {
            down  = {"straight_vertical", true},
            left  = {"straight_horizontal"},
            up    = {"straight_vertical", true},
            right = {"straight_horizontal"}
        },
    },
    {
        type = "",
        name = "-(b)",
        connections = {DOWN, RIGHT},
        pics = {
            down  = {"corner_down_right"},
            left  = {"corner_down_left"},
            up    = {"corner_up_left", true},
            right = {"corner_up_right", true}
        },
    },
    --3
    {
        type = "3",
        recipe = 3,
        item = "cf.triple-flat",
        order = "bb",
        name = "-(t)",
        connections = {UP, RIGHT, DOWN},
        pics = {
            down  = {"t_right", true},
            left  = {"t_down"},
            up    = {"t_left", true},
            right = {"t_up", true}
        },
    },
    --4
    {
        type = "4",
        recipe = 4,
        item = "cf.quad-flat",
        order = "bc",
        name = "-(4)",
        connections = {DOWN, RIGHT, UP, LEFT},
        pics = {
            down  = {"cross", true},
            left  = {"cross", true},
            up    = {"cross", true},
            right = {"cross", true}
        },
    },
}

local OFFSET = {
    down  = {0, "north"},
    left  = {1, "east"},
    up    = {2, "south"},
    right = {3, "west"},
}

local PICTURES = {
    [0] = {filename = "__Dynamic_Pipes__/graphics/down.png", size = 96, scale = 0.5, shift = {x = 0 , y = -0.1}},
    [1] = {filename = "__Dynamic_Pipes__/graphics/left.png", size = 96, scale = 0.5, shift = {x = 0 , y = -0.1}},
    [2] = {filename = "__Dynamic_Pipes__/graphics/up.png", size = 96, scale = 0.5, shift = {x = 0 , y = -0.1}},
    [3] = {filename = "__Dynamic_Pipes__/graphics/right.png", size = 96, scale = 0.5, shift = {x = 0 , y = -0.1}},
    [4] = {filename = "__Dynamic_Pipes__/graphics/cap.png", size = 128, scale = 0.25},
}

local ICONS = {
    [0] = {icon = "__Dynamic_Pipes__/graphics/down.png", icon_size = 96, scale = 0.5},
    [1] = {icon = "__Dynamic_Pipes__/graphics/left.png", icon_size = 96, scale = 0.5},
    [2] = {icon = "__Dynamic_Pipes__/graphics/up.png", icon_size = 96, scale = 0.5},
    [3] = {icon = "__Dynamic_Pipes__/graphics/right.png", icon_size = 96, scale = 0.5},
    [4] = {icon = "__Dynamic_Pipes__/graphics/cap.png", icon_size = 128},
}

local SUPER = settings.startup["cf-super-undergrounds"].value
local RECYCLING = settings.startup["cf-recycling"].value
local TIME = settings.startup["cf-crafting-time"].value

local function resize_sprite(sprite)
    if not sprite then return end

    sprite.x = ((sprite.width or sprite.size[1]) * 34) / 128
    sprite.width = ((sprite.width or sprite.size[1]) * 60) / 128
    sprite.height = ((sprite.height or sprite.size[2]) * 72) / 128
    sprite.size = nil
    sprite.shift = {x = 0, y = -.1}
end

local function resize_cover(sprite)
    if not sprite then return end

    sprite.y = ((sprite.height or sprite.size[2]) * 76) / 128
    sprite.height = ((sprite.height or sprite.size[2]) * 52) / 128
    sprite.width = (sprite.width or sprite.size[1])
    sprite.size = nil
    sprite.shift = {x = 0, y = -.05}
end

local function gen_undergrounds(all, current, original, new_things)
    local item
    for _, value in pairs(UNDERGROUNDS) do
        if value.item then
            -- print("! new base: " .. original.name .. serpent.block(original))
            local temp = current.i or original.minable.result
            item = table.deepcopy(data.raw.item[temp])

            item.order = "d" .. value.order

            if value.name == "" then
                item.localised_name = original.localised_name or {"entity-name." .. original.name}
                item.localised_description = original.localised_description or {"entity-description." .. original.name}
            else
                item.name = item.name .. value.name
                item.localised_name = {"", original.localised_name or {"entity-name." .. original.name}, " ", {value.item}}
                item.localised_description = original.localised_description or {"entity-description." .. original.name}
                item.place_result = item.name
                
                item.icons = {item.icons and item.icons[1] or {icon = item.icon, icon_size = item.icon_size}}
                if value.pics then
                    item.icons = {ICONS[4], item.icons[1]}
                end

                for _, con in pairs(value.connections) do
                    table.insert(item.icons, ICONS[con[1]])
                end

                table.insert(new_things, item)

                local base_recipe = current.r or original.name
                base_recipe = data.raw.recipe[base_recipe]
                if not base_recipe then error('Error: recipe for "' .. current.u .. '" not found. please add r="recipe name" to undergrounds mod setting') end

                local recipe = {
                    type = "recipe",
                    name = merge_names(base_recipe.name, item.name),
                    icons = item.icons,
                    localised_name = item.localised_name,
                    localised_description = item.localised_description,
                    energy_required = TIME,
                    emissions_multiplier = 1,
                    result = item.name,
                    ingredients = {{name = original.name, amount = value.recipe}},
                    allow_as_intermediate = false,
                    allow_decomposition = false,
                    category = base_recipe.category,
                    subgroup = base_recipe.subgroup,
                    enabled = base_recipe.enabled,
                    order = item.order,
                }

                -- print("! new recipe: " .. recipe.name .. serpent.block(recipe))
                table.insert(new_things, recipe)
                local tech = current.t and data.raw.technology[current.t]
                if tech then
                    table.insert(tech.effects, {type = "unlock-recipe", recipe = recipe.name})
                end

                if RECYCLING then
                    recipe = table.deepcopy(recipe)

                    recipe.name = recipe.name .. "recycling"
                    table.insert(recipe.localised_name, " ")
                    table.insert(recipe.localised_name, {"cf.recycling"})
                    recipe.ingredients = {{name = item.name, amount = 1}}
                    recipe.result = original.name
                    recipe.result_count = value.recipe
                    recipe.order = "f" .. value.order
                    table.insert(recipe.icons, {icon = "__Dynamic_Pipes__/graphics/recycle.png", icon_size = 96, scale = 0.2, shift = {-5, -5}})
            
                    -- print("! new recipe: " .. recipe.name .. serpent.block(recipe))
                    table.insert(new_things, recipe)
                    local tech = current.t and data.raw.technology[current.t]
                    if tech then
                        table.insert(tech.effects, {type = "unlock-recipe", recipe = recipe.name})
                    end
                end
            end
        end

        local new = table.deepcopy(original)
        local distance = new.fluid_box.pipe_connections[2].max_underground_distance

        --steal localization
        new.localised_name = item.localised_name
        new.localised_description = item.localised_description
        
        --add direction tag to id
        new.name = new.name .. value.name
        --change related item
        new.minable.result = item.name
        new.placeable_by = {item = item.name, count = 1}

        if new.next_upgrade and all[new.next_upgrade] then
            new.next_upgrade = new.next_upgrade .. value.name
        else
            new.next_upgrade = nil
        end

        --move pictures to layers
        for side, _ in pairs(OFFSET) do
            if not new.pictures[side].layers then
                new.pictures[side] = {layers = {new.pictures[side]}}
            end
        end

        new.fluid_box.pipe_connections[2] = nil
        if value.pics then
            if SUPER then
                new.collision_mask = {"doodad-layer"}
                new.integration_patch_render_layer = "decorative"
                new.integration_patch = {}
            end
            new.fluid_box.pipe_connections[1] = nil

            local pipe = current.p or "pipe"
            pipe = data.raw.pipe[pipe]
            for side, set in pairs(value.pics) do
                if SUPER then
                    new.integration_patch[OFFSET[side][2]] = {layers = {PICTURES[4]}}
                    new.pictures[side].layers = {}
                else
                    new.pictures[side].layers = {PICTURES[4]}
                end
                
                local temp = table.deepcopy(pipe.pictures[set[1]])
                resize_sprite(temp.hr_version)
                resize_sprite(temp)

                if set[2] then
                    local cover = table.deepcopy(new.fluid_box.pipe_covers.north.layers[1])
                    resize_cover(cover.hr_version)
                    resize_cover(cover)

                    if SUPER then
                        table.insert(new.integration_patch[OFFSET[side][2]].layers, cover)
                    else
                        table.insert(new.pictures[side].layers, cover)
                    end
                end

                if SUPER then
                    table.insert(new.integration_patch[OFFSET[side][2]].layers, temp)
                else
                    table.insert(new.pictures[side].layers, temp)
                end
            end
        end

        --add underground connections
        for _, con in pairs(value.connections) do
            table.insert(
                new.fluid_box.pipe_connections,
                {position = con[2], max_underground_distance = distance}
            )

            --add overlay arrows to graphics
            for side, off in pairs(OFFSET) do
                table.insert(new.pictures[side].layers, PICTURES[(con[1] + off[1]) % 4])
            end
        end

        -- print("! new entity: " .. new.name .. serpent.block(new))
        table.insert(new_things, new)
    end
end

--{u=underground,r=?recipe,i=?item,p=?pipe,t=?technology}
local Undergrounds = get_list_settings("underground") --into_table(settings.startup["cf-underground"].value)
-- error(serpent.block(Undergrounds))
local all = {}
for _, value in pairs(Undergrounds) do
    all[value.u] = true
end
for _, current in pairs(Undergrounds) do
    local original = data.raw["pipe-to-ground"][current.u]
    if original then
        gen_undergrounds(all, current, original, new_things)
    end
end

local EMPTY_SPRITE = {
    filename = "__core__/graphics/empty.png",
    priority = "extra-high",
    width = 1,
    height = 1,
    frame_count = 1
}

local SIDES = {
    north = true,
    east = true,
    south = true,
    west = true,
}

local NUMBERS = {
    "__Dynamic_Pipes__/graphics/1.png",
    "__Dynamic_Pipes__/graphics/2.png",
    "__Dynamic_Pipes__/graphics/3.png",
    "__Dynamic_Pipes__/graphics/4.png",
    "__Dynamic_Pipes__/graphics/5.png",
    "__Dynamic_Pipes__/graphics/6.png",
    "__Dynamic_Pipes__/graphics/7.png",
    "__Dynamic_Pipes__/graphics/8.png",
    "__Dynamic_Pipes__/graphics/9.png",
}

local function gen_valves(all, current, original, new_things)
    local base = table.deepcopy(original)
    local item = current.i or base.minable.result
    item = table.deepcopy(data.raw.item[item])
    local item_tag = "-(one)"

    item.name = item.name .. item_tag
    item.localised_name = {"", base.localised_name or {"entity-name." .. base.name}, " ", {"cf.valve"}}
    item.localised_description = base.localised_description or {"entity-description." .. base.name}

    item.place_result = item.name
    item.stack_size = 50

    item.icons = {item.icons and item.icons[1] or {icon = item.icon, icon_size = item.icon_size}}
    table.insert(item.icons, {icon = "__Dynamic_Pipes__/graphics/one_way.png", icon_size = 96, scale = 0.5})

    table.insert(new_things, item)

    local base_recipe = current.r or base.name
    base_recipe = data.raw.recipe[base_recipe]
    if not base_recipe then error('Error: recipe for "' .. current.p .. '" not found. please add r="recipe name" to valve mod setting') end

    local recipe = {
        type = "recipe",
        name = merge_names(base_recipe.name, item.name),
        icons = item.icons,
        localised_name = item.localised_name,
        localised_description = item.localised_description,
        energy_required = TIME,
        emissions_multiplier = 1,
        result = item.name,
        ingredients = {{name = base.name, amount = 5}},
        allow_as_intermediate = false,
        allow_decomposition = false,
        category = base_recipe.category,
        subgroup = base_recipe.subgroup,
        enabled = base_recipe.enabled,
        order = "c"
    }

    table.insert(new_things, recipe)
    local tech = current.t and data.raw.technology[current.t]
    if tech then
        table.insert(tech.effects, {type = "unlock-recipe", recipe = recipe.name})
    end

    if RECYCLING then
        recipe = table.deepcopy(recipe)

        recipe.name = recipe.name .. "recycling"
        table.insert(recipe.localised_name, " ")
        table.insert(recipe.localised_name, {"cf.recycling"})
        recipe.ingredients = {{name = item.name, amount = 1}}
        recipe.result = base.name
        recipe.result_count = 5
        recipe.order = "e"
        table.insert(recipe.icons, {icon = "__Dynamic_Pipes__/graphics/recycle.png", icon_size = 96, scale = 0.2, shift = {-5, -5}})

        table.insert(new_things, recipe)
        local tech = current.t and data.raw.technology[current.t]
        if tech then
            table.insert(tech.effects, {type = "unlock-recipe", recipe = recipe.name})
        end
    end

    base.pictures = {
        picture = {
            north = {layers = {base.pictures.straight_vertical}},
            east = {layers = {base.pictures.straight_horizontal}},
            south = {layers = {base.pictures.straight_vertical}},
            west = {layers = {base.pictures.straight_horizontal}},
        },
        gas_flow = EMPTY_SPRITE,
        fluid_background = EMPTY_SPRITE,
        window_background = EMPTY_SPRITE,
        flow_sprite = EMPTY_SPRITE,
    }

    base.fluid_box.pipe_connections = {
        {
            position = {0, -1},
            type="output"
        },
        {position = {0, 1}}
    }

    base.next_upgrade = nil
    base.circuit_wire_max_distance = 0
    base.minable.result = item.name
    base.placeable_by = {item = item.name, count = 1}
    base.type = "storage-tank"
    base.window_bounding_box = {{0, 0}, {0, 0}}
    base.flow_length_in_ticks = 1

    local covers = current.u or "pipe-to-ground"
    base.fluid_box.pipe_covers = data.raw["pipe-to-ground"][covers].fluid_box.pipe_covers

    for i = 1, 9 do
        --overflow
        local new = table.deepcopy(base)
        local tag = "-(o" .. i .. ")"

        new.name = new.name .. tag
        new.localised_name = {"", {"entity-name." .. base.name}, " ", {"cf.overflow"}, " " .. i .. "0%"}
        new.fluid_box.base_level = i / 10
        new.fluid_box.base_area = new.fluid_box.base_area * ((10 - i) / 10)
        if new.next_upgrade and all[new.next_upgrade] then
            new.next_upgrade = new.next_upgrade .. tag
        else
            new.next_upgrade = nil
        end

        for side, _ in pairs(SIDES) do
            for side, _ in pairs(SIDES) do
                table.insert(new.pictures.picture[side].layers, {filename = "__Dynamic_Pipes__/graphics/overflow.png", size = 96, scale = 0.5, shift = {x = 0 , y = -0.1}})
                table.insert(new.pictures.picture[side].layers, {filename = NUMBERS[i], size = 96, scale = 0.5, shift = {x = 0 , y = -0.1}})
            end
        end

        table.insert(new_things, new)

        --underflow
        local new = table.deepcopy(base)
        local tag = "-(u" .. i .. ")"

        new.name = new.name .. tag
        new.localised_name = {"", {"entity-name." .. base.name}, " ", {"cf.underflow"}, " " .. i .. "0%"}
        new.fluid_box.base_level = (i - 10) / 10
        new.fluid_box.base_area = new.fluid_box.base_area * ((10 - i) / 10)
        if new.next_upgrade and all[new.next_upgrade] then
            new.next_upgrade = new.next_upgrade .. tag
        else
            new.next_upgrade = nil
        end

        for side, _ in pairs(SIDES) do
            for side, _ in pairs(SIDES) do
                table.insert(new.pictures.picture[side].layers, {filename = "__Dynamic_Pipes__/graphics/underflow.png", size = 96, scale = 0.5, shift = {x = 0 , y = -0.1}})
                table.insert(new.pictures.picture[side].layers, {filename = NUMBERS[i], size = 96, scale = 0.5, shift = {x = 0 , y = -0.1}})
            end
        end

        table.insert(new_things, new)
    end

    --one_way
    base.localised_name = {"", base.localised_name or {"entity-name." .. base.name}, " ", {"cf.one-way"}}
    base.localised_description = item.localised_description

    base.name = item.name
    if base.next_upgrade and all[new.next_upgrade] then
        base.next_upgrade = base.next_upgrade .. item_tag
    else
        base.next_upgrade = nil
    end

    for side, _ in pairs(SIDES) do
        table.insert(base.pictures.picture[side].layers, {filename = "__Dynamic_Pipes__/graphics/one_way.png", size = 96, scale = 0.5, shift = {x = 0 , y = -0.1}})
    end

    table.insert(new_things, base)
end

--{p=pipe,u=?underground,r=?recipe,i=?item,t=?technology}
local Valves = get_list_settings("valve") --into_table(settings.startup["cf-valve"].value)
all = {}
for _, value in pairs(Valves) do
    all[value.p] = true
end
for _, current in pairs(Valves) do
    local original = data.raw["pipe"][current.p]
    if original then
        gen_valves(all, current, original, new_things)
    end
end

data:extend(new_things)