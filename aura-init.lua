-- AURA CONFIGURATION --

-- aura_env.config.auras is the root configuration entity
-- index, aura_config
--
-- aura_config = {
--   classes = {
--     [0-9] = true / false
--   }
--   glow = {
--     enable
--     count 
--     speed 
--     length
--     thickness
--     xoffset 
--     yoffset 
--     path
--   } 
-- }

-- CONSTANTS -- 

NORMAL_FONT_COLOR = CreateColor(1.0, 0.82, 0.0)
WHITE_FONT_COLOR  = CreateColor(1.0, 1.0, 1.0)
GREEN_FONT_COLOR  = CreateColor(0.1, 1.0, 0.1)
GRAY_FONT_COLOR	  = CreateColor(0.5, 0.5, 0.5)

-- CONFIGURATION MAPPINGS --

local auras_to_blizzard_auras = {
    [1] = {
        name = 'arcane-intellect',
        source = 'MAGE',
        icon = 135932,
        levels = { 23028, 10157, 10156, 1461, 1460, 1459 }
    },
    [2] = {
        name = 'divine-spirit',
        source = 'PRIEST',
        icon = 135898,
        levels = { 27681, 27841, 14819, 14818, 14752 }
    },
    [3] = {
        name = 'mark-of-the-wild',
        source = 'DRUID',
        icon = 136078,
        levels = { 21850, 21849, 9885, 9884, 8907, 5234, 6756, 5232, 1126 }
    },
    [4] = {
        name = 'power-word-fortitude',
        source = 'PRIEST',
        icon = 135987,
        levels = { 21564, 21562, 10938, 10937, 2791, 1245, 1244, 1243 }
    },
    [5] = {
        name = 'shadow-protection',
        source = 'PRIEST',
        icon = 136121,
        levels = { 27683, 10958, 10957, 976 }
    },
    [6] = {
        name = 'thorns',
        source = 'DRUID',
        icon = 136104,
        levels = { 467, 782, 1075, 8914, 9756, 9910 }
    }
}

local classes_to_blizzard_classes = {
    [1] = 'WARRIOR',
    [2] = 'PALADIN',
    [3] = 'HUNTER',
    [4] = 'ROGUE',
    [5] = 'PRIEST',
    [6] = 'SHAMAN',
    [7] = 'MAGE',
    [8] = 'WARLOCK',
    [9] = 'DRUID'
}

local blizzard_locale_to_localization = {
    default = 'english',
    enGB    = 'english',
    enUS    = 'english',
    ruRU    = 'russian'
}

-- DEFINE CUSTOMIZATIONS --

local aura_customz = { 
    auras = {
        [1] = { 
            name = 'arcane-intellect',
            glow = {
                enable = false
            },
            display = {
                casters = true,
            },
            print = {
                casters = true
            }
        },
        [2] = { 
            name = 'divine-spirit',
            glow = {
                enable = false
            },
            display = {
                casters = true,
            },
            print = {
                casters = true
            }
        },
        [3] = { 
            name = 'mark-of-the-wild',
            glow = {
                enable = false
            },
            display = {
                casters = true,
            },
            print = {
                casters = true
            }
        },
        [4] = { 
            name = 'power-word-fortitude',
            glow = {
                enable = false
            },
            display = {
                casters = true,
            },
            print = {
                casters = true
            }
        },
        [5] = { 
            name = 'shadow-protection',
            glow = {
                enable = false
            },
            display = {
                casters = true,
            },
            print = {
                casters = true
            }
        },
        [6] = { 
            name = 'thorns',
            glow = {
                enable = false
            },
            display = {
                casters = true,
            },
            print = {
                casters = true
            }
        }
    },
    internal = {
        debug = false
    },
    localization = {
        auras = {
            english = {
                ['arcane-intellect'] = 'Arcane Intellect',
                ['divine-spirit'] = 'Divine Spirit',
                ['mark-of-the-wild'] = 'Mark of the Wild',
                ['power-word-fortitude'] = 'Power Word: Fortitude',
                ['shadow-protection'] = 'Shadow Protection',
                ['thorns'] = 'Thorns'
            },
            russian = {
                ['arcane-intellect'] = 'Чародейский интеллект',
                ['divine-spirit'] = 'Божественный дух',
                ['mark-of-the-wild'] = 'Знак дикой природы',
                ['power-word-fortitude'] = 'Слово силы: Стойкость',
                ['shadow-protection'] = 'Защиты от темной магии',
                ['thorns'] = 'Шипы'
            }
        },
        strings = {
            english = {
                s_raid              = 'Raid',
                s_group             = 'Group',
                s_party             = 'Party',
                s_party_no_casters  = 'No one in party can cast this aura',
                s_raid_no_casters   = 'No one in raid can cast this aura',
                f_casters           = '%s can cast this aura',
                f_casters_pl        = '%s and %s can cast this aura',
                f_footnotes         = 'Right click to print this information into /%s channel',
                f_group             = 'Group %d',
                f_group_cnt         = '%d of %d',
                f_out_raid_heading  = '"%s" is missed on',
                f_out_party_heading = '"%s" is missed on'
            },
            russian = {
                s_raid              = 'Рейд',
                s_group             = 'Группа',
                s_party             = 'Группа',
                s_party_no_casters  = 'Никто в группе не может наложить этот эффект',
                s_raid_no_casters   = 'Никто в рейде не может наложить этот эффект',
                f_casters           = '%s может наложить этот эффект',
                f_casters_pl        = '%s и %s могут наложить этот эффект',
                f_footnotes         = 'Щелкните правой клавишей мыши чтобы отправить эту информацию в канал /%s',
                f_group             = 'Группа %d',
                f_group_cnt         = '%d из %d',
                f_out_raid_heading  = '"%s" отсутсвует на',
                f_out_party_heading = '"%s" отсутсвует на'
            }
        }
    }
}

