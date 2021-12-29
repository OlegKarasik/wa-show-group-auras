-- Initialize luaunit
local lu = require('luaunit')

-- Initialize mocks
require('ut-mocks')

-- Initialize aura
require('aura-init')

-- Tests for aura activation rules in raid
TestUnitMatchAuraActivationRulesInRaid = { }
function TestUnitMatchAuraActivationRulesInRaid:Setup()
    _G.IsInRaid  = function () return true end
    _G.UnitClass = function () return 'Warrior', 'WARRIOR' end

    -- Setup temporary cache
    aura_env.runtime.config_cache.classes['WARRIOR'] = {
        ['ut-aura-match'] = true
    }
end

function TestUnitMatchAuraActivationRulesInRaid:TestRaidMembersShouldMatch()
    -- Run
    for i = 0, 39 do 
        local match_result = aura_env.runtime.helpers.UnitMatchAuraActivationRules('raid'..tostring(i))
        lu.assertNotNil(match_result, 'Unit (raid'..tostring(i)..') should match aura activation rules')
        lu.assertTrue(match_result['ut-aura-match'], 'Unit should match "ut-aura-match" aura activation rules')
    end
end

function TestUnitMatchAuraActivationRulesInRaid:TestRaidPetMembersShouldntMatch()
    -- Run
    for i = 0, 39 do 
        local match_result = aura_env.runtime.helpers.UnitMatchAuraActivationRules('raidpet'..tostring(i))
        lu.assertNil(match_result, 'Unit (raidpet'..tostring(i)..') shouldn\'t match aura activation rules')
    end
end

function TestUnitMatchAuraActivationRulesInRaid:TestPlayerShouldntMatch()
    -- Run
    local match_result = aura_env.runtime.helpers.UnitMatchAuraActivationRules('player')
    lu.assertNil(match_result, 'Unit (player) shouldn\'t match aura activation rules')
end

function TestUnitMatchAuraActivationRulesInRaid:Teardown()
    _G.IsInRaid  = nil
    _G.UnitClass = nil

    -- Cleanup usage of config_cache (by default it's classes table isn't initialized)
    aura_env.runtime.config_cache.classes = { }
end

-- Tests for aura activation rules in party
TestUnitMatchAuraActivationRulesInParty = { }
function TestUnitMatchAuraActivationRulesInParty:Setup()
    _G.IsInRaid  = function () return false end
    _G.UnitClass = function () return 'Warrior', 'WARRIOR' end

    -- Setup temporary cache
    aura_env.runtime.config_cache.classes['WARRIOR'] = {
        ['ut-aura-match'] = true
    }
end

function TestUnitMatchAuraActivationRulesInParty:TestGroupMembersShouldMatch()
    -- Run
    for i = 1, 5 do 
        local match_result = aura_env.runtime.helpers.UnitMatchAuraActivationRules('party'..tostring(i))
        lu.assertNotNil(match_result, 'Unit (party'..tostring(i)..') should match aura activation rules')
        lu.assertTrue(match_result['ut-aura-match'], 'Unit should match "ut-aura-match" aura activation rules')
    end
end

function TestUnitMatchAuraActivationRulesInParty:TestGroupPetMembersShouldntMatch()
    -- Run
    for i = 1, 5 do 
        local match_result = aura_env.runtime.helpers.UnitMatchAuraActivationRules('partypet'..tostring(i))
        lu.assertNil(match_result, 'Unit (partypet'..tostring(i)..') shouldn\'t match aura activation rules')
    end
end

function TestUnitMatchAuraActivationRulesInParty:TestPlayerShouldMatch()    -- Inject
    -- Inject
    aura_env.runtime.config_cache.classes['WARRIOR'] = {
        ['ut-aura-match'] = true
    }

    -- Run
    local match_result = aura_env.runtime.helpers.UnitMatchAuraActivationRules('player')
    lu.assertNotNil(match_result, 'Unit (player) should match aura activation rules')
    lu.assertTrue(match_result['ut-aura-match'], 'Unit should match "ut-aura-match" aura activation rules')
end

function TestUnitMatchAuraActivationRulesInParty:Teardown()
    _G.IsInRaid  = nil
    _G.UnitClass = nil

    -- Cleanup usage of config_cache (by default it's classes table isn't initialized)
    aura_env.runtime.config_cache.classes = { }
end

-- Tests for combat state
TestCombatState = { }
function TestCombatState:Setup()
    -- Set default value
    aura_env.runtime.state.combat = false
end

function TestCombatState:TestEnterCombat()
    -- Run
    aura_env.runtime.helpers.EnterCombat()
    local result = aura_env.runtime.helpers.Combat()

    -- Assert
    lu.assertTrue(aura_env.runtime.state.combat, 'Now, there should be combat')
end

function TestCombatState:TestLeaveCombat()
    -- Run
    aura_env.runtime.helpers.LeaveCombat()
    local result = aura_env.runtime.helpers.Combat()

    -- Assert
    lu.assertFalse(result, 'Now, there should be no combat')
end

function TestCombatState:Teardown()
    -- Set default value
    aura_env.runtime.state.combat = false
end

-- Execute Tests
os.exit(lu.LuaUnit.run())