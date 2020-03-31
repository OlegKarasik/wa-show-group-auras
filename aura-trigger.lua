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
    if event == 'OPTIONS' then
        if aura_env.helpers.AuraIsInDebug() then
            print('TRIGGER: OPTIONS')
        end
        -- We aren't deferring this execution to a frame
        -- event loop because we actually don't expect dynamic
        -- changes here

        -- Iterate over all auras and hide their tooltips
        -- This is required to ensure proper initial state after aura reinitialization
        for aura_name, aura_config in pairs(aura_env.runtime.config) do
            aura_env.runtime.helpers.TooltipHide(aura_name)
        end

        -- Clear the cache
        aura_env.runtime.helpers.ClearFrameCache()
        
        -- Iterate over raid or party and clear all possible auras
        -- This is required to enable "aura enable / disable functionality"
        for unit in WA_IterateGroupMembers() do
            for aura_name, aura_config in pairs(aura_env.runtime.config) do
                local frame = aura_env.runtime.helpers.GetFrame(unit)
                if frame then
                    aura_env.helpers.Fade(frame, aura_config)
                end
            end
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
            
            -- Find out whether unit matches any of the aura rules
            local match_result = aura_env.runtime.helpers.UnitMatchAuraActivationRules(unit)
            if match_result then 
                local aura_results = aura_env.runtime.helpers.UnitHasAuras(unit, match_result)
                
                UpdateUnitAuraStates(states, unit, aura_results)
                
                -- Set unit aura results
                unit_results[unit] = aura_results
            end
        end
        
        -- Visual Update
        aura_env.helpers.DelayExecution(
            function ()
                for aura_name, state in pairs(states) do
                    if state.matchCount > 0 then
                        aura_env.runtime.helpers.TooltipShow(aura_name, { 'matched', tostring(state.matchCount) })
                    else 
                        aura_env.runtime.helpers.TooltipHide(aura_name)
                    end
                end

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
                for aura_name, aura_config in pairs(aura_env.runtime.config) do
                    aura_env.runtime.helpers.TooltipHide(aura_name)
                end

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
            
            -- Find out whether unit matches any of the aura rules
            local match_result = aura_env.runtime.helpers.UnitMatchAuraActivationRules(unit)
            if match_result then 
                local aura_results = aura_env.runtime.helpers.UnitHasAuras(unit, match_result)
                
                UpdateUnitAuraStates(states, unit, aura_results)
                
                -- Set unit aura results
                unit_results[unit] = aura_results
            end
        end
        
        -- Visual Update
        aura_env.helpers.DelayExecution(
            function ()
                for aura_name, state in pairs(states) do
                    if state.matchCount > 0 then
                        aura_env.runtime.helpers.TooltipShow(aura_name, { 'matched', tostring(state.matchCount) })
                    end
                end

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
        
        local match_result = aura_env.runtime.helpers.UnitMatchAuraActivationRules(unit)
        if not match_result then
            return false
        end
        
        local name = nil
        if aura_env.helpers.AuraIsInDebug() then
            name = aura_env.helpers.UnitNameSafe(unit)
        end
        
        local result = false
        
        local aura_results = aura_env.runtime.helpers.UnitHasAuras(unit, match_result)
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
                            if state.matchCount == 0 then 
                                aura_env.runtime.helpers.TooltipHide(aura_result.config.name)
                            end

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
                local state = allstates[aura_name]

                aura_env.helpers.DelayExecution(
                    function ()
                        if state.matchCount == 1 then 
                            aura_env.runtime.helpers.TooltipShow(aura_result.config.name, { 'matched', tostring(state.matchCount) })
                        end
                        
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