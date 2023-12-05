-- These are the weapon re-balances and fixes that are configurable using convars
-- These are for basic weapons that use the SWEP.Primary table for their stats
-- For fixes and re-balances to weapons that don't use SWEP.Primary (e.g. most buyable weapons, TFA guns)
-- see: "stig_ttt_weapon_fixes_rebalances.lua"
if engine.ActiveGamemode() ~= "terrortown" then return end

local supportedWeapons = {
    -- Lykrast's weapons
    weapon_ap_golddragon = true,
    weapon_ap_hbadger = true,
    weapon_ap_mrca1 = true,
    weapon_ap_pp19 = true,
    weapon_ap_tec9 = true,
    weapon_ap_vector = true,
    weapon_hp_ares_shrike = true,
    weapon_hp_glauncher = true,
    weapon_pp_rbull = true,
    weapon_pp_remington = true,
    weapon_rp_pocket = true,
    weapon_rp_railgun = true,
    weapon_sp_dbarrel = true,
    weapon_sp_striker = true,
    weapon_sp_winchester = true,
    -- Default weapons
    weapon_ttt_flaregun = true,
    weapon_ttt_sipistol = true,
    weapon_ttt_stungun = true,
    weapon_ttt_glock = true,
    weapon_ttt_m16 = true,
    weapon_zm_mac10 = true,
    weapon_zm_pistol = true,
    weapon_zm_revolver = true,
    weapon_zm_rifle = true,
    weapon_zm_shotgun = true,
    weapon_zm_sledge = true,
    -- TTT weapon collection
    weapon_ttt_ak47 = true,
    weapon_ttt_aug = true,
    weapon_ttt_awp = true,
    weapon_ttt_famas = true,
    weapon_ttt_g3sg1 = true,
    weapon_ttt_galil = true,
    weapon_ttt_m4a1_s = true,
    weapon_ttt_mp5 = true,
    weapon_ttt_p90 = true,
    weapon_ttt_p228 = true,
    weapon_ttt_pistol = true,
    weapon_ttt_pump = true,
    weapon_ttt_revolver = true,
    weapon_ttt_sg550 = true,
    weapon_ttt_sg552 = true,
    weapon_ttt_smg = true,
    weapon_ttt_tmp_s = true,
    -- World War II weapons
    weapon_dp = true,
    weapon_enfield_4 = true,
    weapon_fg42 = true,
    weapon_gewehr43 = true,
    weapon_lee = true,
    weapon_luger = true,
    weapon_m3 = true,
    weapon_ppsh41 = true,
    weapon_stenmk3 = true,
    weapon_svt40 = true,
    weapon_t14nambu = true,
    weapon_t38 = true,
    weapon_tt = true,
    weapon_welrod = true,
    -- Misc weapons
    st_bananapistol = true,
    weapon_ttt_csgo_r8revolver = true,
    swep_rifle_viper = true
}

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
    weapon_ttt_csgo_r8revolver = {
        func = function(SWEP)
            -- Fix shoot sound having no volume drop-off (shoot sound is global)
            -- Fix pistol not taking pistol slot
            sound.Add({
                name = "Weapon_CSGO_Revolver.SingleFixed",
                channel = CHAN_WEAPON,
                level = 75,
                sound = "csgo/weapons/revolver/revolver-1_01.wav"
            })

            SWEP.Primary.Sound = Sound("Weapon_CSGO_Revolver.SingleFixed")

            if SERVER then
                resource.AddWorkshop("2903604575")
            end

            SWEP.Slot = 1
            SWEP.Kind = WEAPON_PISTOL
        end
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
    weapon_lee = {
        func = function(SWEP)
            -- Fix not using TTT ammo
            SWEP.AmmoEnt = "item_ammo_revolver_ttt"
            SWEP.Primary.Ammo = "AlyxGun"
        end
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

hook.Add("PreRegisterSWEP", "StigGenericWeaponChanges", function(SWEP, class)
    if supportedWeapons[class] then
        -- Setting weapon stats to configured values, or rebalanced values if not configured and there
        -- is some stat set to be balanced
        local stats = {
            damage = SWEP.Primary.Damage,
            firedelay = SWEP.Primary.Delay,
            spread = SWEP.Primary.Cone,
            recoil = SWEP.Primary.Recoil,
            ammo = SWEP.Primary.ClipSize
        }

        local enableCvar = CreateConVar(class .. "_enabled", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

        for statName, statValue in pairs(stats) do
            local cvar = CreateConVar(class .. "_" .. statName, "", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

            if cvar:GetString() == "" and weaponModifications[class] and weaponModifications[class][statName] then
                -- If the convar is blank, and there is a balancing value, we've got some rebalancing to do...
                SWEP.Primary[translatedNames[statName]] = weaponModifications[class][statName]
            elseif cvar:GetString() ~= "" then
                -- Else, if the convar is set, then just use the configured value
                SWEP.Primary[translatedNames[statName]] = cvar:GetFloat()
            end
        end

        -- Run a weapon modification function if it has one
        if weaponModifications[class] and weaponModifications[class].func then
            weaponModifications[class].func(SWEP)
        end

        -- Make default clip match new clipsize
        SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize

        -- And remove the weapon if it is disabled
        if not enableCvar:GetBool() then
            SWEP.AutoSpawnable = false
            SWEP.CanBuy = nil
        end
    end
end)