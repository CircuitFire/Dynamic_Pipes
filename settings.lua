require("lists")

--{u=underground,r=?recipe,i=?item,p=?pipe,t=?technology}

data:extend{
    {
        type = "string-setting",
        name = "cf-run-type",
        setting_type = "startup",
        order = "a",
        allowed_values = {"data-final-fixes", "data-updates", "library"},
        default_value = "data-final-fixes",
    },
    {
        type = "bool-setting",
        name = "cf-use-lists",
        setting_type = "startup",
        order = "db",
        default_value = false,
    },
    {
        type = "bool-setting",
        name = "cf-super-undergrounds",
        setting_type = "startup",
        order = "b",
        default_value = false,
    },
    {
        type = "bool-setting",
        name = "cf-recycling",
        setting_type = "startup",
        order = "c",
        default_value = false,
    },
    {
        type = "double-setting",
        name = "cf-crafting-time",
        setting_type = "startup",
        order = "d",
        default_value = 1,
        minimum_value = .02
    },
    {
        type = "string-setting",
        name = "cf-underground",
        setting_type = "startup",
        order = "e",
        allow_blank = true,
        default_value = serpent.line(get_list("underground")),
    },
    {
        type = "string-setting",
        name = "cf-valve",
        setting_type = "startup",
        order = "f",
        allow_blank = true,
        default_value = serpent.line(get_list("valve")),
    },
    {
        type = "string-setting",
        name = "cf-groups",
        setting_type = "startup",
        order = "g",
        allow_blank = true,
        default_value = serpent.line(get_list("groups")),
    },
}