function(allstates, event, unit)
    local function UpdateUnitAuraStates(states, unit, aura_result)
        for aura_name, aura_match in pairs(aura_result) do
            if not state[aura_name] then
                state[aura_name] = {
                    matchCount = 0,
                    units = { 
                    }
                }
            end
            if aura_match then
                state[aura_name].matchCount = state[aura_name].matchCount + 1
            end
            state[aura_name].units[unit] = aura_match
        end
    end
    if event == 'GROUP_ROSTER_UPDATE' then
        if aura_env.helpers.AuraIsInDebug() then
            print('TRIGGER: GROUP_ROSTER_UPDATE')
        end
        
        if aura_env.runtime.helpers.IsInCombat() then
            if aura_env.helpers.AuraIsInDebug() then
                print('TRIGGER: In combat, ignoring') 
            end
            return false
        end
        
        -- Initialize empty auras states
        local states = { }
        
        -- Clear frame cache to ensure all auras 
        -- are cleared as expected
        aura_env.runtime.helpers.ClearFrameCache()
        
        -- Iterate over raid or party restoring auras states and glows
        for member in WA_IterateGroupMembers() do
            local normalized_unit = aura_env.helpers.NormalizeUnit(member)
            if normalized_unit then
                aura_env.runtime.helpers.UnitFadeAllAuras(normalized_unit)

                if aura_env.runtime.helpers.UnitMatchAuraActivationRules(normalized_unit) then
                    local aura_result = aura_env.runtime.helpers.UnitGetAuras(normalized_unit)

                    UpdateUnitAuraStates(states, unit, aura_result)

                    aura_env.runtime.helpers.UnitGlowAllAuras(normalized_unit, aura_result)
                end
            end
        end

        -- Control aura display
        for aura_name, state in pairs(states) do
            if state.matchCount > 0 then
                state.show = true
            end
            state.changed = true

            allstates[aura_name] = state
        end

        return true
    end
    if event == 'PLAYER_REGEN_DISABLED' then
        if aura_env.helpers.AuraIsInDebug() then
            print('TRIGGER: PLAYER_REGEN_DISABLED')
        end
            
        if aura_env.helpers.AuraIsInDebug() then
            print('TRIGGER: Entering combat') 
        end
        
        for aura_name, state in pairs(allstates) do
            for unit, match in pairs(state.units) do
                local name = nil
                if aura_env.helpers.AuraIsInDebug() then
                    name = UnitName(unit)
                end

                if match then
                    aura_env.runtime.helpers.UnitFadeAllAuras(unit)
                end
            end
            
            state.show = false
            state.changed = true
        end
        
        aura_env.runtime.helpers.EnterCombat()
        
        return true
    end
    if event == 'PLAYER_REGEN_ENABLED' then
        if aura_env.helpers.AuraIsInDebug() then
            print('TRIGGER: PLAYER_REGEN_ENABLED')
        end
        
        if aura_env.helpers.AuraIsInDebug() then
            print('TRIGGER: Leaving combat') 
        end

        -- Initialize empty auras states
        local states = { }
        
        -- Clear frame cache to ensure all auras 
        -- are cleared as expected
        aura_env.runtime.helpers.ClearFrameCache()
        
        -- Iterate over raid or party restoring auras states and glows
        for member in WA_IterateGroupMembers() do
            local normalized_unit = aura_env.helpers.NormalizeUnit(member)
            if normalized_unit then
                if aura_env.runtime.helpers.UnitMatchAuraActivationRules(normalized_unit) then
                    local aura_result = aura_env.runtime.helpers.UnitGetAuras(normalized_unit)
                    
                    UpdateUnitAuraStates(states, unit, aura_result)
                    
                    aura_env.runtime.helpers.UnitGlowAllAuras(normalized_unit, aura_result)
                end
            end
        end

        -- Control aura display
        for aura_name, state in pairs(states) do
            if state.matchCount > 0 then
                state.show = true
            end
            state.changed = true

            allstates[aura_name] = state
        end
        
        aura_env.runtime.helpers.LeaveCombat()
        
        return true
    end
    if event == 'UNIT_AURA' and unit then
        if aura_env.helpers.AuraIsInDebug() then
            print('TRIGGER: UNIT_AURA')
        end
        
        if aura_env.runtime.helpers.IsInCombat() then
            if aura_env.helpers.AuraIsInDebug() then
                print('TRIGGER: In combat, ignoring') 
            end
            return false
        end
        
        if not aura_env.runtime.helpers.UnitMatchAuraActivationRules(unit) then
            return false
        end
        
        local normalized_unit = aura_env.helpers.NormalizeUnit(unit)
        if not normalized_unit then
            return false
        end

        local name = nil
        if aura_env.helpers.AuraIsInDebug() then
            name = UnitName(normalized_unit)
        end

        local result = false

        local aura_result = aura_env.runtime.helpers.UnitHasAuras(normalized_unit)
        for aura_name, aura_match in pairs(aura_result) do
            local state = allstates[aura_name]
            repeat
                if aura_match then
                    if state then
                        if not state.units[normalized_unit] then
                            if aura_env.helpers.AuraIsInDebug() then
                                print('TRIGGER: '..name..' ('..normalized_unit..') has aura, state found, no changes, skipping') 
                            end
                            
                            break
                        end
                        
                        if aura_env.helpers.AuraIsInDebug() then
                            print('TRIGGER: '..name..' ('..normalized_unit..') has aura, state found, marking') 
                        end
                        
                        state.show = true
                        state.changed = true
                        state.matchCount = state.matchCount - 1
                        state.units[unit] = false
                    else
                        if aura_env.helpers.AuraIsInDebug() then
                            print('TRIGGER: '..name..' ('..normalized_unit..') has aura, state not found, marking')
                        end
                        
                        allstates[aura_name] = {
                            show = true,
                            changed = true,
                            matchCount = 0,        
                            units = {
                                [unit] = false
                            }
                        }
                    end

                    aura_env.runtime.helpers.UnitFadeAura(unit, aura_name)

                    result = true
                    break
                end
                
                if state then
                    if state.units[unit] then
                        if aura_env.helpers.AuraIsInDebug() then
                            print('TRIGGER: '..name..' ('..normalized_unit..') has no aura, state found, no changes, skipping')
                        end
                        
                        break
                    end
                    
                    if aura_env.helpers.AuraIsInDebug() then
                        print('TRIGGER: '..name..' ('..normalized_unit..') has no aura, state found, marking')
                    end
                    
                    state.show = true
                    state.changed = true
                    state.matchCount = state.matchCount + 1
                    state.units[unit] = true
                else
                    if aura_env.helpers.AuraIsInDebug() then
                        print('TRIGGER: '..name..' ('..normalized_unit..') has no aura, state not found, marking')
                    end
                    
                    allstates['player'] = {
                        show = true,
                        changed = true,
                        matchCount = 1,
                        units = {
                            [unit] = true
                        }
                    }
                end
                aura_env.runtime.helpers.UnitGlowAura(unit, aura_name)

                result = true
                break
            until true
        end
        
        return result
    end
    
    return false 
end