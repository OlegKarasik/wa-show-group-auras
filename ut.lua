-- Initialize luaunit
local lu = require('luaunit')

-- Initialize mocks
require('ut-mocks')

-- Initialize aura
require('aura-init')

-- Tests
TestUnitMatchAuraActivationRulesInRaid = { }
function TestUnitMatchAuraActivationRulesInRaid:Setup()
    _G.IsInRaid  = function () return true end
    _G.UnitClass = function () return 'Warrior', 'WARRIOR' end
end

function TestUnitMatchAuraActivationRulesInRaid:TestRaidMembersShouldMatch()
    -- Inject
    aura_env.runtime.config_cache.classes['WARRIOR'] = {
        ['ut-aura-match'] = true
    }

    -- Run
    for i = 0, 39 do 
        local match_result = aura_env.runtime.helpers.UnitMatchAuraActivationRules('raid'..tostring(i))
        lu.assertNotNil(match_result, 'Unit (raid'..tostring(i)..') should match aura activation rules')
        lu.assertItemsEquals(match_result, { ['ut-aura'] = true })
    end
end

function TestUnitMatchAuraActivationRulesInRaid:TestRaidPetsMembersShouldntMatch()
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
end

-- Execute Tests
os.exit(lu.LuaUnit.run())