function Complement(destination, source)
    if destination == nil and source == nil then
        return nil
    end
    if source == nil then 
        return destination
    end
    if destination == nil then
        if type(source) == 'table' then
            local result = { }
            for key, value in pairs(source) do
                result[key] = Complement(result[key], source[key])
            end
            return result
        end
        return source
    end
    if type(destination) == 'table' then
        if type(source) ~= 'table' then error() end

        local result = Complement(result, destination)
        for key, value in pairs(source) do
            result[key] = Complement(destination[key], source[key])
        end
        return result
    end

    if type(source) == 'table' then error() end
    return destination
end

-- REIMPLEMENT CUSTOMIZATIONS --

aura_env.config = Complement(aura_env.config, aura_customz)

aura_env.helpers = {
}

-- STATIC HELPERS --

-- Static helpers are designed to simplity
-- configuration access, all these functions
-- can be used everywhere inside the application

local function AuraIsInDebug()
    return aura_env.config.internal.debug
end

local function UnitNameSafe(unit)
    return UnitName(unit) or '<unknown>'
end

local LCG = LibStub("LibCustomGlow-1.0")

local function Glow(frame, aura_config) 
    if aura_env.helpers.AuraIsInDebug() then
        print('HELPER: Glowing frame ('..frame:GetName()..'), id ('..aura_config.id..')')
    end
    LCG.PixelGlow_Start(
        frame, 
        aura_config.glow.color, 
        aura_config.glow.count, 
        aura_config.glow.speed, 
        aura_config.glow.length, 
        aura_config.glow.thickness, 
        aura_config.glow.xoffset, 
        aura_config.glow.yoffset, 
        aura_config.glow.path, 
        aura_config.id
    )
end

local function Fade(frame, aura_config)
    if aura_env.helpers.AuraIsInDebug() then
        print('HELPER: Fading frame ('..frame:GetName()..'), id ('..aura_config.id..')')
    end
    LCG.PixelGlow_Stop(frame, aura_config.id)
end

-- Customized version of User-defined wait function
-- from https://wowwiki.fandom.com/wiki/USERAPI_wait

local function DelayExecution(f)
    local capture_aura_env = aura_env

    -- WaitQueue is a global variable
    -- It is required to be global to ensure
    -- life-time binding between WaitQueue and WaitQueueFrame

    if not WaitQueue then
        WaitQueue = { }
    end
    
    -- WaitQueueFrame is a global variable
    -- It is required to reuse the same frame
    
    if not WaitQueueFrame then
        WaitQueueFrame = CreateFrame("Frame", "WaitFrame", UIParent)
        WaitQueueFrame:SetScript(
            "onUpdate",
            function (self, elapse)
                if not aura_env then 
                    aura_env = capture_aura_env 
                end
                
                local count = #WaitQueue
                
                local i = 1
                while i <= count do
                    local fn = tremove(WaitQueue, i)
                    if fn then 
                        fn()
                    end
                    i = i + 1
                end
        end)
    end
    
    tinsert(WaitQueue, f)
    return true
