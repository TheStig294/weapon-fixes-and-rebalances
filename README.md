# TTT Weapon Stats Changer

This mod allows you to change the stats of weapons or enable/disable individual weapons using convars. It is compatible with any weapon that uses the standard SWEP.Primary table to store gun stats, which is the vast majority of weapons on the Steam Workshop.

## Steam Workshop Link

<https://steamcommunity.com/sharedfiles/filedetails/?id=3007222612>

## Manipulating weapon stats

Below is a list of commonly used TTT weapon packs and their stats for you to manipulate for your convenience.\
All weapon stat convars are in the format: `[Classname]_[Stat]`\
The stats available are:

- enabled
- recoil
- spread
- firedelay
- damage
- ammosize
- startingammo

Not every weapon supports every stat, but every weapon will support the `enabled` stat, allowing you to disable the weapon if you set it to 0.

## How to use convars

To find a weapon's classname, obtain it in-game, and type the following into the console: `lua_run PrintTable(Entity(1):GetWeapons())`\
\
E.g. The Glock's classname is `weapon_ttt_glock`, so `weapon_ttt_glock_enabled 0`, will prevent the glock from spawning, `weapon_ttt_glock_damage 10` will make the glock deal 10 damage, `weapon_ttt_glock_firedelay 0.25` will make the glock shoot 4 times a second, etc.\
\
Copy the below into your server's server.cfg, or to your local Gmod install's listenserver.cfg if you are hosting games just from the Gmod main menu, normally at: C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\garrysmod\cfg

### Default Weapons

