-- These are the weapon re-balances and fixes that are configurable using convars
-- These are for basic weapons that use the SWEP.Primary table for their stats
-- For fixes and re-balances to weapons that don't use SWEP.Primary (e.g. most buyable weapons, TFA guns)
-- see: "stig_ttt_weapon_fixes_rebalances.lua"
if engine.ActiveGamemode() ~= "terrortown" then return end

local defaultStatRebalances = {
    weapon_pp_remington = {
        damage = 35
    },
    st_bananapistol = {
        ammo = 20,
        damage = 30
    },
    weapon_ap_vector = {
        recoil = 0.7
    },
    weapon_rp_pocket = {
        damage = 75
    },
    weapon_ap_pp19 = {
        firedelay = 0.05,
        damage = 7,
        recoil = 1.2
    },
    weapon_hp_ares_shrike = {
        damage = 12,
        recoil = 3.5
    },
    swep_rifle_viper = {
        damage = 65
    },
    weapon_ttt_p228 = {
        damage = 25
    },
    weapon_t38 = {
        damage = 65,
    },
    weapon_ttt_g3sg1 = {
        damage = 30
    },
    weapon_gewehr43 = {
        damage = 40,
        firedelay = 0.39
    },
    weapon_luger = {
        damage = 20
    },
    weapon_welrod = {
        damage = 30
    },
    weapon_dp = {
        damage = 20
    }
}

local translatedNames = {
    damage = "Damage",
    firedelay = "Delay",
    spread = "Cone",
    recoil = "Recoil",
    ammo = "ClipSize"
}

local convars = {}

-- Creating convars for all TTT weapons
hook.Add("InitPostEntity", "StigGenericWeaponChangesConvars", function()
    for _, wepCopy in ipairs(weapons.GetList()) do
        local class = WEPS.GetClass(wepCopy) or wepCopy.ClassName
        if not class then continue end
        local SWEP = weapons.GetStored(class)
        if not SWEP then continue end

        local stats = {
            damage = SWEP.Primary.Damage,
            firedelay = SWEP.Primary.Delay,
            spread = SWEP.Primary.Cone,
            recoil = SWEP.Primary.Recoil,
            ammo = SWEP.Primary.ClipSize
        }

        local convarName = class .. "_enabled"

        convars[convarName] = CreateConVar(convarName, 1, {FCVAR_NOTIFY, FCVAR_REPLICATED})

        for statName, statValue in pairs(stats) do
            convarName = class .. "_" .. statName

            convars[convarName] = CreateConVar(convarName, "", {FCVAR_NOTIFY, FCVAR_REPLICATED})
        end
    end
end)

-- Reading and applying the convars now adjusted by the server
hook.Add("TTTPrepareRound", "StigGenericWeaponChangesApply", function()
    for _, wepCopy in ipairs(weapons.GetList()) do
        local class = WEPS.GetClass(wepCopy) or wepCopy.ClassName
        if not class then continue end
        local SWEP = weapons.GetStored(class)
        if not SWEP then continue end

        -- Setting weapon stats to configured values, or rebalanced values if not configured and there
        -- is some stat set to be balanced
        local stats = {
            damage = SWEP.Primary.Damage,
            firedelay = SWEP.Primary.Delay,
            spread = SWEP.Primary.Cone,
            recoil = SWEP.Primary.Recoil,
            ammo = SWEP.Primary.ClipSize
        }

        for statName, statValue in pairs(stats) do
            local cvarName = class .. "_" .. statName
            local cvar = convars[cvarName] or GetConVar(cvarName)
            if not cvar then continue end
            local statChanged = false

            if cvar:GetString() == "" and defaultStatRebalances[class] and defaultStatRebalances[class][statName] then
                -- If the convar is blank, and there is a balancing value, we've got some rebalancing to do...
                SWEP.Primary[translatedNames[statName]] = defaultStatRebalances[class][statName]
                statChanged = true
            elseif cvar:GetString() ~= "" then
                -- Else, if the convar is set, then just use the configured value
                SWEP.Primary[translatedNames[statName]] = cvar:GetFloat()
                statChanged = true
            end

            if statName == "ammo" and statChanged then
                -- Make default clip match new clipsize
                SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize
            end
        end

        local cvarName = class .. "_enabled"
        local enableCvar = convars[cvarName] or GetConVar(cvarName)

        -- And remove the weapon if it is disabled
        if enableCvar and not enableCvar:GetBool() then
            SWEP.AutoSpawnable = false
            SWEP.CanBuy = nil
        end
    end

    hook.Remove("TTTPrepareRound", "StigGenericWeaponChangesApply")
end)