end

aura_env.helpers.DelayExecution = DelayExecution

aura_env.helpers.Glow = Glow
aura_env.helpers.Fade = Fade

aura_env.helpers.AuraIsInDebug = AuraIsInDebug
aura_env.helpers.UnitNameSafe = UnitNameSafe

-- RUNTIME CONFIGURATION --

-- Runtime configuration is created from aura options
-- during initialization
----------------------------
-- DO NOT USE IT DIRECTLY --
----------------------------

local frame_priority = {
    [1] = "^CompactRaid",
    [2] = "^CompactParty"
}

aura_env.runtime = {
    config = {
    },
    helpers = {
    },
    frames = {
    },
    tooltips = {
    },
    combat = false
}

-- RUNTIME HELPERS --

-- Runtime helpers encapsulate stateless functions
-- which can be accessed anywhere after the aure is
-- initialized

local function UnitMatchAuraActivationRules(unit)
    local name = nil
    if aura_env.helpers.AuraIsInDebug() then
        name = aura_env.helpers.UnitNameSafe(unit)
    end
    
    -- CORE RULE
    local in_raid = IsInRaid()
    if (in_raid and not unit:find('^raid%d+')) or (not in_raid and unit ~= 'player' and not unit:find('^party%d+')) then
        if aura_env.helpers.AuraIsInDebug() then
            print('HELPER: '..name..' ('..unit..') doesn\'t match party or raid context')
        end
        return nil
    end
    
    local match_result = nil
    
    -- CLASS RULES
    local _, english_class = UnitClass(unit)
    for aura_name, aura_config in pairs(aura_env.runtime.config) do
        if aura_config.classes[english_class] then
            if aura_env.helpers.AuraIsInDebug() then
                print('HELPER: '..name..' ('..unit..', '..english_class..') matched \''..aura_name..'\':\'class\' activation rule')
            end
            if not match_result then
                match_result = { }
            end
            
            match_result[aura_name] = true
        end
    end
    
    if not english_class then
        english_class = 'UNKNOWN'
    end
    
    if not match_result and aura_env.helpers.AuraIsInDebug() then
        print('HELPER: '..name..' ('..unit..', '..english_class..') doesn\'t match activation rules')
    end
    return match_result
end

local function UnitHasAuras(unit, match_result)
    local name = nil
    if aura_env.helpers.AuraIsInDebug() then
        name = aura_env.helpers.UnitNameSafe(unit)
    end
    
    local aura_result = { }
    for aura_name, aura_config in pairs(aura_env.runtime.config) do
        if match_result[aura_name] then 
            for _, level in ipairs(aura_config.levels) do
                local name = WA_GetUnitAura(unit, level)
                if name then
                    if aura_env.helpers.AuraIsInDebug() then
                        print('HELPER: '..name..' ('..unit..') has '..name..' aura')
                    end
                    
                    aura_result[aura_name] = {
                        match = true,
                        config = aura_config
                    }
                    break
                end
            end
            if not aura_result[aura_name] then
                aura_result[aura_name] = {
                    match = false,
                    config = aura_config
                }
            end
        end
    end
    return aura_result
end

local function UnitFadeAura(unit, aura_config)
    if aura_config.glow.enable then 
        local frame = aura_env.runtime.helpers.GetFrame(unit)
        if frame then
            aura_env.helpers.Fade(frame, aura_config)
        end
    end
end

local function UnitFadeAllAuras(unit)
    local frame = nil
    for aura_name, aura_config in pairs(aura_env.runtime.config) do
        if aura_config.glow.enable then
            if not frame then 
                frame = aura_env.runtime.helpers.GetFrame(unit)
                if not frame then
                    break
                end
            end
            aura_env.helpers.Fade(frame, aura_config)
        end
    end
end

