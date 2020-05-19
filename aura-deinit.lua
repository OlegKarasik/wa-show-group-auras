for aura_name in aura_env.runtime.config do
    if aura_env.helpers.AuraIsInDebug() then
        print('Hidding tooltip frame for '..aura_name)
    end

    aura_env.runtime.helpers.TooltipHide(aura_name)
end