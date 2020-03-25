function(allstates, event, unit)
    local function UpdateUnitAuraStates(states, unit, aura_results)
        for aura_name, aura_result in pairs(aura_results) do
            if not states[aura_name] then
                states[aura_name] = {
                    icon = aura_result.config.icon,
                    matchCount = 0,
                    units = { 
                    }
                }
            end
            if not aura_result.match then
                states[aura_name].matchCount = states[aura_name].matchCount + 1
            end
            states[aura_name].units[unit] = not aura_result.match
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
        
        -- Iterate over raid or party restoring auras states for each unit
        local unit_results = { }
        
        for unit in WA_IterateGroupMembers() do
            -- Include unit into unit_results
            unit_results[unit] = { }

            if aura_env.runtime.helpers.UnitMatchAuraActivationRules(unit) then
                local aura_results = aura_env.runtime.helpers.UnitHasAuras(unit)

                UpdateUnitAuraStates(states, unit, aura_results)

                -- Set unit aura results
                unit_results[unit] = aura_results
            end
        end

        -- Visual Update
        aura_env.helpers.DelayExecution(
            function ()
                aura_env.runtime.helpers.ClearFrameCache()
                
                for unit, aura_results in pairs(unit_results) do
                    aura_env.runtime.helpers.UnitFadeAllAuras(unit)
                    aura_env.runtime.helpers.UnitGlowAllAuras(unit, aura_results)
                end
            end)
        --

        -- Control aura display
        for aura_name, state in pairs(states) do
            state.show = state.matchCount > 0
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

        -- Iterate over the states and 
        -- include all units with auras to fade table
        local units_to_fade = { }
        
        for aura_name, state in pairs(allstates) do
            for unit, match in pairs(state.units) do
                if match then
                    units_to_fade[unit] = true
                end
            end
            
            -- Deactivate
            state.show = false
            state.changed = true
        end

        -- Visual Update
        aura_env.helpers.DelayExecution(
            function ()
                aura_env.runtime.helpers.ClearFrameCache()
                
                for unit in pairs(units_to_fade) do
                    aura_env.runtime.helpers.UnitFadeAllAuras(unit)
                end
            end)
        --
        
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

        -- Iterate over raid or party restoring auras states for each unit
        local unit_results = { }
        
        for unit in WA_IterateGroupMembers() do
            -- Include unit into unit_results
            unit_results[unit] = { }

            if aura_env.runtime.helpers.UnitMatchAuraActivationRules(unit) then
                local aura_results = aura_env.runtime.helpers.UnitHasAuras(unit)

                UpdateUnitAuraStates(states, unit, aura_results)

                -- Set unit aura results
                unit_results[unit] = aura_results
            end
        end

        -- Visual Update
        aura_env.helpers.DelayExecution(
            function ()
                aura_env.runtime.helpers.ClearFrameCache()
                
                for unit, aura_results in pairs(unit_results) do
                    aura_env.runtime.helpers.UnitFadeAllAuras(unit)
                    aura_env.runtime.helpers.UnitGlowAllAuras(unit, aura_results)
                end
            end)
        --

        -- Control aura display
        for aura_name, state in pairs(states) do
            state.show = state.matchCount > 0
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
        
        local name = nil
        if aura_env.helpers.AuraIsInDebug() then
            name = aura_env.helpers.UnitNameSafe(unit)
        end

        local result = false

        local aura_results = aura_env.runtime.helpers.UnitHasAuras(unit)
        for aura_name, aura_result in pairs(aura_results) do
            local state = allstates[aura_name]
            repeat
                if aura_result.match then
                    if state then
                        if not state.units[unit] then
                            if aura_env.helpers.AuraIsInDebug() then
                                print('TRIGGER: '..name..' ('..unit..') has \''..aura_name..'\', state found, no changes, skipping') 
                            end
                            
                            break
                        end
                        
                        if aura_env.helpers.AuraIsInDebug() then
                            print('TRIGGER: '..name..' ('..unit..') has \''..aura_name..'\', state found, marking') 
                        end
                        
                        state.show = state.matchCount > 1
                        state.changed = true
                        state.icon = aura_result.config.icon
                        state.matchCount = state.matchCount - 1
                        state.units[unit] = false
                    else
                        if aura_env.helpers.AuraIsInDebug() then
                            print('TRIGGER: '..name..' ('..unit..') has \''..aura_name..'\', state not found, skipping')
                        end
                        
                        -- Just do nothing and proceed to next aura
                        break
                    end

                    -- Visual Update
                    aura_env.helpers.DelayExecution(
                        function ()
                            aura_env.runtime.helpers.UnitFadeAura(unit, aura_result.config)
                        end)
                    --

                    result = true
                    break
                end
                
                if state then
                    if state.units[unit] then
                        if aura_env.helpers.AuraIsInDebug() then
                            print('TRIGGER: '..name..' ('..unit..') has no \''..aura_name..'\', state found, no changes, skipping')
                        end
                        
                        break
                    end
                    
                    if aura_env.helpers.AuraIsInDebug() then
                        print('TRIGGER: '..name..' ('..unit..') has no \''..aura_name..'\', state found, marking')
                    end
                    
                    state.show = true
                    state.changed = true
                    state.icon = aura_result.config.icon
                    state.matchCount = state.matchCount + 1
                    state.units[unit] = true
                else
                    if aura_env.helpers.AuraIsInDebug() then
                        print('TRIGGER: '..name..' ('..unit..') has no \''..aura_name..'\', state not found, marking')
                    end
                    
                    allstates[aura_name] = {
                        show = true,
                        changed = true,
                        icon = aura_result.config.icon,
                        matchCount = 1,
                        units = {
                            [unit] = true
                        }
                    }
                end

                -- Visual Update
                aura_env.helpers.DelayExecution(
                    function ()
                        aura_env.runtime.helpers.UnitGlowAura(unit, aura_result.config)
                    end)
                --

                result = true
                break
            until true
        end
        
        return result
    end
    
    return false 
end