local function UnitGlowAura(unit, aura_config)
    if aura_config.glow.enable then 
        local frame = aura_env.runtime.helpers.GetFrame(unit)
        if frame then
            aura_env.helpers.Glow(frame, aura_config)
        end
    end
end

local function UnitGlowAllAuras(unit, aura_results)
    local frame = nil
    for aura_name, aura_result in pairs(aura_results) do
        if aura_result.config.glow.enable and not aura_result.match then
            if not frame then 
                -- Lazely initialize frame
                -- This can save cycles because inside this function
                -- we don't really know if we would need to update frame
                -- graphics
                -- 
                -- Example case: when leaving combat
                frame = aura_env.runtime.helpers.GetFrame(unit)
                if not frame then
                    break
                end
            end
            aura_env.helpers.Glow(frame, aura_result.config)
        end
    end
end

local function TooltipHide(aura_name)
    local frame = aura_frames[aura_name]
    if frame then
        if aura_env.helpers.AuraIsInDebug() then
            print('HELPER: Hidding tooltip frame for '..aura_name)
        end

        frame:Hide()
    end
end

local function TooltipShow(aura_name)
    local frame = aura_frames[aura_name]
    if frame then
        if aura_env.helpers.AuraIsInDebug() then
            print('HELPER: Showing tooltip frame for '..aura_name)
        end

        local region = WeakAuras.GetRegion(aura_env.id, aura_name)

        frame:ClearAllPoints()
        frame:SetAllPoints(region)
        frame:Show()
    end
end

local function TooltipUpdateContent(aura_name, state)
    if aura_env.helpers.AuraIsInDebug() then
        print('HELPER: Updating '..aura_name..' tooltip content')
    end

    aura_env.runtime.tooltips[aura_name].state = state
end

local function IsInCombat()
    return aura_env.runtime.combat
end

local function EnterCombat()
    if aura_env.helpers.AuraIsInDebug() then
        print('HELPER: Entering combat')
    end
    aura_env.runtime.combat = true
end

local function LeaveCombat()
    if aura_env.helpers.AuraIsInDebug() then
        print('HELPER: Leaving combat')
    end
    aura_env.runtime.combat = false
end

local function ClearFrameCache()
    if aura_env.helpers.AuraIsInDebug() then
        print('HELPER: Clearing frame cache')
    end
    aura_env.runtime.frames = { }
end

-- These frame functions are slightly modified
-- version of GetFrameGeneric function --
-- from: https://wago.io/GetFrameGeneric

local function GetFrames(target)
    local function FindButtonsForUnit(frame, target)
        local results = {}
        if type(frame) == 'table' and not frame:IsForbidden() then
            local type = frame:GetObjectType()
            if type == 'Frame' or type == 'Button' then
                for _, child in ipairs({frame:GetChildren()}) do
                    for _, v in pairs(FindButtonsForUnit(child, target)) do
                        tinsert(results, v)
                    end
                end
            end
            if type == 'Button' then
                local unit = frame:GetAttribute('unit')
                if unit and frame:IsVisible() and frame:GetName() then
                    if aura_env.helpers.AuraIsInDebug() then
                        print('HELPER: Frame ('..frame:GetName()..') bound to unit ('..unit..'), caching')
                    end
                    
                    aura_env.runtime.frames[frame] = unit
                    
                    if UnitIsUnit(unit, target) then
                        tinsert(results, frame)
                    end
                end
            end
        end
        return results
    end
    
    if not UnitExists(target) then
        if type(target) == 'string' and target:find('Player') then
            target = select(6, GetPlayerInfoByGUID(target))
        else
            return {}
        end
    end 
    
    local results = {}
    for frame, unit in pairs(aura_env.runtime.frames) do
        if UnitIsUnit(unit, target) then
            if frame:GetAttribute('unit') == unit then
                if aura_env.helpers.AuraIsInDebug() then
                    print('HELPER: Frame from cache ('..frame:GetName()..')')
                end
                tinsert(results, frame)
            else
                results = {}
                break
            end
        end
    end
    
    return #results > 0 and results or FindButtonsForUnit(UIParent, target)
end

