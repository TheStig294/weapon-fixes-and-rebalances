-- This mod adds convars to manipulate TTT weapon stats and enable/disable individual weapons using convars
if engine.ActiveGamemode() ~= "terrortown" then return end

-- Don't add convars for weapon bases as they are not weapons
-- and disabling them would just cause a lot of errors
local banList = {
    weapon_tttbase = true,
    weapon_tttbasegrenade = true,
    tfa_gun_base = true,
    tfa_melee_base = true,
    tfa_bash_base = true,
    tfa_bow_base = true,
    tfa_knife_base = true,
    tfa_nade_base = true,
    tfa_sword_advanced_base = true
}

local translatedNames = {
    damage = "Damage",
    firedelay = "Delay",
    spread = "Cone",
    recoil = "Recoil",
    ammosize = "ClipSize",
    startingammo = "DefaultClip"
}

local convars = {}

-- Creating convars for all TTT weapons
hook.Add("InitPostEntity", "TTTWeaponStatsChangerConvars", function()
    for _, wepCopy in ipairs(weapons.GetList()) do
        local class = WEPS.GetClass(wepCopy) or wepCopy.ClassName
        if not class or banList[class] then continue end
        local SWEP = weapons.GetStored(class)
        if not SWEP or not SWEP.Primary then continue end

        local stats = {
            damage = SWEP.Primary.Damage,
            firedelay = SWEP.Primary.Delay,
            spread = SWEP.Primary.Cone,
            recoil = SWEP.Primary.Recoil,
            ammosize = SWEP.Primary.ClipSize,
            startingammo = SWEP.Primary.DefaultClip
        }

        -- "Enabled" convars are set to 1 (on) by default
        local convarName = class .. "_enabled"

        convars[convarName] = CreateConVar(convarName, 1, {FCVAR_NOTIFY, FCVAR_REPLICATED})

        for statName, statValue in pairs(stats) do
            convarName = class .. "_" .. statName

            -- Weapon stat convars are by default set to the weapon's default value
            convars[convarName] = CreateConVar(convarName, statValue, {FCVAR_NOTIFY, FCVAR_REPLICATED})
        end
    end
end)

-- Reading and applying the convars now adjusted by the server
hook.Add("TTTPrepareRound", "TTTWeaponStatsChangerApply", function()
    for _, wepCopy in ipairs(weapons.GetList()) do
        local class = WEPS.GetClass(wepCopy) or wepCopy.ClassName
        if not class or banList[class] then continue end
        local SWEP = weapons.GetStored(class)
        if not SWEP or not SWEP.Primary then continue end

        -- Setting weapon stats to configured values, or rebalanced values if not configured and there
        -- is some stat set to be balanced
        local stats = {
            damage = SWEP.Primary.Damage,
            firedelay = SWEP.Primary.Delay,
            spread = SWEP.Primary.Cone,
            recoil = SWEP.Primary.Recoil,
            ammosize = SWEP.Primary.ClipSize,
            startingammo = SWEP.Primary.DefaultClip
        }

        for statName, statValue in pairs(stats) do
            local cvarName = class .. "_" .. statName
            local cvar = convars[cvarName] or GetConVar(cvarName)
            if not cvar then continue end
            -- Set the weapon to the convar's value
            SWEP.Primary[translatedNames[statName]] = cvar:GetFloat()
        end

        local cvarName = class .. "_enabled"
        local enableCvar = convars[cvarName] or GetConVar(cvarName)

        -- And remove the weapon if it is disabled
        if enableCvar and not enableCvar:GetBool() then
            SWEP.AutoSpawnable = false
            SWEP.CanBuy = nil
            SWEP.InLoadoutFor = nil

            if ROLE_STRINGS_RAW and WEPS.UpdateWeaponLists then
                for id, role in ipairs(ROLE_STRINGS_RAW) do
                    WEPS.UpdateWeaponLists(id, class, false, true)
                end
            end
        end
    end

    hook.Remove("TTTPrepareRound", "TTTWeaponStatsChangerApply")
end)