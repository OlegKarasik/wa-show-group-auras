function(allstates, event, unit)
    local function UpdateStateUnitAuraResult(state, unit, aura_result)
        for aura_name, aura_match in pairs(aura_result) do
            if not state.auras[aura_name] then
                state.auras[aura_name] = {
                    matchCount = 0,
                    units = { 
                    }
                }
            end
            if aura_match then
                state.auras[aura_name].matchCount = state.auras[aura_name].matchCount + 1
            end
            state.auras[aura_name].units[unit] = aura_match
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
        
        -- Initialize empty auras state
        local state = {
            auras = {
            }
        }
        
        -- Clear frame cache to ensure all auras 
        -- are cleared as expected
        aura_env.runtime.helpers.ClearFrameCache()
        
        -- Iterate over raid or party and restore state and auras glow
        for member in WA_IterateGroupMembers() do
            local normalized_unit = aura_env.helpers.NormalizeUnit(member)
            if normalized_unit then
                aura_env.runtime.helpers.UnitFadeAllAuras(normalized_unit)

                if aura_env.runtime.helpers.UnitMatchAuraActivationRules(normalized_unit) then
                    local aura_result = aura_env.runtime.helpers.UnitGlowAllAuras(normalized_unit)
                    UpdateStateUnitAuraResult(state, unit, aura_result)
                end
            end
        end
        
        state.show = true
        state.changed = true
        
        allstates['player'] = state
        
        return true
    end
    if event == 'PLAYER_REGEN_DISABLED' then
        if aura_env.helpers.AuraIsInDebug() then
            print('EVENT: PLAYER_REGEN_DISABLED')
        end
        
        local state = allstates['player']
        if state then
            local name = nil
            if aura_env.helpers.AuraIsInDebug() then
                name = UnitName(unit)
            end
            
            if aura_env.helpers.AuraIsInDebug() then
                print('Trigger: Combat started, state found') 
            end
            
            for unit, match in pairs(state.units) do
                if match then
                    local frame = aura_env.runtime.helpers.GetFrame(unit)
                    if frame then
                        if aura_env.helpers.AuraIsInDebug() then
                            print('Trigger: '..name..' fading')
                        end
                        aura_env.helpers.fade(frame, frame:GetName())
                    end
                end
            end
            
            allstates['player'] = nil
        else
            if aura_env.helpers.AuraIsInDebug() then
                print('Trigger: Combat started, state not found') 
            end
        end
        
        aura_env.runtime.helpers.EnterCombat()
        
        return false
    end
    if event == 'PLAYER_REGEN_ENABLED' then
        if aura_env.helpers.AuraIsInDebug() then
            print('EVENT: PLAYER_REGEN_ENABLED')
        end
        
        if aura_env.helpers.AuraIsInDebug() then
            print('Trigger: Combat ended') 
        end
        
        local state = {
            matchCount = 0,
            units = {
            }
        }
        
        for unit in WA_IterateGroupMembers() do
            local name = nil
            if aura_env.helpers.AuraIsInDebug() then
                name = UnitName(unit)
            end
            
            if aura_env.runtime.helpers.UnitMatchAuraActivationRules(unit) then
                local normalized_unit = aura_env.helpers.NormalizeUnit(unit)
                if normalized_unit then
                    if aura_env.runtime.helpers.UnitHasAura(normalized_unit) then
                        if aura_env.helpers.AuraIsInDebug() then
                            print('Trigger: '..name..' has aura, updating state')
                        end
                        state.units[normalized_unit] = false
                    else
                        if aura_env.helpers.AuraIsInDebug() then
                            print('Trigger: '..name..' has no aura, updating state')
                        end
                        state.matchCount = state.matchCount + 1
                        state.units[normalized_unit] = true
                        
                        local frame = aura_env.runtime.helpers.GetFrame(unit)
                        if frame then
                            if aura_env.helpers.AuraIsInDebug() then
                                print('Trigger: '..name..' glowing')
                            end
                            aura_env.helpers.glow(frame, frame:GetName())
                        end
                    end
                end 
            end
        end
        
        allstates['player'] = state
        
        aura_env.runtime.helpers.LeaveCombat()
        
        return true
    end
    if event == 'UNIT_AURA' and unit then
        if aura_env.helpers.AuraIsInDebug() then
            print('EVENT: UNIT_AURA')
        end
        
        if aura_env.runtime.helpers.IsInCombat() then
            if aura_env.helpers.AuraIsInDebug() then
                print('Trigger: In combat, ignoring') 
            end
            return false
        end
        
        if not aura_env.runtime.helpers.UnitMatchAuraActivationRules(unit) then
            return false
        end
        
        unit = aura_env.helpers.NormalizeUnit(unit)
        if not unit then
            return false
        end
        
        local name = UnitName(unit)
        local state = allstates['player']
        
        if aura_env.runtime.helpers.UnitHasAura(unit) then
            if state then
                if not state.units[unit] then
                    if aura_env.helpers.AuraIsInDebug() then
                        print('Trigger: '..name..' has aura, state found, no changes, skipping') 
                    end
                    
                    return false
                end
                
                if aura_env.helpers.AuraIsInDebug() then
                    print('Trigger: '..name..' has aura, state found, marking') 
                end
                
                state.changed = true
                state.matchCount = state.matchCount - 1
                state.units[unit] = false
            else
                if aura_env.helpers.AuraIsInDebug() then
                    print('Trigger: '..name..' has aura, state not found, marking')
                end
                
                allstates['player'] = {
                    show = true,
                    changed = true,
                    matchCount = 0,        
                    units = {
                        [unit] = false
                    }
                }
            end
            local frame = aura_env.runtime.helpers.GetFrame(unit)
            if frame then
                if aura_env.helpers.AuraIsInDebug() then
                    print('Trigger: '..name..' fading')
                end
                aura_env.helpers.fade(frame, frame:GetName())
            end
            return true
        end
        
        if state then
            if state.units[unit] then
                if aura_env.helpers.AuraIsInDebug() then
                    print('Trigger: '..name..' has no aura, state found, no changes, skipping')
                end
                
                return false
            end
            
            if aura_env.helpers.AuraIsInDebug() then
                print('Trigger: '..name..' has no aura, state found, marking')
            end
            
            state.show = true
            state.changed = true
            state.matchCount = state.matchCount + 1
            state.units[unit] = true
        else
            if aura_env.helpers.AuraIsInDebug() then
                print('Trigger: '..name..' has no aura, state not found, marking')
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
        local frame = aura_env.runtime.helpers.GetFrame(unit)
        if frame then
            if aura_env.helpers.AuraIsInDebug() then
                print('Trigger: '..name..' glowing')
            end
            aura_env.helpers.glow(frame, frame:GetName())
        end
        return true
    end
    
    return false 
end