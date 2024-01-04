-- These are the weapon re-balances and fixes that are configurable using convars
-- These are for basic weapons that use the SWEP.Primary table for their stats
-- For fixes and re-balances to weapons that don't use SWEP.Primary (e.g. most buyable weapons, TFA guns)
-- see: "stig_ttt_weapon_fixes_rebalances.lua"
if engine.ActiveGamemode() ~= "terrortown" then return end

local weaponModifications = {
    weapon_pp_remington = {
        damage = 35
    },
    st_bananapistol = {
        ammo = 20,
        damage = 30,
        func = function(SWEP)
            -- Fix not having a worldmodel and not using TTT ammo
            SWEP.WorldModel = "models/props/cs_italy/bananna.mdl"
            SWEP.Primary.Ammo = "Pistol"
            SWEP.AmmoEnt = "item_ammo_pistol_ttt"
            SWEP.PrintName = "Banana Gun"
        end
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
        recoil = 3.5,
        func = function(SWEP)
            -- Remove the exponential component of the ares shrike's recoil -- Recoil now increases linearly, which is actually manageable
            function SWEP:PrimaryAttack(worldsnd)
                local recoil = self.Primary.Recoil
                self.ModulationTime = CurTime() + 2
                self.ModulationRecoil = math.min(20, self.ModulationRecoil * 1.2)
                self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
                self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
                if not self:CanPrimaryAttack() then return end

                if not worldsnd then
                    self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
                elseif SERVER then
                    sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
                end

                self:ShootBullet(self.Primary.Damage, recoil, self.Primary.NumShots, self:GetPrimaryCone())
                self:TakePrimaryAmmo(1)
                local owner = self:GetOwner()
                if not IsValid(owner) or owner:IsNPC() or not owner.ViewPunch then return end
                owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * recoil, math.Rand(-0.1, 0.1) * recoil, 0))
            end
        end
    },
    swep_rifle_viper = {
        damage = 65,
        func = function(SWEP)
            -- Fix not using TTT ammo and having a weird viewmodel
            SWEP.Base = "weapon_tttbase"
            SWEP.Primary.Ammo = "357"
            SWEP.AmmoEnt = "item_ammo_357_ttt"
            SWEP.AutoSpawnable = true
            SWEP.Slot = 2
            SWEP.Kind = WEAPON_HEAVY
            SWEP.PrintName = "Viper Rifle"
            SWEP.ViewModelFlip = false
            SWEP.DrawCrosshair = false
            SWEP.Icon = "vgui/ttt/ttt_viper_rifle"
        end
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
        if not wepCopy.Kind then continue end
        local class = WEPS.GetClass(wepCopy)
        local SWEP = weapons.GetStored(class)

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

        -- Run a weapon modification function if it has one
        if weaponModifications[class] and weaponModifications[class].func then
            weaponModifications[class].func(SWEP)
        end
    end
end)

-- Reading and applying the convars now adjusted by the server
hook.Add("TTTPrepareRound", "StigGenericWeaponChangesApply", function()
    for _, wepCopy in ipairs(weapons.GetList()) do
        if not wepCopy.Kind then continue end
        local class = WEPS.GetClass(wepCopy)
        local SWEP = weapons.GetStored(class)

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

            if cvar:GetString() == "" and weaponModifications[class] and weaponModifications[class][statName] then
                -- If the convar is blank, and there is a balancing value, we've got some rebalancing to do...
                SWEP.Primary[translatedNames[statName]] = weaponModifications[class][statName]
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