```cfg
weapon_ttt_cse_enabled 1
weapon_ttt_cse_ammosize -1
weapon_ttt_cse_firedelay 1
weapon_ttt_cse_startingammo -1

weapon_ttt_flaregun_enabled 1
weapon_ttt_flaregun_ammosize 4
weapon_ttt_flaregun_recoil 4
weapon_ttt_flaregun_spread 0.01
weapon_ttt_flaregun_firedelay 1
weapon_ttt_flaregun_damage 7
weapon_ttt_flaregun_startingammo 4

weapon_ttt_defuser_enabled 1
weapon_ttt_defuser_ammosize -1
weapon_ttt_defuser_firedelay 1
weapon_ttt_defuser_startingammo -1

weapon_ttt_m16_enabled 1
weapon_ttt_m16_ammosize 20
weapon_ttt_m16_recoil 1.6
weapon_ttt_m16_spread 0.018
weapon_ttt_m16_firedelay 0.19
weapon_ttt_m16_damage 23
weapon_ttt_m16_startingammo 20

weapon_medkit_enabled 1
weapon_medkit_ammosize 100
weapon_medkit_startingammo 100

weapon_ttt_knife_enabled 1
weapon_ttt_knife_ammosize -1
weapon_ttt_knife_firedelay 1.1
weapon_ttt_knife_damage 50
weapon_ttt_knife_startingammo -1

weapon_ttt_teleport_enabled 1
weapon_ttt_teleport_ammosize 16
weapon_ttt_teleport_firedelay 0.5
weapon_ttt_teleport_startingammo 16

weapon_ttt_binoculars_enabled 1
weapon_ttt_binoculars_ammosize -1
weapon_ttt_binoculars_firedelay 1
weapon_ttt_binoculars_startingammo -1

weapon_ttt_unarmed_enabled 1
weapon_ttt_unarmed_ammosize -1
weapon_ttt_unarmed_startingammo -1

weapon_zm_shotgun_enabled 1
weapon_zm_shotgun_ammosize 8
weapon_zm_shotgun_recoil 7
weapon_zm_shotgun_spread 0.082
weapon_zm_shotgun_firedelay 0.8
weapon_zm_shotgun_damage 11
weapon_zm_shotgun_startingammo 8

weapon_ttt_radio_enabled 1
weapon_ttt_radio_ammosize -1
weapon_ttt_radio_firedelay 1
weapon_ttt_radio_startingammo -1

weapon_ttt_push_enabled 1
weapon_ttt_push_ammosize -1
weapon_ttt_push_spread 0.005
weapon_ttt_push_firedelay 3
weapon_ttt_push_startingammo -1

weapon_ttt_stungun_enabled 1
weapon_ttt_stungun_ammosize 30
weapon_ttt_stungun_recoil 1.2
weapon_ttt_stungun_spread 0.02
weapon_ttt_stungun_firedelay 0.1
weapon_ttt_stungun_damage 9
weapon_ttt_stungun_startingammo 30

weapon_ttt_smokegrenade_enabled 1

weapon_ttt_health_station_enabled 1
weapon_ttt_health_station_ammosize -1
weapon_ttt_health_station_firedelay 1
weapon_ttt_health_station_startingammo -1

weapon_ttt_beacon_enabled 1
weapon_ttt_beacon_ammosize 3
weapon_ttt_beacon_firedelay 1
weapon_ttt_beacon_startingammo 1

weapon_zm_molotov_enabled 1

weapon_ttt_sipistol_enabled 1
weapon_ttt_sipistol_ammosize 20
weapon_ttt_sipistol_recoil 1.35
weapon_ttt_sipistol_spread 0.02
weapon_ttt_sipistol_firedelay 0.38
weapon_ttt_sipistol_damage 28
weapon_ttt_sipistol_startingammo 20

weapon_ttt_glock_enabled 1
weapon_ttt_glock_ammosize 20
weapon_ttt_glock_recoil 0.9
weapon_ttt_glock_spread 0.028
weapon_ttt_glock_firedelay 0.1
weapon_ttt_glock_damage 12
weapon_ttt_glock_startingammo 20

weapon_ttt_wtester_enabled 1
weapon_ttt_wtester_ammosize -1
weapon_ttt_wtester_firedelay 1
weapon_ttt_wtester_startingammo -1

weapon_zm_rifle_enabled 1
weapon_zm_rifle_ammosize 10
weapon_zm_rifle_recoil 7
weapon_zm_rifle_spread 0.005
weapon_zm_rifle_firedelay 1.5
weapon_zm_rifle_damage 50
weapon_zm_rifle_startingammo 10

weapon_zm_mac10_enabled 1
weapon_zm_mac10_ammosize 30
weapon_zm_mac10_recoil 1.15
weapon_zm_mac10_spread 0.03
weapon_zm_mac10_firedelay 0.065
weapon_zm_mac10_damage 12
weapon_zm_mac10_startingammo 30

weapon_ttt_decoy_enabled 1
weapon_ttt_decoy_ammosize -1
weapon_ttt_decoy_firedelay 1
weapon_ttt_decoy_startingammo -1

weapon_zm_pistol_enabled 1
weapon_zm_pistol_ammosize 20
weapon_zm_pistol_recoil 1.5
weapon_zm_pistol_spread 0.02
weapon_zm_pistol_firedelay 0.38
weapon_zm_pistol_damage 25
weapon_zm_pistol_startingammo 20

weapon_ttt_phammer_enabled 1
weapon_ttt_phammer_ammosize 6
weapon_ttt_phammer_recoil 0.1
weapon_ttt_phammer_spread 0.02
weapon_ttt_phammer_firedelay 12
weapon_ttt_phammer_startingammo 6

weapon_ttt_confgrenade_enabled 1

weapon_ttt_c4_enabled 1
weapon_ttt_c4_ammosize -1
weapon_ttt_c4_firedelay 5
weapon_ttt_c4_startingammo -1

weapon_zm_sledge_enabled 1
weapon_zm_sledge_ammosize 150
weapon_zm_sledge_recoil 1.9
weapon_zm_sledge_spread 0.09
weapon_zm_sledge_firedelay 0.06
weapon_zm_sledge_damage 7
weapon_zm_sledge_startingammo 150

weapon_zm_revolver_enabled 1
weapon_zm_revolver_ammosize 8
weapon_zm_revolver_recoil 6
weapon_zm_revolver_spread 0.02
weapon_zm_revolver_firedelay 0.6
weapon_zm_revolver_damage 37
weapon_zm_revolver_startingammo 8

weapon_zm_improvised_enabled 1
weapon_zm_improvised_ammosize -1
weapon_zm_improvised_firedelay 0.5
weapon_zm_improvised_damage 20
weapon_zm_improvised_startingammo -1

weapon_zm_carry_enabled 1
weapon_zm_carry_ammosize -1
weapon_zm_carry_firedelay 0.1
weapon_zm_carry_startingammo -1
```