local function GetFrame(target)
    if aura_env.helpers.AuraIsInDebug() then
        local name = aura_env.helpers.UnitNameSafe(target)
        print('HELPER: Framing '..name..' ('..target..')')
    end
    local frames = GetFrames(target)
    if not frames then return nil end
    for i = 1, #frame_priority do
        for _, frame in pairs(frames) do
            if (frame:GetName()):find(frame_priority[i]) then
                return frame
            end
        end
    end
    if aura_env.helpers.AuraIsInDebug() then
        local name = aura_env.helpers.UnitNameSafe(target)
        print('HELPER: '..name..' ('..target..') frame not found')
    end
    return nil
end

aura_env.runtime.helpers.UnitMatchAuraActivationRules = UnitMatchAuraActivationRules
aura_env.runtime.helpers.UnitHasAuras = UnitHasAuras

aura_env.runtime.helpers.UnitFadeAura = UnitFadeAura
aura_env.runtime.helpers.UnitFadeAllAuras = UnitFadeAllAuras

aura_env.runtime.helpers.UnitGlowAura = UnitGlowAura
aura_env.runtime.helpers.UnitGlowAllAuras = UnitGlowAllAuras

aura_env.runtime.helpers.TooltipHide = TooltipHide
aura_env.runtime.helpers.TooltipShow = TooltipShow
aura_env.runtime.helpers.TooltipUpdateContent = TooltipUpdateContent

aura_env.runtime.helpers.IsInCombat  = IsInCombat
aura_env.runtime.helpers.EnterCombat = EnterCombat
aura_env.runtime.helpers.LeaveCombat = LeaveCombat
aura_env.runtime.helpers.ClearFrameCache = ClearFrameCache
aura_env.runtime.helpers.GetFrame = GetFrame

-- LOCAL FUNCTIONS USED IN HOOKS AND STUFF 

local function OutputFormatRaid(state, localization, print_group)
    local buffed, unbuffed = 0, 0
    local raid_groups = { }
    for unit, aura_match in pairs(state.units) do
        local raid_index = UnitInRaid(unit)
        if raid_index then
            local _, _, raid_group_index = GetRaidRosterInfo(raid_index)

            local raid_group = raid_groups[raid_group_index]
            if not raid_group then
                raid_group = { unbuffed = 0, buffed = 0, units = { } }
                raid_groups[raid_group_index] = raid_group
            end

            if aura_match then
                unbuffed = unbuffed + 1
                raid_group.unbuffed = raid_group.unbuffed + 1

                tinsert(raid_group.units, aura_env.helpers.UnitNameSafe(unit))
            else
                buffed = buffed + 1
                raid_group.buffed = raid_group.buffed + 1
            end
        end
    end

    local sraid_groups = { }
    for raid_group_index in pairs(raid_groups) do
        tinsert(sraid_groups, raid_group_index)
    end
    table.sort(sraid_groups, function(x, y) return x < y end)

    for index, raid_group_index in ipairs(sraid_groups) do
        local raid_group = raid_groups[raid_group_index]

        if raid_group.unbuffed > 0 then
            print_group(
                string.format(localization.f_group, raid_group_index),
                string.format(localization.f_group_cnt, raid_group.buffed, raid_group.unbuffed + raid_group.buffed),
                table.concat(raid_group.units, ', '))
        end
    end
end

local function OutputFormatParty(state, localization, print_member)
    for unit, aura_match in pairs(state.units) do
        if aura_match then
            print_member(aura_env.helpers.UnitNameSafe(unit))
        end
    end
end

local function OutputFormatCasters(state, localization, print_all_casters)
    local casters = { count = 0, units = { } }
    for unit in pairs(state.casters) do
        casters.count = casters.count + 1

        tinsert(casters.units, aura_env.helpers.UnitNameSafe(unit))
    end

    local value = nil

    if IsInRaid() then
        value = localization.s_raid_no_casters
    elseif IsInGroup() then
        value = localization.s_party_no_casters
    end

    if casters.count == 1 then
        value = string.format(localization.f_casters, table.concat(casters.units, ', '))
    elseif casters.count > 1 then
        value = string.format(localization.f_casters_pl, table.concat(casters.units, ', ', 1, casters.count - 1), casters.units[casters.count])
    end

    print_all_casters(value)
end

-- AURA INITIALIZATION --

local client_locale = GetLocale();
local locale = blizzard_locale_to_localization[client_locale]

