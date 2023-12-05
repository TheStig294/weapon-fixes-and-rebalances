-- Miscellaneous fixes and re-balances for different TTT weapons 
if engine.ActiveGamemode() ~= "terrortown" then return end

-- 
-- 
-- Weapons Changes
-- 
-- 
hook.Add("PreRegisterSWEP", "StigSpecialWeaponChanges", function(SWEP, class)
    -- Quick fix for TTT weapons given slot 3 when it should be 2
    -- (+1 to slot number to determine its slot in-game, some weapons are 1-off the correct slot)
    if SWEP.Kind and SWEP.Kind ~= WEAPON_NADE and SWEP.Slot and SWEP.Slot == 3 then
        SWEP.Slot = 2
    end

    if class == "ttt_no_scope_awp" then
        -- Fix no-scope AWP taking different slot visually than it actually takes
        SWEP.Slot = 6
    elseif class == "weapon_ttt_mc_immortpotion" then
        -- Fix immortality potion's name being too long
        SWEP.PrintName = "Immortality Pot."
    elseif class == "giantsupermariomushroom" then
        -- Fix mario mushroom's name being too long
        SWEP.PrintName = "Mario Mushroom"
    elseif class == "tfa_dax_big_glock" then
        -- Fix big glock not using TTT ammo
        SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize
        SWEP.Primary.Ammo = "357"
        SWEP.AmmoEnt = "item_ammo_357_ttt"
    elseif class == "weapon_ttt_artillery" then
        -- Make artillery cannon always red and not re-buyable
        local rebuyableCvar = CreateConVar("ttt_rebalance_artillery_rebuyable", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether the artillery cannon is re-buyable or not")
        SWEP.LimitedStock = rebuyableCvar:GetBool()

        local alwaysRedCvar = CreateConVar("ttt_rebalance_artillery_always_red", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED},"Whether the artillery cannon should always be red")

        if alwaysRedCvar:GetBool() then
            SWEP.CannonColor = HSVToColor(0, 0.7, 0.7)

            function SWEP:WasBought(buyer)
                return self.BaseClass.WasBought(self, buyer)
            end
        end
    elseif class == "weapon_ttt_fortnite_building" then
        -- Fix lua error with fortnite building tool
        function SWEP:Holster()
            if CLIENT and IsValid(self.c_Model) then
                self.c_Model:SetNoDraw(true)
            end

            return true
        end
    elseif class == "weapon_ttt_prop_hunt_gun" then
        -- Fixes the prop hunt gun not fully disguising you
        SWEP.PrintName = "Prop Disguiser"
        hook.Remove("EntityTakeDamage", "CauseGodModeIsOP")
        SWEP.OldPropDisguise = SWEP.PropDisguise
        SWEP.OldPropUnDisguise = SWEP.PropUnDisguise

        -- Fixes detective being outed by their overhead icon while prop disguised
        hook.Add("TTTTargetIDPlayerBlockIcon", "StigWeaponFixesBlockPropHuntGunIcon", function(ply, client)
            if ply:GetNWBool("PHR_Disguised") then return true end
        end)

        function SWEP:PropDisguise()
            self.OldPropDisguise(self)
            local owner = self:GetOwner()
            if not IsValid(owner) then return end
            -- Some maps have the uber-shiny default cubemap, that has the side-effect of making players
            -- with the "heatwave" material set super visible, a common way of making players invisible
            -- for most uses, like the dead ringer, this doesn't really matter, but with the prop hunt
            -- gun, you typically stay still, making the problem more pronounced
            -- So we just set the player to be outright unrendered until they are undisguised
            owner:SetNoDraw(true)
        end

        function SWEP:PropUnDisguise()
            local owner = self:GetOwner()
            if not IsValid(owner) then return end
            owner:SetNoDraw(false)
            self.OldPropUnDisguise(self)
        end
    elseif class == "weapon_ap_tec9" then
        -- Fixes error spam with the tec9's ricochet function
        function SWEP:RicochetCallback(bouncenum, attacker, tr, dmginfo)
            if not IsFirstTimePredicted() then
                return {
                    damage = false,
                    effects = false
                }
            end

            if tr.HitSky then return end
            self.MaxRicochet = 1
            if bouncenum > self.MaxRicochet then return end
            -- Bounce vector
            local trace = {}
            trace.start = tr.HitPos
            trace.endpos = trace.start + tr.HitNormal * 16384
            trace = util.TraceLine(trace)
            local DotProduct = tr.HitNormal:Dot(tr.Normal * -1)
            local ricochetbullet = {}
            ricochetbullet.Num = 1
            ricochetbullet.Src = tr.HitPos + tr.HitNormal * 5
            ricochetbullet.Dir = 2 * tr.HitNormal * DotProduct + tr.Normal + VectorRand() * 0.05
            ricochetbullet.Spread = Vector(0, 0, 0)
            ricochetbullet.Tracer = 1
            ricochetbullet.TracerName = "Impact"
            ricochetbullet.Force = dmginfo:GetDamageForce() * 0.8
            ricochetbullet.Damage = dmginfo:GetDamage() * 0.8

            ricochetbullet.Callback = function(a, b, c)
                if IsValid(self) and isfunction(self.RicochetCallback) then return self:RicochetCallback(bouncenum + 1, a, b, c) end
            end

            timer.Simple(0, function()
                attacker:FireBullets(ricochetbullet)
            end)

            return {
                damage = true,
                effects = true
            }
        end
    elseif class == "weapon_ttt_minic" then
        -- Fixes the "Mimics spawned" message only displaying to vanilla traitors
        local mymodel = ""

        function SWEP:PrimaryAttack()
            mymodel = 60
            local maxmodel = 60

            if mymodel > 60 then
                maxmodel = 60
            else
                maxmodel = mymodel
            end

            if SERVER then
                for i = 1, math.random(maxmodel) do
                    local ent = ents.Create("ttt_minictest") -- This creates our npc entity
                    ent:Spawn()
                end
            end

            local mimicCount = table.Count(ents.FindByClass("ttt_minictest"))

            if mimicCount > 0 then
                for k, v in pairs(player.GetAll()) do
                    if v:GetRole() == ROLE_TRAITOR or (v.IsTraitorTeam and v:IsTraitorTeam()) then
                        v:PrintMessage(HUD_PRINTTALK, mimicCount .. " mimics spawned")
                    end
                end
            end

            if SERVER then
                self:Remove()
            end
        end
    elseif class == "weapon_enfield_4" then
        -- Fixes the lee enfield not being able to be shot sometimes, and erroring
        SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize
        local FireSound = Sound("weapons/enfield_fire.wav")

        function SWEP:PrimaryAttack()
            local owner = self:GetOwner()
            if not IsValid(owner) then return end
            self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
            self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
            if not self:CanPrimaryAttack() then return end
            self:EmitSound(FireSound)
            self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
            self:TakePrimaryAmmo(1)
            if owner:IsNPC() then return end
            owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self.Primary.Recoil, 0))
        end
    elseif class == "weapon_rp_railgun" then
        -- Turns the railgun into the "Free kill gun" that allows to be killed or to kill without karma penalty
        -- (Not enabled by default)
        local freeKillGunCvar = CreateConVar("ttt_rebalance_railgun_no_karma_penalty", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether the railgun doesn't take karma for kills, and killing someone holding a railgun doesn't take karma either")
        if not freeKillGunCvar:GetBool() then return end
        SWEP.PrintName = "Free Kill Gun"

        hook.Add("EntityTakeDamage", "FreeKillHolderCheck", function(target, dmg)
            if target:IsPlayer() then
                if target:HasWeapon("weapon_rp_railgun") then
                    target.FreeKill = true
                else
                    target.FreeKill = false
                end
            end
        end)

        hook.Add("TTTKarmaGivePenalty", "FreeKillKarma", function(ply, penalty, victim)
            if ply:GetActiveWeapon() and ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass() == "weapon_rp_railgun" then return true end
            if victim.FreeKill then return true end
        end)

        function SWEP:ShootBullet(dmg, recoil, numbul, cone)
            local owner = self:GetOwner()
            self:SendWeaponAnim(self.PrimaryAnim)
            owner:MuzzleFlash()
            owner:SetAnimation(PLAYER_ATTACK1)
            if not IsFirstTimePredicted() then return end
            local sights = self:GetIronsights()
            numbul = numbul or 1
            cone = cone or 0.01
            local bullet = {}
            bullet.Num = numbul
            bullet.Src = owner:GetShootPos()
            bullet.Dir = owner:GetAimVector()
            bullet.Spread = Vector(cone, cone, 0)
            bullet.Tracer = 1
            bullet.TracerName = "ToolTracer"
            bullet.Force = 10
            bullet.Damage = dmg
            owner:FireBullets(bullet)
            -- Owner can die after firebullets
            if (not IsValid(owner)) or (not owner:Alive()) or owner:IsNPC() then return end

            if (game.SinglePlayer() and SERVER) or ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted()) then
                -- reduce recoil if ironsighting
                recoil = sights and (recoil * 0.6) or recoil

                if recoil and isnumber(recoil) then
                    local eyeang = owner:EyeAngles()
                    eyeang.pitch = eyeang.pitch - recoil
                    owner:SetEyeAngles(eyeang)
                end
            end
        end

        function SWEP:BfgFire(worldsnd)
            self:SetNextSecondaryFire(CurTime() + 0.5)
            self:SetNextPrimaryFire(CurTime() + 0.5)

            if not worldsnd then
                self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
            elseif SERVER then
                sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
            end

            local recoil, damage

            if self.mode == "single" then
                self:TakePrimaryAmmo(1)
                recoil = 7
                damage = 20
            end

            if self.mode == "2" then
                self:TakePrimaryAmmo(2)
                recoil = 16
                damage = 40
            end

            if self.mode == "3" then
                self:TakePrimaryAmmo(3)
                recoil = 36
                damage = 80
            end

            if self.mode == "4" then
                self:TakePrimaryAmmo(4)
                recoil = 82
                damage = 160
            end

            self:ShootBullet(damage, recoil, self.Primary.NumShots, self:GetPrimaryCone())
            local owner = self:GetOwner()
            if not recoil or not IsValid(owner) or owner:IsNPC() or not owner.ViewPunch then return end
            owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * recoil, math.Rand(-0.1, 0.1) * recoil, 0))

            if self.ChargeSound then
                self.ChargeSound:Stop()
            end
        end
    elseif class == "weapon_ttt_cloak" then
        -- Fixes becoming permanently invisible if handcuffed while using the cloak
        -- Makes the weapon given to the Killer role as part of their weapon loadout (not enabled by default)
        -- Makes it so you cannot use the Amatrasu weapon at the same time as using the cloak
        local killerCvar = CreateConVar("ttt_rebalance_invisibility_cloak_killer", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Whether the invisibility cloak should be given to Killers as a loadout weapon")

        if killerCvar:GetBool() then
            SWEP.InLoadoutFor = {ROLE_KILLER}
        end

        local amatrasuCvar = CreateConVar("ttt_rebalance_invisibility_cloak_removes_amatrasu", "1", nil, "Whether using the invisibility cloak removes your amatrasu weapon if you have one")

        function SWEP:Cloak()
            local owner = self:GetOwner()
            owner:SetColor(Color(255, 255, 255, 0))
            owner:DrawShadow(false)
            owner:SetMaterial("models/effects/vol_light001")
            owner:SetRenderMode(RENDERMODE_TRANSALPHA)
            self:EmitSound("xeno/cloak.wav")
            self.conceal = true

            if SERVER and owner:HasWeapon("ttt_amaterasu") and amatrasuCvar:GetBool() then
                owner:StripWeapon("ttt_amaterasu")
                owner:ChatPrint("Uncloak to use the amaterasu")
                self.amaterasu = true
            end
        end

        function SWEP:UnCloak()
            local owner = self:GetOwner()
            owner:DrawShadow(true)
            owner:SetMaterial("")
            owner:SetRenderMode(RENDERMODE_NORMAL)
            self:EmitSound("xeno/decloak.wav")
            self:SetMaterial("")
            self.conceal = false

            if self.amaterasu then
                self:GetOwner():ChatPrint("Giving amaterasu in 2 seconds")

                timer.Simple(2, function()
                    if IsPlayer(self:GetOwner()) and self.conceal == false then
                        self:GetOwner():Give("ttt_amaterasu")
                        self.amaterasu = false
                    end
                end)
            end
        end

        function SWEP:ShouldDropOnDie()
            return false
        end

        hook.Add("TTTPrepareRound", "UnCloakAll", function()
            for k, v in pairs(player.GetAll()) do
                v:SetMaterial("")
            end
        end)

        hook.Add("PlayerDroppedWeapon", "DropCloakingDeviceUnCloak", function(owner, wep)
            if wep:GetClass() == "weapon_ttt_cloak" then
                owner:DrawShadow(true)
                owner:SetMaterial("")
                owner:SetRenderMode(RENDERMODE_NORMAL)
                wep:EmitSound("xeno/decloak.wav")
                wep:SetMaterial("")
                wep.conceal = false

                if wep.amaterasu then
                    wep.amaterasu = false
                    owner:ChatPrint("Giving amaterasu in 2 seconds")

                    timer.Simple(2, function()
                        if IsPlayer(owner) then
                            wep:GetOwner():Give("ttt_amaterasu")
                        end
                    end)
                end
            end
        end)
    elseif class == "ttt_cmdpmpt" and SERVER then
        -- Fixes many bugs with the "command prompt" weapon
        function SWEP:PrimaryAttack()
            local ply = self:GetOwner()

            if self.cmdpmptused ~= true then
                self.cmdpmptused = true
                local passivestate = math.random(6)
                local selectedmode = 0

                if passivestate == 1 then
                    selectedmode = 1
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing damage_pos_swap.exe .....")
                    self:Remove()
                elseif passivestate == 2 then
                    selectedmode = 2
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing increased_speed_v2.exe .....")
                elseif passivestate == 3 then
                    selectedmode = 3
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing equipmenthack_stealer.exe .....")
                    self:Remove()
                elseif passivestate == 4 then
                    selectedmode = 4
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing traitor_spam_version2.exe .....")
                    self:Remove()
                elseif passivestate == 5 then
                    selectedmode = 5
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing aimbot_assist.exe .....")
                    self:Remove()
                elseif passivestate == 6 then
                    selectedmode = 6
                    ply:PrintMessage(HUD_PRINTCENTER, "Executing forcefield.exe .....")
                    self:Remove()
                else
                    ply:ChatPrint("Failed to execute aimbot_v2_cracked.drklt , unrecognised file type. Please try again.")
                    ply:PrintMessage(HUD_PRINTCENTER, "Failed to execute aimbot_v2_cracked.drklt , unrecognised file type. Please try again.")
                    self.cmdpmptused = nil
                    ply:EmitSound("weapons/cmdpmpt/viruserror.wav")

                    return
                end

                net.Start("commandpromptopen")
                net.Send(ply)
                hook.Add("PlayerDisconnected", "cmdpmptdisconnect", lifeforcedisconnect)
                hook.Add("PlayerDeath", "cmdpmptdeath", cmdpmptplayerdeath)
                hook.Add("TTTEndRound", "cmdpmptroundend", cmdpmptend)
                hook.Add("TTTPrepareRound", "cmdpmptroundprep", cmdpmptend)

                timer.Create("cmdpromptgiveability" .. ply:AccountID(), 5, 1, function()
                    if selectedmode == 1 then
                        hook.Add("EntityTakeDamage", "cmdpmpttakedamage", cmdpmpttakedamage)
                        ply:ChatPrint("COMMAND PROMPT: When taking damage from a player, you will swap positions with a random player. Has a 7 second cooldown.")
                        ply.cmdpmptmode = 1
                        hook.Call("TTTCMDPROMT", nil, ply, "position swap on damage")
                    elseif selectedmode == 2 then
                        hook.Add("TTTPlayerSpeedModifier", "cmdpmptspeed", cmdpmptspeed)
                        ply:ChatPrint("COMMAND PROMPT: You will now have increased speed. Right-Click a player to toggle their speed. Can be used on a maximum of 2 other players.")
                        self.cmdpmptspeedleft = 2
                        ply.cmdpmptmode = 2
                        hook.Call("TTTCMDPROMT", nil, ply, "speed buff")
                    elseif selectedmode == 3 then
                        hook.Add("TTTOrderedEquipment", "cmdpmptequipment", cmdpmpttequip)
                        ply:ChatPrint("COMMAND PROMPT: Program active and running in background. When a T next buys a weapon it'll strip them of it and you will recieve the weapon instead.")
                        ply.cmdpmptmode = 3

                        for k, v in pairs(player.GetAll()) do
                            if v:Alive() and IsValid(v) and v:IsPlayer() and not v:GetNWBool("SpecDM_Enabled", false) and v:GetRole() == ROLE_TRAITOR then
                                net.Start("commandprompstealer")
                                net.Send(v)
                            end
                        end

                        hook.Call("TTTCMDPROMT", nil, ply, "equipment stealer")
                    elseif selectedmode == 4 then
                        hook.Add("Think", "cmdpmptnearbyhack", nearbyhack)
                        ply:ChatPrint("COMMAND PROMPT: When traitors get near you their screens will become blocked with adware. The closer they get the more there are.")
                        ply.cmdpmptmode = 4

                        for k, v in pairs(player.GetAll()) do
                            if v:Alive() and IsValid(v) and v:IsPlayer() and not v:GetNWBool("SpecDM_Enabled", false) and v:GetRole() == ROLE_TRAITOR then
                                net.Start("commandprompnearbystart")
                                net.Send(v)
                            end
                        end

                        hook.Call("TTTCMDPROMT", nil, ply, "traitor spammer")
                    elseif selectedmode == 5 then
                        hook.Add("KeyPress", "cmdpmptkeypress", aimhack)
                        hook.Add("EntityTakeDamage", "cmdpmpttakedamage", cmdpmpttakedamage)
                        ply:ChatPrint("COMMAND PROMPT: You will now have assisted aim with any weapon. You will gain an extra 50 health. However, you will only do 70% of the original damage.")
                        ply:SetMaxHealth(150)
                        ply:SetHealth(ply:Health() + 50)
                        ply.cmdpmptmode = 5
                        hook.Call("TTTCMDPROMT", nil, ply, "aim assist")
                    elseif selectedmode == 6 then
                        hook.Add("EntityTakeDamage", "cmdpmpttakedamage", cmdpmpttakedamage)
                        ply:ChatPrint("COMMAND PROMPT: You will now have a forcefield, you will take 60% less damage if the attacker is too far away.")
                        ply.cmdpmptmode = 6
                        hook.Call("TTTCMDPROMT", nil, ply, "forcefield")
                    else
                        ply:ChatPrint("COMMAND PROMPT: Failed to execute aimbot_v2_cracked.drklt , unrecognised file type. Please try again.")

                        return
                    end
                end)
            end
        end
    elseif class == "weapon_ttt_bonk_bat" then
        -- Adds a ceiling and floor to the jail to prevent players from escaping
        local ceilingCvar = CreateConVar("ttt_rebalance_bonk_bat_floor_ceiling", "1", nil, "Whether the jail created by the bonk bat should have a floor and ceiling")

        function SWEP:PrimaryAttack()
            local ply = self:GetOwner()
            self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
            if not IsValid(ply) or self:Clip1() <= 0 then return end
            ply:SetAnimation(PLAYER_ATTACK1)
            self:SendWeaponAnim(ACT_VM_MISSCENTER)
            self:EmitSound("Bat.Swing")
            local av, spos = ply:GetAimVector(), ply:GetShootPos()
            local epos = spos + av * self.Range
            local kmins = Vector(1, 1, 1) * 7
            local kmaxs = Vector(1, 1, 1) * 7
            ply:LagCompensation(true)

            local tr = util.TraceHull({
                start = spos,
                endpos = epos,
                filter = ply,
                mask = MASK_SHOT_HULL,
                mins = kmins,
                maxs = kmaxs
            })

            -- Hull might hit environment stuff that line does not hit
            if not IsValid(tr.Entity) then
                tr = util.TraceLine({
                    start = spos,
                    endpos = epos,
                    filter = ply,
                    mask = MASK_SHOT_HULL
                })
            end

            ply:LagCompensation(false)
            local ent = tr.Entity
            if not tr.Hit or not (tr.HitWorld or IsValid(ent)) then return end
            if not ent:IsPlayer() then return end

            if ent:GetClass() == "prop_ragdoll" then
                ply:FireBullets{
                    Src = spos,
                    Dir = av,
                    Tracer = 0,
                    Damage = 0
                }
            end

            if CLIENT then return end
            net.Start("Bonk Bat Primary Hit")
            net.WriteTable(tr)
            net.WriteEntity(self)
            net.Broadcast()
            local dmg = DamageInfo()
            dmg:SetDamage(ent:IsPlayer() and self.Primary.Damage or self.Primary.Damage * 0.5)
            dmg:SetAttacker(ply)
            dmg:SetInflictor(self)
            dmg:SetDamageForce(av * 2000)
            dmg:SetDamagePosition(ply:GetPos())
            dmg:SetDamageType(DMG_CLUB)
            ent:DispatchTraceAttack(dmg, tr)
            self:TakePrimaryAmmo(1)

            if self:Clip1() <= 0 then
                timer.Simple(0.49, function()
                    if IsValid(self) then
                        self:Remove()
                        RunConsoleCommand("lastinv")
                    end
                end)
            end

            -- grenade to stop detective getting stuck in jail
            local gren = ents.Create("jail_discombob")
            gren:SetPos(ent:GetPos())
            gren:SetOwner(ent)
            gren:SetThrower(ent)
            gren:Spawn()
            gren:SetDetonateExact(CurTime())
            local name = ent:Name()
            local jail = {}

            -- making the jail
            timer.Create("jaildiscombob", 0.7, 1, function()
                -- far side
                jail[0] = JailWall(ent:GetPos() + Vector(0, -25, 50), Angle(0, 275, 0))
                -- close side
                jail[1] = JailWall(ent:GetPos() + Vector(0, 25, 50), Angle(0, 275, 0))
                -- left side
                jail[2] = JailWall(ent:GetPos() + Vector(-25, 0, 50), Angle(0, 180, 0))
                -- right side
                jail[3] = JailWall(ent:GetPos() + Vector(25, 0, 50), Angle(0, 180, 0))

                if ceilingCvar:GetBool() then
                    -- ceiling side
                    jail[4] = JailWall(ent:GetPos() + Vector(0, 0, 100), Angle(90, 0, 0))
                    -- floor side
                    jail[5] = JailWall(ent:GetPos() + Vector(0, 0, -5), Angle(90, 0, 0))
                end

                for _, v in pairs(player.GetAll()) do
                    v:ChatPrint(name .. " has been sent to horny jail!")
                end
            end)

            timer.Simple(15, function()
                -- remove the jail
                for _, v in pairs(jail) do
                    v:Remove()
                end
            end)
        end
    elseif class == "weapon_ttt_obc" then
        -- Fixes error spam with the orbital base cannon weapon
        local function BassCannonStart(tr, trace, wep, hitPlayer)
            local tracedata2 = {}
            tracedata2.start = trace.HitPos
            tracedata2.endpos = trace.HitPos + Vector(0, 0, -50000)
            tracedata2.filter = ents.GetAll()
            local trace2 = util.TraceLine(tracedata2)
            wep.glow = ents.Create("env_lightglow")
            wep.glow:SetKeyValue("rendercolor", "255 255 255")
            wep.glow:SetKeyValue("VerticalGlowSize", "50")
            wep.glow:SetKeyValue("HorizontalGlowSize", "150")
            wep.glow:SetKeyValue("MaxDist", "200")
            wep.glow:SetKeyValue("MinDist", "1")
            wep.glow:SetKeyValue("HDRColorScale", "100")
            local hitPlayerPos = nil

            if hitPlayer then
                hitPlayerPos = hitPlayer:GetPos()
                wep.glow:SetPos(hitPlayerPos + Vector(0, 0, 32))
            else
                wep.glow:SetPos(trace2.HitPos + Vector(0, 0, 32))
            end

            wep.glow:Spawn()
            wep.glow2 = ents.Create("env_lightglow")
            wep.glow2:SetKeyValue("rendercolor", "53 255 253")
            wep.glow2:SetKeyValue("VerticalGlowSize", "100")
            wep.glow2:SetKeyValue("HorizontalGlowSize", "100")
            wep.glow2:SetKeyValue("MaxDist", "300")
            wep.glow2:SetKeyValue("MinDist", "1")
            wep.glow2:SetKeyValue("HDRColorScale", "100")

            if hitPlayer then
                wep.glow2:SetPos(hitPlayerPos + Vector(0, 0, 32))
            else
                wep.glow2:SetPos(trace2.HitPos + Vector(0, 0, 32))
            end

            wep.glow2:Spawn()
            wep.glow3 = ents.Create("env_lightglow")
            wep.glow3:SetKeyValue("rendercolor", "255 255 255")
            wep.glow3:SetKeyValue("VerticalGlowSize", "10")
            wep.glow3:SetKeyValue("HorizontalGlowSize", "30")
            wep.glow3:SetKeyValue("MaxDist", "400")
            wep.glow3:SetKeyValue("MinDist", "1")
            wep.glow3:SetKeyValue("HDRColorScale", "100")

            if hitPlayer then
                wep.glow3:SetPos(hitPlayerPos + Vector(0, 0, 27000))
            else
                wep.glow3:SetPos(trace2.HitPos + Vector(0, 0, 27000))
            end

            wep.glow3:Spawn()
            wep.targ = ents.Create("info_target")
            wep.targ:SetKeyValue("targetname", tostring(wep.targ))

            if hitPlayer then
                wep.targ:SetPos(hitPlayerPos + Vector(0, 0, -50000))
            else
                wep.targ:SetPos(tr.HitPos + Vector(0, 0, -50000))
            end

            wep.targ:Spawn()
            wep.laser = ents.Create("env_laser")
            wep.laser:SetKeyValue("texture", "beam/laser01.vmt")
            wep.laser:SetKeyValue("TextureScroll", "100")
            wep.laser:SetKeyValue("noiseamplitude", "1.5")
            wep.laser:SetKeyValue("width", "512")
            wep.laser:SetKeyValue("damage", "10000")
            wep.laser:SetKeyValue("rendercolor", "255 255 255")
            wep.laser:SetKeyValue("renderamt", "255")
            wep.laser:SetKeyValue("dissolvetype", "0")
            wep.laser:SetKeyValue("lasertarget", tostring(wep.targ))

            if hitPlayer then
                wep.laser:SetPos(hitPlayerPos)
            else
                wep.laser:SetPos(trace.HitPos)
            end

            wep.laser:Spawn()
            wep.laser:Fire("turnon", 0)
            wep.effects = ents.Create("effects")

            if hitPlayer then
                wep.effects:SetPos(hitPlayerPos)
            else
                wep.effects:SetPos(trace.HitPos)
            end

            wep.effects:Spawn()
            wep.remover = ents.Create("remover")

            if hitPlayer then
                wep.remover:SetPos(hitPlayerPos)
            else
                wep.remover:SetPos(trace.HitPos)
            end

            wep.remover:Spawn()
            wep.blastwave = ents.Create("blastwave")

            if hitPlayer then
                wep.blastwave:SetPos(hitPlayerPos)
            else
                wep.blastwave:SetPos(trace2.HitPos)
            end

            wep.blastwave:Spawn()
        end

        function SWEP:PrimaryAttack()
            if not IsFirstTimePredicted() then return end
            local tr = self:GetOwner():GetEyeTrace()
            local hitPlayer = nil

            if IsPlayer(tr.Entity) then
                hitPlayer = tr.Entity
            end

            local tracedata = {}
            tracedata.start = tr.HitPos + Vector(0, 0, 0)
            tracedata.endpos = tr.HitPos + Vector(0, 0, 50000)
            tracedata.filter = ents.GetAll()
            local trace = util.TraceLine(tracedata)

            if trace.HitSky == true then
                hitsky = true
            else
                hitsky = true
            end

            if hitsky == true then
                self:GetOwner():SetAnimation(PLAYER_ATTACK1)
                self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
            else
                self:EmitSound(FailSound)
            end

            if not SERVER then return end

            if hitsky == true then
                self:TakePrimaryAmmo(1)

                if hitPlayer then
                    hitPlayer:EmitSound("OBC/LTBCKI.wav", 125, 100)
                else
                    sound.Play("OBC/LTBCKI.wav", tr.HitPos, 125, 100)
                end

                timer.Simple(5, function()
                    BassCannonStart(tr, trace, self, hitPlayer)
                end)

                timer.Simple(18, function()
                    kill(self)
                end)
            end
        end
    elseif class == "weapon_ttt_homebat" and CLIENT then
        -- Fixes lua error with the homerun bat
        net.Receive("Bat Primary Hit", function()
            local tr, _, wep = net.ReadTable(), net.ReadEntity(), net.ReadEntity()
            local ent = tr.Entity
            if not IsValid(ent) then return end
            local edata = EffectData()
            edata:SetStart(tr.StartPos)
            edata:SetOrigin(tr.HitPos)
            edata:SetNormal(tr.Normal)
            edata:SetSurfaceProp(tr.SurfaceProps)
            edata:SetHitBox(tr.HitBox)
            edata:SetEntity(ent)
            local isply = ent:IsPlayer()

            if isply and ent:GetClass() == "prop_ragdoll" then
                if isply then
                    wep:EmitSound("Bat.Sound")

                    timer.Simple(.48, function()
                        if IsValid(ent) and IsValid(wep) and ent:Alive() then
                            wep:EmitSound("Bat.HomeRun")
                        end
                    end)
                end

                util.Effect("BloodImpact", edata)
            else
                util.Effect("Impact", edata)
            end
        end)
    elseif class == "weapons_ttt_time_manipulator" then
        -- Fixes lua errors with the time manipulator
        function SWEP:SecondaryAttack()
            if not self:CanPrimaryAttack() then return end
            self:TakePrimaryAmmo(1)
            self:SetNextPrimaryFire(CurTime() + 30)
            self:SetNextSecondaryFire(CurTime() + 30)
            self:GetOwner():PrintMessage(HUD_PRINTTALK, "Sped up time!")

            if SERVER then
                game.SetTimeScale(GetConVar("tm_speedup"):GetFloat())
            end

            timer.Simple(30, function()
                if SERVER then
                    game.SetTimeScale(1)
                end

                if IsValid(self) and IsPlayer(self:GetOwner()) then
                    self:GetOwner():PrintMessage(HUD_PRINTTALK, "Slowed down time!")
                end
            end)
        end

        function SWEP:PrimaryAttack()
            if not self:CanPrimaryAttack() then return end
            self:TakePrimaryAmmo(1)
            self:SetNextPrimaryFire(CurTime() + 5)
            self:SetNextSecondaryFire(CurTime() + 5)
            self:GetOwner():PrintMessage(HUD_PRINTTALK, "Slowed down time!")

            if SERVER then
                game.SetTimeScale(GetConVar("tm_slowdown"):GetFloat())
            end

            timer.Simple(5, function()
                if SERVER then
                    game.SetTimeScale(1)
                end

                if IsValid(self) and IsPlayer(self:GetOwner()) then
                    self:GetOwner():PrintMessage(HUD_PRINTTALK, "Sped up time!")
                end
            end)
        end
    elseif class == "ttt_amaterasu" then
        -- Fixes lua error with the amatratsu weapon
        hook.Add("PlayerHurt", "AmaterasuCheck", function(target, attacker, healthremaining, damagetaken)
            if IsValid(target) and target:IsPlayer() and target:GetNWBool("amatBurning") and IsValid(attacker) and attacker:IsPlayer() then
                local wep = attacker:GetActiveWeapon()

                if IsValid(wep) and wep:GetClass() == "weapon_zm_improvised" then
                    target:SetNWBool("amatBurning", false)
                    target:Extinguish()
                end
            end
        end)
    end
end)