### Lykrast's Weapon Collection

<https://steamcommunity.com/sharedfiles/filedetails/?id=337994500>

```cfg
weapon_ap_vector_enabled 1
weapon_ap_vector_ammosize 30
weapon_ap_vector_recoil 0.69999998807907
weapon_ap_vector_spread 0.05
weapon_ap_vector_firedelay 0.04
weapon_ap_vector_damage 14
weapon_ap_vector_startingammo 30

weapon_pp_remington_enabled 1
weapon_pp_remington_ammosize 6
weapon_pp_remington_recoil 5
weapon_pp_remington_spread 0.03
weapon_pp_remington_firedelay 0.3
weapon_pp_remington_damage 35
weapon_pp_remington_startingammo 6

weapon_sp_striker_enabled 1
weapon_sp_striker_ammosize 8
weapon_sp_striker_recoil 9
weapon_sp_striker_spread 0.095
weapon_sp_striker_firedelay 0.3
weapon_sp_striker_damage 6
weapon_sp_striker_startingammo 8

weapon_sp_winchester_enabled 1
weapon_sp_winchester_ammosize 8
weapon_sp_winchester_recoil 7
weapon_sp_winchester_spread 0.01
weapon_sp_winchester_firedelay 0.9
weapon_sp_winchester_damage 50
weapon_sp_winchester_startingammo 8

weapon_ap_pp19_enabled 1
weapon_ap_pp19_ammosize 60
weapon_ap_pp19_recoil 1.2000000476837
weapon_ap_pp19_spread 0.02
weapon_ap_pp19_firedelay 0.050000000745058
weapon_ap_pp19_damage 7
weapon_ap_pp19_startingammo 60

weapon_sp_dbarrel_enabled 1
weapon_sp_dbarrel_ammosize 2
weapon_sp_dbarrel_recoil 14
weapon_sp_dbarrel_spread 0.12
weapon_sp_dbarrel_firedelay 0.2
weapon_sp_dbarrel_damage 8
weapon_sp_dbarrel_startingammo 2

weapon_hp_ares_shrike_enabled 1
weapon_hp_ares_shrike_ammosize 100
weapon_hp_ares_shrike_recoil 2.5
weapon_hp_ares_shrike_spread 0.07
weapon_hp_ares_shrike_firedelay 0.095
weapon_hp_ares_shrike_damage 12
weapon_hp_ares_shrike_startingammo 200

weapon_ap_tec9_enabled 1
weapon_ap_tec9_ammosize 30
weapon_ap_tec9_recoil 1.2
weapon_ap_tec9_spread 0.06
weapon_ap_tec9_firedelay 0.04
weapon_ap_tec9_damage 12
weapon_ap_tec9_startingammo 30

weapon_ap_hbadger_enabled 1
weapon_ap_hbadger_ammosize 30
weapon_ap_hbadger_recoil 1.35
weapon_ap_hbadger_spread 0.03
weapon_ap_hbadger_firedelay 0.09
weapon_ap_hbadger_damage 14
weapon_ap_hbadger_startingammo 30

weapon_rp_railgun_enabled 1
weapon_rp_railgun_ammosize 4
weapon_rp_railgun_recoil 7
weapon_rp_railgun_spread 0.005
weapon_rp_railgun_firedelay 2.5
weapon_rp_railgun_damage 20
weapon_rp_railgun_startingammo 4

weapon_ap_golddragon_enabled 1
weapon_ap_golddragon_ammosize 30
weapon_ap_golddragon_recoil 1.6
weapon_ap_golddragon_spread 0.016
weapon_ap_golddragon_firedelay 0.11
weapon_ap_golddragon_damage 7
weapon_ap_golddragon_startingammo 30

weapon_hp_glauncher_enabled 1
weapon_hp_glauncher_ammosize 6
weapon_hp_glauncher_recoil 7
weapon_hp_glauncher_firedelay 0.25
weapon_hp_glauncher_damage 45
weapon_hp_glauncher_startingammo 6

weapon_pp_rbull_enabled 1
weapon_pp_rbull_ammosize 6
weapon_pp_rbull_recoil 8
weapon_pp_rbull_spread 0.02
weapon_pp_rbull_firedelay 0.8
weapon_pp_rbull_damage 24
weapon_pp_rbull_startingammo 6

weapon_rp_pocket_enabled 1
weapon_rp_pocket_ammosize 1
weapon_rp_pocket_recoil 8
weapon_rp_pocket_spread 0.005
weapon_rp_pocket_firedelay 1.7
weapon_rp_pocket_damage 75
weapon_rp_pocket_startingammo 1

weapon_ap_mrca1_enabled 1
weapon_ap_mrca1_ammosize 20
weapon_ap_mrca1_recoil 0.9
weapon_ap_mrca1_spread 0.03
weapon_ap_mrca1_firedelay 0.12
weapon_ap_mrca1_damage 19
weapon_ap_mrca1_startingammo 20
```

