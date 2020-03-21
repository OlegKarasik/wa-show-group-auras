-- CONFIGURATION MAPPINGS --

local auras_to_blizzard_auras = {
    [1] = {
        name = 'arcane-intellegence',
        ids = { 23028, 10157, 10156, 1461, 1460, 1459 }
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

local function GetFrameAuraKey(aura)
    return 'aura:'..aura
end

local LCG = LibStub("LibCustomGlow-1.0")

local function Glow(frame, id) 
    if aura_env.helpers.AuraIsInDebug() then
        print('HELPER: Glowing frame ('..frame:GetName()..'), id ('..id..')')
    end
    LCG.PixelGlow_Start(
        frame, 
        aura_env.config.glow.color, 
        aura_env.config.glow.count, 
        aura_env.config.glow.speed, 
        nil, 
        aura_env.config.glow.thickness, 
        aura_env.config.glow.xoffset, 
        aura_env.config.glow.yoffset, 
        aura_env.config.glow.path, 
        id
    )
end

local function Fade(frame, id)
    if aura_env.helpers.AuraIsInDebug() then
        print('HELPER: Fading frame ('..frame:GetName()..'), id ('..id..')')
    end
    LCG.PixelGlow_Stop(frame, id)
end

-- Customized version of User-defined wait function
-- from https://wowwiki.fandom.com/wiki/USERAPI_wait

local WaitQueue = { };
local WaitQueueFrame = nil;

local WaitClosure = aura_env

local function DelayExecution(f)
    if not WaitQueueFrame then
        WaitQueueFrame = CreateFrame("Frame", "WaitFrame", UIParent);
        WaitQueueFrame:SetScript(
            "onUpdate",
            function (self, elapse)
                local count = #WaitQueue;

                local i = 1;
                while i <= count do
                    local fn = tremove(WaitQueue, i);
                    if fn then 
                        fn()
                    end
                    i = i + 1
                end
            end);
    end

    tinsert(WaitQueue, f);
    return true;
end

aura_env.helpers.DelayExecution = DelayExecution

aura_env.helpers.Glow = Glow
aura_env.helpers.Fade = Fade

aura_env.helpers.AuraIsInDebug = AuraIsInDebug
aura_env.helpers.UnitNameSafe = UnitNameSafe
aura_env.helpers.GetFrameAuraKey = GetFrameAuraKey

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
        classes ={
        },
        auras = {
            ['arcane-intellegence'] = { 23028, 10157, 10156, 1461, 1460, 1459 }
        }
    },
    helpers = {
    },
    frames = {
    },
    combat = false
}


-- RUNTIME HELPERS --

-- Runtime helpers encapsulate stateless functions
-- which can be accessed anywhere after the aure is
-- initialized

local function UnitMatchAuraActivationRules(unit, aura_name)
    local name = nil
    if aura_env.helpers.AuraIsInDebug() then
        name = aura_env.helpers.UnitNameSafe(unit)
    end
    
    -- CORE RULE
    if (IsInRaid() and not unit:find('^raid%d+')) or (unit ~= 'player' and not unit:find('^party%d+')) then
        if aura_env.helpers.AuraIsInDebug() then
            print('HELPER: '..name..' ('..unit..') doesn\'t match party or raid context.')
        end
        return false
    end

    -- CLASS RULES
    local aura_config = aura_env.runtime.config.auras[aura_name]

    local _, english_class = UnitClass(unit)
    if aura_config.classes[english_class] then
        if aura_env.helpers.AuraIsInDebug() then
            print('HELPER: '..name..' ('..unit..', '..english_class..') matched \'class\' activation rule')
        end
        return true
    end
    
    if not english_class then
        english_class = 'UNKNOWN'
    end
    
    if aura_env.helpers.AuraIsInDebug() then
        print('HELPER: '..name..' ('..unit..', '..english_class..') doesn\'t match activation rules')
    end
    return false
end

local function UnitHasAuras(unit)
    local result = { }
    for aura_name, aura_ids in pairs(aura_env.runtime.config.auras) do
        for _, id in ipairs(aura_ids) do
            local name = WA_GetUnitAura(unit, id)
            if name then
                result[aura_name] = true
                break
            end
        end
        if not result[aura_name] then
            result[aura_name] = false
        end
    end
    return result
end

local function UnitFadeAura(unit, aura_name)
    local frame = aura_env.runtime.helpers.GetFrame(unit)
    if frame then
        aura_env.helpers.Fade(frame, aura_env.helpers.GetFrameAuraKey(aura_name))
    end
end

local function UnitFadeAllAuras(unit)
    local frame = aura_env.runtime.helpers.GetFrame(unit)
    if frame then
        for aura_name, _ in pairs(aura_env.runtime.config.auras) do
            aura_env.helpers.Fade(frame, aura_env.helpers.GetFrameAuraKey(aura_name))
        end
    end
end

local function UnitGlowAura(unit, aura_name)
    local frame = aura_env.runtime.helpers.GetFrame(unit)
    if frame then
        aura_env.helpers.Glow(frame, aura_env.helpers.GetFrameAuraKey(aura_name))
    end
end

local function UnitGlowAllAuras(unit, aura_result)
    local frame = nil
    for aura_name, aura_match in pairs(aura_result) do
        if not aura_match then
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

            aura_env.helpers.Glow(frame, aura_env.helpers.GetFrameAuraKey(aura_name))
        end
    end
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
                for _,child in ipairs({frame:GetChildren()}) do
                    for _,v in pairs(FindButtonsForUnit(child, target)) do
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
    for i=1, #frame_priority do
        for _,frame in pairs(frames) do
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

aura_env.runtime.helpers.IsInCombat  = IsInCombat
aura_env.runtime.helpers.EnterCombat = EnterCombat
aura_env.runtime.helpers.LeaveCombat = LeaveCombat
aura_env.runtime.helpers.ClearFrameCache = ClearFrameCache
aura_env.runtime.helpers.GetFrame = GetFrame

-- AURA INITIALIZATION --

if aura_env.helpers.AuraIsInDebug() then
    print('Aura version: 0.1')
end

for _, aura_config in pairs(aura_env.config.auras) do
    local blizzard_aura = auras_to_blizzard_auras[aura_config.aura]
    if blizzard_aura then
        local aura_name = blizzard_aura.name
        if aura_env.helpers.AuraIsInDebug() then
            print('Enabling tracking of : '..aura_name..' aura')
        end

        aura_env.runtime.config[aura_name] = {
            ids = blizzard_aura.ids,
            classes = { }
        }

        for class, enabled in ipairs(aura_config.classes) do
            local blizzard_class = classes_to_blizzard_classes[class]
            if aura_env.helpers.AuraIsInDebug() and enabled then
                print('- Tracking : '..blizzard_class..' class')
            end
            
            aura_env.runtime.config[aura_name].classes[blizzard_class] = enabled   
        end
    end
end