-- Emulate functions
function LibStub(name)
    if name == 'LibCustomGlow-1.0' then
        return { }
    end
    return nil
end

function CreateColor()
    return { }
end

function GetLocale()
    return 'english'
end

function UnitName(unit)
    return unit
end

aura_env = {
    id = 'ut-mock'
}