### TTT weapon collection

<https://steamcommunity.com/sharedfiles/filedetails/?id=194965598>

```cfg
weapon_ttt_pistol_enabled 1
weapon_ttt_pistol_ammosize 20
weapon_ttt_pistol_recoil 0.8
weapon_ttt_pistol_spread 0.025
weapon_ttt_pistol_firedelay 0.15
weapon_ttt_pistol_damage 12
weapon_ttt_pistol_startingammo 20

weapon_ttt_mp5_enabled 1
weapon_ttt_mp5_ammosize 30
weapon_ttt_mp5_recoil 0.6
weapon_ttt_mp5_spread 0.03
weapon_ttt_mp5_firedelay 0.08
weapon_ttt_mp5_damage 18
weapon_ttt_mp5_startingammo 30

weapon_ttt_galil_enabled 1
weapon_ttt_galil_ammosize 30
weapon_ttt_galil_recoil 0.8
weapon_ttt_galil_spread 0.025
weapon_ttt_galil_firedelay 0.095
weapon_ttt_galil_damage 18
weapon_ttt_galil_startingammo 30

weapon_ttt_p90_enabled 1
weapon_ttt_p90_ammosize 50
weapon_ttt_p90_recoil 0.8
weapon_ttt_p90_spread 0.032
weapon_ttt_p90_firedelay 0.065
weapon_ttt_p90_damage 14
weapon_ttt_p90_startingammo 50

weapon_ttt_p228_enabled 1
weapon_ttt_p228_ammosize 20
weapon_ttt_p228_recoil 0.9
weapon_ttt_p228_spread 0.028
weapon_ttt_p228_firedelay 0.25
weapon_ttt_p228_damage 25
weapon_ttt_p228_startingammo 20

weapon_ttt_ak47_enabled 1
weapon_ttt_ak47_ammosize 30
weapon_ttt_ak47_recoil 1.7
weapon_ttt_ak47_spread 0.025
weapon_ttt_ak47_firedelay 0.1
weapon_ttt_ak47_damage 24
weapon_ttt_ak47_startingammo 30

weapon_ttt_famas_enabled 1
weapon_ttt_famas_ammosize 30
weapon_ttt_famas_recoil 0.8
weapon_ttt_famas_spread 0.025
weapon_ttt_famas_firedelay 0.08
weapon_ttt_famas_damage 17
weapon_ttt_famas_startingammo 30

weapon_ttt_aug_enabled 1
weapon_ttt_aug_ammosize 30
weapon_ttt_aug_recoil 1.04
weapon_ttt_aug_spread 0.025
weapon_ttt_aug_firedelay 0.09
weapon_ttt_aug_damage 17
weapon_ttt_aug_startingammo 30

weapon_ttt_awp_enabled 1
weapon_ttt_awp_ammosize 1
weapon_ttt_awp_recoil 10
weapon_ttt_awp_spread 0.001
weapon_ttt_awp_firedelay 2
weapon_ttt_awp_damage 500
weapon_ttt_awp_startingammo 1

weapon_ttt_pump_enabled 1
weapon_ttt_pump_ammosize 8
weapon_ttt_pump_recoil 7
weapon_ttt_pump_spread 0.08
weapon_ttt_pump_firedelay 1.2
weapon_ttt_pump_damage 14
weapon_ttt_pump_startingammo 8

weapon_ttt_smg_enabled 1
weapon_ttt_smg_ammosize 30
weapon_ttt_smg_recoil 0.5
weapon_ttt_smg_spread 0.026
weapon_ttt_smg_firedelay 0.07
weapon_ttt_smg_damage 15
weapon_ttt_smg_startingammo 30

weapon_ttt_tmp_s_enabled 1
weapon_ttt_tmp_s_ammosize 30
weapon_ttt_tmp_s_recoil 1.2
weapon_ttt_tmp_s_spread 0.025
weapon_ttt_tmp_s_firedelay 0.07
weapon_ttt_tmp_s_damage 16
weapon_ttt_tmp_s_startingammo 30

weapon_ttt_suicide_enabled 1
weapon_ttt_suicide_ammosize -1
weapon_ttt_suicide_firedelay 5
weapon_ttt_suicide_startingammo -1

weapon_ttt_sg550_enabled 1
weapon_ttt_sg550_ammosize 20
weapon_ttt_sg550_recoil 2
weapon_ttt_sg550_spread 0.005
weapon_ttt_sg550_firedelay 0.6
weapon_ttt_sg550_damage 42
weapon_ttt_sg550_startingammo 20

weapon_ttt_revolver_enabled 1
weapon_ttt_revolver_ammosize 1
weapon_ttt_revolver_recoil 0.8
weapon_ttt_revolver_spread 0.0325
weapon_ttt_revolver_firedelay 2
weapon_ttt_revolver_damage 500
weapon_ttt_revolver_startingammo 1

weapon_ttt_frag_enabled 1

weapon_ttt_m4a1_s_enabled 1
weapon_ttt_m4a1_s_ammosize 30
weapon_ttt_m4a1_s_recoil 1.2
weapon_ttt_m4a1_s_spread 0.018
weapon_ttt_m4a1_s_firedelay 0.12
weapon_ttt_m4a1_s_damage 19
weapon_ttt_m4a1_s_startingammo 30

weapon_ttt_g3sg1_enabled 1
weapon_ttt_g3sg1_ammosize 20
weapon_ttt_g3sg1_recoil 2
weapon_ttt_g3sg1_spread 0.005
weapon_ttt_g3sg1_firedelay 0.3
weapon_ttt_g3sg1_damage 30
weapon_ttt_g3sg1_startingammo 20

weapon_ttt_sg552_enabled 1
weapon_ttt_sg552_ammosize 30
weapon_ttt_sg552_recoil 1.04
weapon_ttt_sg552_spread 0.025
weapon_ttt_sg552_firedelay 0.11
weapon_ttt_sg552_damage 18
weapon_ttt_sg552_startingammo 30
```