local loc_a = aura_env.config.localization.auras[locale]
local loc_s = aura_env.config.localization.strings[locale]

if aura_env.helpers.AuraIsInDebug() then
    print('Aura version: 1.0.1')
end

for _, aura_config in ipairs(aura_env.config.auras) do
    local blizzard_aura = auras_to_blizzard_auras[aura_config.name]
    if blizzard_aura then
        local aura_name = blizzard_aura.name
        if aura_env.helpers.AuraIsInDebug() then
            print('Enabling tracking of : '..aura_name..' aura')
        end
        
        local runtime_aura_config = {
            id = 'aura:'..aura_name,
            name = aura_name,
            source = blizzard_aura.source,
            icon = blizzard_aura.icon,
            levels = blizzard_aura.levels,
            classes = { },
            glow = { 
                enable    = aura_config.glow.enable,
                color     = aura_config.glow.color, 
                count     = aura_config.glow.count, 
                speed     = aura_config.glow.speed, 
                length    = aura_config.glow.length, 
                thickness = aura_config.glow.thickness, 
                xoffset   = aura_config.glow.xoffset, 
                yoffset   = aura_config.glow.yoffset, 
                path      = aura_config.glow.path
            }
        }

        local runtime_aura_tooltip = { 
            settings = {
                display = {
                    casters = aura_config.display.casters,
                },
                print = {
                    casters = aura_config.print.casters
                }
            },
            localization = {
                s_aura              = loc_a[aura_name],
                s_raid              = loc_s.s_raid,
                s_group             = loc_s.s_group,
                s_party             = loc_s.s_party,
                s_party_no_casters  = loc_s.s_party_no_casters,
                s_raid_no_casters   = loc_s.s_raid_no_casters,
                f_casters           = loc_s.f_casters,
                f_casters_pl        = loc_s.f_casters_pl,
                f_footnotes         = loc_s.f_footnotes,
                f_group             = loc_s.f_group,
                f_group_cnt         = loc_s.f_group_cnt,
                f_out_raid_heading  = loc_s.f_out_raid_heading,
                f_out_party_heading = loc_s.f_out_party_heading
            }
        }
        
        for index, enabled in ipairs(aura_config.classes) do
            local blizzard_class = classes_to_blizzard_classes[index]
            if aura_env.helpers.AuraIsInDebug() and enabled then
                print('- Tracking : '..blizzard_class..' class')
            end
            
            runtime_aura_config.classes[blizzard_class] = enabled   
        end
        
        if not aura_frames then
            aura_frames = { }
        end
        if not aura_frames[aura_name] then
            -- Create non-secure frame with UIParent
            local frame = CreateFrame("Frame", runtime_aura_config.id, UIParent)

            -- Set frame strata to DIALOG to ensure it will overlay aura icons
            frame:SetFrameStrata("DIALOG")
            frame:SetScript(
                "OnEnter",
                function ()
                    GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
                    GameTooltip:ClearLines()

                    local state = aura_env.runtime.tooltips[aura_name].state
                    if not state then 
                        return
                    end

                    local settings = aura_env.runtime.tooltips[aura_name].settings
                    local localization = aura_env.runtime.tooltips[aura_name].localization

                    if IsInRaid() then 
                        -- Update tooltip content using the following template:
                        -- Aura                       Raid
                        -- Name, Name and Name can cast 
                        -- this aura
                        --
                        -- Group 1                  3 of 5
                        -- Name, Name
                        --
                        -- Group 2                  2 of 3
                        -- Name
                        -- ... etc
                        --
                        -- Right click to print this 
                        -- information into /raid channel

                        GameTooltip:AddDoubleLine(
                            localization.s_aura, 
                            localization.s_raid, 
                            NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 
                            GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)

                        if settings.display.casters then
                            OutputFormatCasters(
                                state, 
                                localization,
                                function (all_casters_str) 
                                    GameTooltip:AddLine(all_casters_str, WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b, 1) 
                                end);
                        end

                        GameTooltip:AddLine(' ')

                        OutputFormatRaid(
                            state,
                            localization,
                            function (group_str, group_cnts_str, group_members_str)
                                GameTooltip:AddDoubleLine(
                                    group_str,
                                    group_cnts_str, 
                                    NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 
                                    GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)

                                GameTooltip:AddLine(
                                    group_members_str, 
                                    WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
                            end)

                        GameTooltip:AddLine(' ')
                        GameTooltip:AddLine(
                            string.format(localization.f_footnotes, string.lower(localization.s_raid)),
                            GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, 1)
                    elseif IsInGroup() then
                        -- Update tooltip content using the following template:
                        -- Aura                      Party
                        -- Name, Name and Name can cast 
                        -- this aura
                        --
                        -- Group
                        -- Name
                        -- Name
                        -- ... etc
                        --
                        -- Right click to print this 
                        -- information into /group channel

                        GameTooltip:AddDoubleLine(
                            localization.s_aura, 
                            localization.s_party, 
                            NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 
                            GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)

                        if settings.display.casters then
                            OutputFormatCasters(
                                state, 
                                localization,
                                function (all_casters_str) 
                                    GameTooltip:AddLine(all_casters_str, WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b, 1) 
                                end);
                        end

                        GameTooltip:AddLine(' ')

                        GameTooltip:AddLine(
                            localization.s_group,
                            NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

                        OutputFormatParty(
                            state, 
                            localization,
                            function (member_str) 
                                GameTooltip:AddLine(member_str, WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b) 
                            end);

                        GameTooltip:AddLine(' ')
                        GameTooltip:AddLine(
                            string.format(localization.f_footnotes, string.lower(localization.s_party)),
                            GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, 1)
                    else
                        error('The aura is supposed to be active in raid or group only.')
                    end

                    GameTooltip:Show()
            end)
            frame:SetScript(
                "OnLeave",
                function ()
                    GameTooltip:Hide()
            end)
            frame:SetScript(
                "OnMouseDown",
                function (self, button)
                    if button == 'RightButton' then 
                        local state = aura_env.runtime.tooltips[aura_name].state
                        if not state then 
                            return
                        end

                        local settings = aura_env.runtime.tooltips[aura_name].settings
                        local localization = aura_env.runtime.tooltips[aura_name].localization

                        if IsInRaid() then 
                            -- Prints information about raid auras using the following template:
                            -- "Aura" is missed on the following raid members:
                            -- > Group 1: Name, Name
                            -- > Group 2: Name
                            -- ... etc
                            -- * Name, Name and Name can cast this aura
                            SendChatMessage(
                                string.format(
                                    '%s:', 
                                    string.format(localization.f_out_raid_heading, localization.s_aura)), 
                                'RAID')    

                            OutputFormatRaid(
                                state,
                                localization,
                                function (group_str, _, group_members_str)
                                    SendChatMessage(string.format('> %s: %s', group_str, group_members_str), 'RAID');
                                end)

                            if settings.print.casters then
                                OutputFormatCasters(
                                    state, 
                                    localization,
                                    function (all_casters_str) 
                                        SendChatMessage('* '..all_casters_str, 'RAID') 
                                    end);
                            end
                        elseif IsInGroup() then
                            -- Prints information about group auras using the following template:
                            -- "Aura" is missed on:
                            -- > Name
                            -- > Name
                            -- ... etc
                            -- * Name, Name and Name can cast this aura

                            SendChatMessage(
                                string.format(
                                    '%s:', 
                                    string.format(localization.f_out_party_heading, localization.s_aura)), 
                                'PARTY')

                            OutputFormatParty(  
                                state, 
                                localization,
                                function (member_str) 
                                    SendChatMessage('> '..member_str, "PARTY") 
                                end);

                            if settings.print.casters then
                                OutputFormatCasters(
                                    state, 
                                    localization,
                                    function (all_casters_str) 
                                        SendChatMessage('* '..all_casters_str, 'PARTY') 
                                    end);
                            end
                        else
                            error('The aura is supposed to be active in raid or group only.')
                        end
                    end
            end)

            -- We need to hide frame initially, because if at first aura initialization raid or group
            -- has all buffs (nothing to show), the transparent frame will react on mouse events
            -- and cause errors
            frame:Hide()

            -- Store frame
            aura_frames[aura_name] = frame
        end

        aura_env.runtime.config[aura_name] = runtime_aura_config
        aura_env.runtime.tooltips[aura_name] = runtime_aura_tooltip
    end
end