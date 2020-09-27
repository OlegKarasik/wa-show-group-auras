max_line_length = false
std = {
    globals = {
        -- Lua
        "_G",
        "ipairs",
        "pairs",
        "print",
        "tinsert",
        "tremove",
        "error",
        "string",
        "type",
        "select",
        "table",
        

        -- Weak auras
        "aura_env",
        "LibStub",
        "WA_GetUnitAura",
        "WeakAuras",


        -- Blizzard
        "SendChatMessage",
        "IsInGroup",
        "IsInRaid",
        "GameTooltip",
        "UIParent",
        "CreateFrame",
        "GetRaidRosterInfo",
        "UnitInRaid",
        "GetLocale",
        "GetPlayerInfoByGUID",
        "UnitIsUnit",
        "UnitClass",
        "UnitName",
        "UnitExists",
        "CreateColor"
    }
}
ignore = {
    "212",
    "611",
    "612",
    "614"
}