### World War II Guns for TTT

<https://steamcommunity.com/sharedfiles/filedetails/?id=496383004>

```cfg
weapon_m3_enabled 1
weapon_m3_ammosize 30
weapon_m3_recoil 2
weapon_m3_spread 0.05
weapon_m3_firedelay 0.13
weapon_m3_damage 15
weapon_m3_startingammo 90

weapon_dp_enabled 1
weapon_dp_ammosize 50
weapon_dp_recoil 2
weapon_dp_spread 0.05
weapon_dp_firedelay 0.2
weapon_dp_damage 20
weapon_dp_startingammo 150

weapon_t14nambu_enabled 1
weapon_t14nambu_ammosize 8
weapon_t14nambu_recoil 1.4
weapon_t14nambu_spread 0.02
weapon_t14nambu_firedelay 0.35
weapon_t14nambu_damage 20
weapon_t14nambu_startingammo 32

weapon_stenmk3_enabled 1
weapon_stenmk3_ammosize 32
weapon_stenmk3_recoil 1.67
weapon_stenmk3_spread 0.05
weapon_stenmk3_firedelay 0.10909009090901
weapon_stenmk3_damage 18
weapon_stenmk3_startingammo 96

weapon_fg42_enabled 1
weapon_fg42_ammosize 20
weapon_fg42_recoil 1.5
weapon_fg42_spread 0.05
weapon_fg42_firedelay 0.15
weapon_fg42_damage 15
weapon_fg42_startingammo 60

weapon_svt40_enabled 1
weapon_svt40_ammosize 10
weapon_svt40_recoil 2.1
weapon_svt40_spread 0.02
weapon_svt40_firedelay 0.7
weapon_svt40_damage 32
weapon_svt40_startingammo 30

weapon_ppsh41_enabled 1
weapon_ppsh41_ammosize 70
weapon_ppsh41_recoil 1.67
weapon_ppsh41_spread 0.05
weapon_ppsh41_firedelay 0.09
weapon_ppsh41_damage 18
weapon_ppsh41_startingammo 210

weapon_enfield_4_enabled 1
weapon_enfield_4_ammosize 10
weapon_enfield_4_recoil 3.5
weapon_enfield_4_spread 0.0004
weapon_enfield_4_firedelay 1.5
weapon_enfield_4_damage 52
weapon_enfield_4_startingammo 10

weapon_welrod_enabled 1
weapon_welrod_ammosize 6
weapon_welrod_recoil 2.7
weapon_welrod_spread 0.02
weapon_welrod_firedelay 0.34
weapon_welrod_damage 30
weapon_welrod_startingammo 24

weapon_t38_enabled 1
weapon_t38_ammosize 5
weapon_t38_recoil 3.5
weapon_t38_spread 0.004
weapon_t38_firedelay 1.5
weapon_t38_damage 65
weapon_t38_startingammo 15

weapon_lee_enabled 1
weapon_lee_ammosize 8
weapon_lee_recoil 2.7
weapon_lee_spread 0.02
weapon_lee_firedelay 0.56
weapon_lee_damage 40
weapon_lee_startingammo 24

weapon_tt_enabled 1
weapon_tt_ammosize 8
weapon_tt_recoil 2.2
weapon_tt_spread 0.02
weapon_tt_firedelay 0.32
weapon_tt_damage 21
weapon_tt_startingammo 32

weapon_luger_enabled 1
weapon_luger_ammosize 8
weapon_luger_recoil 2.4
weapon_luger_spread 0.02
weapon_luger_firedelay 0.28
weapon_luger_damage 20
weapon_luger_startingammo 32

weapon_gewehr43_enabled 1
weapon_gewehr43_ammosize 10
weapon_gewehr43_recoil 2.1
weapon_gewehr43_spread 0.02
weapon_gewehr43_firedelay 0.38999998569489
weapon_gewehr43_damage 40
weapon_gewehr43_startingammo 30
```
