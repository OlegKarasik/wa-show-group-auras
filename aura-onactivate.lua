for aura_name, aura_config in pairs(aura_env.runtime.config) do
    local frame = aura_frames[aura_name]
    local region = WeakAuras.GetRegion(aura_env.id, aura_name)
    
    print(frame:GetName())
    
    frame:ClearAllPoints()
    frame:SetAllPoints(region)
    frame:SetFrameStrata("DIALOG")
    frame:Show()
end

