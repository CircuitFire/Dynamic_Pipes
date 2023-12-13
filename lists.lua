require("string_to_table")
local mods = mods or script.active_mods

--{u=underground,r=?recipe,i=?item,p=?pipe,t=?technology}
local lists = {
    underground = {
        {u="pipe-to-ground",p="pipe"}
    },
    valve = {
        {p="pipe",u="pipe-to-ground"}
    },
    groups = {
        {p={"pipe"},u={"pipe-to-ground"}}
    }
}

if mods["nullius"] then
    lists.underground = {}
    table.insert(lists.underground, {u="pipe-to-ground",p="pipe",r="nullius-underground-pipe-1",t="nullius-plumbing-2"})
    table.insert(lists.underground, {u="nullius-underground-pipe-2",p="nullius-pipe-2",t="nullius-plumbing-3"})
    table.insert(lists.underground, {u="nullius-underground-pipe-3",p="nullius-pipe-3",t="nullius-plumbing-5"})
    table.insert(lists.underground, {u="nullius-underground-pipe-4",p="nullius-pipe-4",t="nullius-plumbing-6"})

    lists.valve = {}
    table.insert(lists.valve, {p="pipe",u="pipe-to-ground",r="nullius-stone-pipe",t="nullius-plumbing-1"})
    table.insert(lists.valve, {p="nullius-pipe-2",u="nullius-underground-pipe-2",r="nullius-plastic-pipe",t="nullius-plumbing-3"})
    table.insert(lists.valve, {p="nullius-pipe-3",u="nullius-underground-pipe-3",t="nullius-plumbing-5"})
    table.insert(lists.valve, {p="nullius-pipe-4",u="nullius-underground-pipe-4",t="nullius-plumbing-6"})

    lists.groups = {}
    table.insert(lists.groups, {p={"nullius-stone-pipe","nullius-iron-pipe"},u={"nullius-underground-pipe-1"}})
    table.insert(lists.groups, {p={"nullius-plastic-pipe","nullius-steel-pipe"},u={"nullius-underground-pipe-2"}})
    table.insert(lists.groups, {p={"nullius-pipe-3"},u={"nullius-underground-pipe-3"}})
    table.insert(lists.groups, {p={"nullius-pipe-4"},u={"nullius-underground-pipe-4"}})
end


if mods["aai-industry"] then
    lists.underground[1].t = "basic-fluid-handling"
    lists.valve[1].t = "basic-fluid-handling"
end
if mods["Krastorio2"] then
    lists.underground[1].t = "kr-basic-fluid-handling"
    lists.valve[1].t = "kr-basic-fluid-handling"

    table.insert(lists.underground, {u="kr-steel-pipe-to-ground",p="kr-steel-pipe",t="kr-steel-fluid-handling"})
    table.insert(lists.valve, {p="kr-steel-pipe",u="kr-steel-pipe-to-ground",t="kr-steel-fluid-handling"})
    table.insert(lists.groups, {p={"kr-steel-pipe"},u={"kr-steel-pipe-to-ground"}})
end
if mods["space-exploration"] then
    table.insert(lists.underground, {u="se-space-pipe-to-ground",p="se-space-pipe",t="se-space-pipe"})
    table.insert(lists.valve, {p="se-space-pipe",u="se-space-pipe-to-ground",t="se-space-pipe"})
    table.insert(lists.groups, {p={"se-space-pipe"},u={"se-space-pipe-to-ground"}})
end


if mods["pyrawores"] then
    table.insert(lists.groups[1].p, "casting-pipe")
    table.insert(lists.groups[1].u, "casting-pipe-ug")
end
if mods["pypetroleumhandling"] then
    table.insert(lists.groups[1].p, "hotair-casting-pipe")
    table.insert(lists.groups[1].u, "hotair-casting-pipe-ug")
end
if mods["pyindustry"] then
    table.insert(lists.underground, {u="niobium-pipe-to-ground",p="niobium-pipe",t="niobium"})
    table.insert(lists.valve, {p="niobium-pipe",u="niobium-pipe-to-ground",t="niobium"})
    table.insert(lists.groups, {p={"niobium-pipe"},u={"niobium-pipe-to-ground"}})

    local len = #lists.groups
    if mods["pyrawores"] then
        table.insert(lists.groups[len].p, "casting-niobium-pipe")
        table.insert(lists.groups[len].u, "casting-niobium-pipe-underground")
    end
    if mods["pypetroleumhandling"] then
        table.insert(lists.groups[len].p, "hotair-casting-niobium-pipe")
        table.insert(lists.groups[len].u, "hotair-casting-niobium-pipe-underground")
    end
end
if mods["pyhightech"] then
    table.insert(lists.underground, {u="ht-pipes-to-ground",p="ht-pipes",t="coal-processing-3"})
    table.insert(lists.valve, {p="ht-pipes",u="ht-pipes-to-ground",t="coal-processing-3"})
    table.insert(lists.groups, {p={"ht-pipes"},u={"ht-pipes-to-ground"}})

    local len = #lists.groups
    if mods["pyrawores"] then
        table.insert(lists.groups[len].p, "casting-ht-pipe")
        table.insert(lists.groups[len].u, "casting-ht-pipe-underground")
    end
    if mods["pypetroleumhandling"] then
        table.insert(lists.groups[len].p, "hotair-casting-ht-pipe")
        table.insert(lists.groups[len].u, "hotair-casting-ht-pipe-underground")
    end
end


function get_list(list)
    return lists[list]
end

function get_list_settings(list)
    if settings.startup["cf-use-lists"].value then
        return into_table(settings.startup["cf-" .. list].value)
    else
        return lists[list]
    end
end