-- 
-- 
-- Weapon entities changes
-- 
-- 
hook.Add("PreRegisterSENT", "StigSpecialWeaponChangesEntities", function(ENT, class)
    if class == "projectile_laser_sandbox" then
        -- Fixes a heck of a lua error dump spam whenever the orbital base cannon is used
        -- (10,000+ lines of errors...)
        function ENT:Initialize()
            self.Touched = {}
            self.OriginalAngles = self:GetAngles()
            self.flightvector = self:GetForward() * 40

            if SERVER then
                self:Fire("kill", "", 0.6)
            end

            self:SetModel("models/weapons/w_bugbait.mdl")
            self:DrawShadow(false)
            self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            self:SetCustomCollisionCheck(true)
            self:PhysicsInit(SOLID_VPHYSICS)
            self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            self:SetColor(Color(255, 255, 255, 0))
            self:SetMaterial("sprites/heatwave")

            if SERVER then
                self:SetTrigger(true)
            end

            self:SetCustomCollisionCheck(true)
        end

        function ENT:Think()
            local owner = self:GetOwner()
            local shootpos = owner:GetShootPos()
            local aimvector = owner:GetAimVector()
            local filter = owner

            local tr = util.TraceLine({
                start = shootpos,
                endpos = shootpos + aimvector * 50000,
                filter = filter
            })

            if not IsValid(tr.Entity) then
                tr = util.TraceHull({
                    start = shootpos,
                    endpos = shootpos + aimvector * 50000,
                    filter = filter,
                    mins = Vector(-3, -3, -3),
                    maxs = Vector(3, 3, 3)
                })
            end

            if CLIENT then
                self:SetRenderBoundsWS(self:GetEndPos(), self:GetPos(tr.HitPos), Vector() * 8)
            end

            if not self.Size then
                self.Size = 0
            end

            self.Size = math.Approach(self.Size, 1, 10 * FrameTime())
        end

        local matLight = Material("egon/muzzlelight")

        function ENT:Draw()
            self:DrawModel()
            local Owner = self:GetOwner()
            if not Owner or Owner == NULL then return end
            local owner = self:GetOwner()
            local shootpos = owner:GetShootPos()
            local aimvector = owner:GetAimVector()

            local filter = {Owner, Owner:GetActiveWeapon()}

            local tr = util.TraceLine({
                start = shootpos,
                endpos = shootpos + aimvector * 50000,
                filter = filter
            })

            if not IsValid(tr.Entity) then
                tr = util.TraceHull({
                    start = shootpos,
                    endpos = shootpos + aimvector * 50000,
                    filter = filter,
                    mins = Vector(-3, -3, -3),
                    maxs = Vector(3, 3, 3)
                })
            end

            local tr1 = util.TraceLine({
                start = shootpos,
                endpos = shootpos + aimvector * 1,
                filter = filter
            })

            if not IsValid(tr.Entity) then
                tr1 = util.TraceHull({
                    start = shootpos,
                    endpos = shootpos + aimvector * 1,
                    filter = filter,
                    mins = Vector(-3, -3, -3),
                    maxs = Vector(3, 3, 3)
                })
            end

            local StartPos = tr1.HitPos + self:GetOwner():GetForward() * 25 + self:GetOwner():GetUp() * 0 + self:GetOwner():GetRight() * 10
            local EndPos = tr.HitPos
            local ViewModel = Owner == LocalPlayer()
            local angle = self:SetAngles(Angle(-0, -0, -0))

            -- If it's the local player we start at the viewmodel
            if ViewModel then
                local vm1 = Owner:GetViewModel()
                if not vm1 or vm1 == NULL then return end
                local attachment = vm1:GetAttachment(1)

                if attachment then
                    StartPos = attachment.Pos
                else
                    -- If we're viewing another player we start at their weapon
                    local vm2 = Owner:GetActiveWeapon()
                    if not vm2 or vm2 == NULL then return end
                    attachment = vm2:GetAttachment(1)

                    if attachment then
                        StartPos1 = attachment.Pos
                    end
                end
            end

            -- Predict the endpoint, smoother, faster, harder, stronger
            tr.endpos = tr.HitPos

            tr.filter = {Owner, Owner:GetActiveWeapon()}

            EndPos = tr.HitPos
            -- Make the texture coords relative to distance so they're always a nice size
            local Distance = EndPos:Distance(StartPos) * self.Size
            angle = (EndPos - StartPos):Angle()
            local Normal = angle:Forward()
            render.SetMaterial(matLight)
            render.DrawQuadEasy(EndPos + tr.HitNormal, tr.HitNormal, 64 * self.Size, 64 * self.Size, color_white)
            render.DrawQuadEasy(EndPos + tr.HitNormal, tr.HitNormal, math.Rand(32, 128) * self.Size, math.Rand(32, 128) * self.Size, color_white)
            render.DrawSprite(EndPos + tr.HitNormal, 64, 64, Color(255, 150, 150, self.Size * 255))
            -- Draw the beam
            self:DrawMainBeam(StartPos, StartPos + Normal * Distance)
            -- Draw curly Beam
            self:DrawCurlyBeam(StartPos, StartPos + Normal * Distance, angle)
            -- Light glow coming from gun to hide ugly edges :x
            render.SetMaterial(matLight)
            render.DrawSprite(StartPos, 128, 128, Color(255, 0, 0, 255 * self.Size))
            render.DrawSprite(StartPos + Normal * 32, 64, 64, Color(255, 150, 150, 255 * self.Size))

            if not self.LastDecal or self.LastDecal < CurTime() then
                util.Decal("DarkEgonBurn", StartPos, StartPos + Normal * Distance * 1.1)
                self.LastDecal = CurTime() + 0.01
            end
        end
    elseif class == "ttt_shark_trap" then
        -- Fixes the shark trap not killing when it should
        -- and error spamming whenever touching something that is not a player
        function ENT:Touch(toucher)
            if not IsPlayer(toucher) or not IsValid(self) then return end
            toucher:Freeze(true)
            self:Remove()
            self:EmitSound("shark_trap.mp3", 100, 100, 1)

            timer.Simple(1.6, function()
                local effectData = EffectData()
                effectData:SetOrigin(toucher:GetPos())
                effectData:SetScale(20)
                effectData:SetMagnitude(20)
                util.Effect("watersplash", effectData)
                local shark = ents.Create("ttt_shark_ent")
                shark:SetPos(toucher:GetPos() + Vector(0, 0, -75))
                shark:SetAngles(Angle(90, 0, 0))
                shark:SetLocalVelocity(Vector(0, 0, 200))
                shark:Spawn()

                timer.Simple(0.5, function()
                    shark:SetLocalVelocity(Vector(0, 0, -300))
                end)

                --- Dmg Info ---
                local dmg = DamageInfo()
                local inflictor = ents.Create("ttt_shark_trap")
                dmg:SetAttacker(toucher)
                dmg:SetInflictor(inflictor)
                dmg:SetDamage(10000)
                dmg:SetDamageType(DMG_CLUB)
                ------
                toucher:TakeDamageInfo(dmg)
                toucher:Freeze(false)

                timer.Simple(2.5, function()
                    if IsValid(shark) then
                        shark:Remove()
                    end
                end)
            end)
        end
    elseif class == "ttt_beenade_proj" then
        -- Fixes beenade not dealing less damage to non-vanilla traitors
        function BeeNadeDamage(victim, dmg)
            local attacker = dmg:GetAttacker()

            -- Fixed error when victim is nil
            if IsValid(attacker) and attacker:IsNPC() and attacker:GetClass() == BeeNPCClass then
                if not IsValid(victim) then
                    dmg:SetDamage(BeeInnocentDamage)
                elseif victim:GetRole() == ROLE_INNOCENT or (victim.IsInnocentTeam and victim:IsInnocentTeam()) then
                    dmg:SetDamage(BeeInnocentDamage)
                elseif victim:GetRole() == ROLE_TRAITOR or (victim.IsTraitorTeam and victim:IsTraitorTeam()) then
                    dmg:SetDamage(BeeTraitorDamage)
                else
                    dmg:SetDamage(BeeInnocentDamage)
                end
            end

            --Annoyingly complex check to make the headcrab ragdolls invisible
            if victim:GetClass() == BeeNPCClass then
                dmg:SetDamageType(DMG_REMOVENORAGDOLL)

                --Odd behaviour occured when killing Bees with the 'crowbar'
                --Extra steps had to be taken to reliably hide the ragdoll.
                if dmg:GetInflictor():GetClass() == "weapon_zm_improvised" then
                    local Bee = ents.Create("prop_physics")
                    Bee:SetModel("models/lucian/props/stupid_bee.mdl")
                    Bee:SetPos(victim:GetPos())
                    Bee:SetAngles(victim:GetAngles() + Angle(0, -90, 0))
                    Bee:SetColor(Color(128, 128, 128, 255))
                    Bee:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                    Bee:Spawn()
                    Bee:Activate()
                    local phys = Bee:GetPhysicsObject()

                    if not (phys and IsValid(phys)) then
                        Bee:Remove()
                    end

                    victim:SetNoDraw(false)
                    victim:SetColor(Color(255, 2555, 255, 1))
                    victim:Remove()
                end

                if dmg:GetDamageType() == DMG_DROWN then
                    dmg:SetDamage(0)
                end

                if victim:Health() - dmg:GetDamage() < 980 then
                    local Bee = ents.Create("prop_physics")
                    Bee:SetModel("models/lucian/props/stupid_bee.mdl")
                    Bee:SetPos(victim:GetPos())
                    Bee:SetAngles(victim:GetAngles() + Angle(0, -90, 0))
                    Bee:SetColor(Color(128, 128, 128, 255))
                    Bee:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                    Bee:Spawn()
                    Bee:Activate()
                    local phys = Bee:GetPhysicsObject()

                    if not (phys and IsValid(phys)) then
                        Bee:Remove()
                    end

                    victim:Remove()
                end
            end
        end

        hook.Add("EntityTakeDamage", "BeenadeDmgHandle", BeeNadeDamage)
    elseif class == "ttt_minictest" then
        -- Fixes error spam with the mimic spawner
        local JUMP_HORIZ_SPEED = 400
        local ATTACK_DIST = 150

        function ENT:JumpAtTarget()
            if self.Target ~= NULL then
                local vel

                if self.TargetHasPhysics and IsValid(self.TargetPhys) then
                    vel = self.TargetPhys:GetVelocity()
                else
                    vel = self.Target:GetVelocity()
                end

                local mypos = self:GetPos()
                local targpos = self.Target:EyePos()
                local disp = targpos - mypos
                local proj = vel - disp:Dot(vel) / disp:Dot(disp) * disp
                local dest = targpos + proj * 0.6
                local dist = mypos:Distance(dest)
                vel = (dest - mypos) * JUMP_HORIZ_SPEED / dist
                vel.z = 250

                if vel.z < 20 then
                    vel.z = 20
                end

                if type(vel) ~= "userdata" and IsValid(self.Phys) then
                    self.Phys:AddVelocity(vel)
                end

                local ang = Vector(0, 0, 5)

                if type(ang) == "Vector" and IsValid(self.Phys) then
                    self.Phys:AddAngleVelocity(ang)
                end

                -- Attack!
                if dist < ATTACK_DIST then
                    self.Attacking = true
                else
                    self.Attacking = true
                end
            end
        end

        function ENT:PhysicsCollide(data, phys)
            if data.Speed < 30 then return end

            if data.Speed > 900 then
                self:TakeDamage(0.2 * (data.Speed - 900), data.HitEntity, data.HitEntity)
            end

            if self.Attacking and not (data.HitEntity:IsWorld() or data.HitEntity.IsChicken) then
                local dmg = 5

                if data.HitEntity:IsPlayer() then
                    if data.HitEntity:GetRole() == ROLE_DETECTIVE then
                        dmg = 10
                    end

                    if IsValid(data.HitEntity:GetActiveWeapon()) and data.HitEntity:GetActiveWeapon():GetClass() == "weapon_ttt_riot" then
                        dmg = 5
                    end
                end

                local dmginfo = DamageInfo()
                dmginfo:SetDamage(dmg)
                dmginfo:SetAttacker(self.Attacker)
                dmginfo:SetInflictor(self)
                dmginfo:SetDamageType(DMG_CLUB)
                dmginfo:SetDamageForce(self:GetPos() - data.HitEntity:GetPos())
                dmginfo:SetDamagePosition(data.HitEntity:GetPos())

                if self.IsPoisoned and data.HitEntity:IsPlayer() and isfunction(TakePoisonDamage) then
                    TakePoisonDamage(data.HitEntity, self.Attacker, self)
                end

                data.HitEntity:TakeDamageInfo(dmginfo)
                self.Attacking = false
            end
        end
    elseif class == "ttt_liftgren_proj" then
        -- Fixes error spam with the lift grenade
        function ENT:Explode(tr)
            if SERVER then
                self:SetNoDraw(true)
                self:SetSolid(SOLID_NONE)

                if tr.Fraction ~= 1.0 then
                    self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
                end

                local pos = self:GetPos()
                local effect = EffectData()
                effect:SetStart(pos)
                effect:SetOrigin(pos)
                effect:SetScale(2)
                effect:SetRadius(2)
                effect:SetMagnitude(2)

                if tr.Fraction ~= 1.0 then
                    effect:SetNormal(tr.HitNormal)
                end

                -- copied code:
                for k, v in pairs(ents.FindInSphere(self:GetPos(), 150)) do
                    if IsValid(v) and v:GetClass() ~= "ttt_liftgren_proj" then
                        if v:IsPlayer() or v:IsNPC() then
                            local backupgravity = v:GetGravity()
                            v:SetGravity(-0.0001)
                            v:SetLocalVelocity(Vector(0, 0, 251))

                            timer.Simple(4.5, function()
                                v:SetGravity(backupgravity)
                            end)
                        elseif v:GetClass() ~= "ttt_liftgren_proj" and v:GetPhysicsObject():IsValid() then
                            v:GetPhysicsObject():EnableGravity(false)
                            v:GetPhysicsObject():SetVelocity(v:GetVelocity() + Vector(0, 0, 251))

                            timer.Simple(4.5, function()
                                if IsValid(v) then
                                    v:GetPhysicsObject():EnableGravity(true)
                                end
                            end)
                        end
                    end
                end

                self:EmitSound("ambient/machines/thumper_hit.wav", SNDLVL_180dB)
                self:EmitSound("npc/vort/health_charge.wav", SNDLVL_140dB)
                local effectdata = EffectData()
                effectdata:SetOrigin(self:GetPos())
                util.Effect("VortDispel", effectdata)
                self:Remove()
            end
        end
    elseif class == "zay_shell" and SERVER then
        -- Makes it so players behind cover take reduced damage from the artillery cannon
        local coverCvar = CreateConVar("ttt_rebalance_artillery_cover_damage", "1", nil, "Wether players should take reduced damage behind cover from the artillery cannon")

        function ENT:PhysicsCollide(data, phys)
            if self.zay_Collided == true then return end

            timer.Simple(0, function()
                if not IsValid(self) then return end
                self:SetNoDraw(true)
                local a_phys = self:GetPhysicsObject()

                if IsValid(a_phys) then
                    a_phys:Wake()
                    a_phys:EnableMotion(false)
                end
            end)

            zay.f.CreateNetEffect("shell_explosion", self:GetPos())

            for _, ent in pairs(ents.FindInSphere(self:GetPos(), GetConVar("ttt_artillery_range"):GetFloat())) do
                if IsValid(ent) then
                    local Trace = {}
                    Trace.start = self:GetPos()
                    Trace.endpos = ent:GetPos()

                    Trace.filter = {self, ent}

                    Trace.mask = MASK_SHOT
                    Trace.collisiongroup = COLLISION_GROUP_PROJECTILE
                    local TraceResult = util.TraceLine(Trace)
                    local damage = GetConVar("ttt_artillery_damage"):GetFloat()

                    -- Players behind cover take half damage
                    if coverCvar:GetBool() and TraceResult.Hit then
                        damage = damage / 2
                    end

                    local d = DamageInfo()
                    d:SetDamage(damage)
                    d:SetAttacker(self:GetPhysicsAttacker())
                    d:SetInflictor(self)
                    d:SetDamageType(DMG_BLAST)
                    ent:TakeDamageInfo(d)
                end
            end

            local deltime = FrameTime() * 2

            if not game.SinglePlayer() then
                deltime = FrameTime() * 6
            end

            SafeRemoveEntityDelayed(self, deltime)
            self.zay_Collided = true
        end
    end
end)