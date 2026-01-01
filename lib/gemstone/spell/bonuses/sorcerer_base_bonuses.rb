# frozen_string_literal: true

#
# Sorcerer Base (700s) Spell Bonuses
#
# This file defines skill/lore/stat-based bonuses for the Sorcerer Base spell circle.
# All bonus calculations use chart functions from Lich::Util::ChartCalculator.
#
# Sorcerer Base is a hybrid Elemental/Spiritual circle.
# Primary lores: Sorcerous Lore, Necromancy; Sorcerous Lore, Demonology
# Secondary: Spiritual Lore, Summoning; Elemental Lores (for Dark Catalyst)
#
# Reference: https://gswiki.play.net/Sorcerer_Base
# Last Updated: January 1, 2026
#

module Lich
  module Gemstone
    module Spell
      include Lich::Util::ChartCalculator

      SpellBonuses.table[:sorcerer] = {}

      #
      # Spell 701 - Blood Burst
      # https://gswiki.play.net/Blood_Burst_(701)
      #
      # Sorcerous Lore, Necromancy: Blood infusion on major bleed ticks
      # 1 rank activates the effect, scales to 50% transfer at 100 ranks (fully doubled)
      # Excess health becomes a blood shield
      #
      SpellBonuses.table[:sorcerer][701] = {
        "blood infusion" => {
          :description     => "transfer portion of blood loss to caster (1 rank activates, 50% at 100 ranks)",
          :chart           => divide_truncate_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "blood transfer",
          :bonus_max       => 50,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 704 - Phase
      # https://gswiki.play.net/Phase_(704)
      #
      # Sorcerous Lore, Demonology provides two benefits:
      # 1. Weight limit: +2 lbs per seed 3 summation (base 10 lbs, max 44 lbs at 187 ranks)
      # 2. SMR benefit: linear per rank (exact amount NS)
      #
      SpellBonuses.table[:sorcerer][704] = {
        "weight limit increase" => {
          :description     => "+2 lbs weight limit per seed 3 threshold (base 10 lbs, max 44 lbs)",
          :chart           => summation_chart(3),
          :bonus_amount    => 2,
          :bonus_type      => :units,
          :bonus_to        => "weight limit",
          :bonus_max       => 34,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "SMR benefit"           => {
          :description     => "increases SMR benefit linearly per rank (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "SMR benefit",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 705 - Disintegrate
      # https://gswiki.play.net/Disintegrate_(705)
      #
      # Sorcerous Lore, Necromancy provides three benefits:
      # 1. At 20 ranks: Unlocks bolt (evoke) version
      # 2. Damage factor increase (tiered progression)
      # 3. Chance to weaken weapons/shields/armor (seed 6 summation)
      #
      SpellBonuses.table[:sorcerer][705] = {
        "enable bolt version"        => {
          :description     => "20 ranks unlocks bolt version via EVOKE",
          :chart           => flat_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "bolt version",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "bolt damage factor"         => {
          :description     => "+.001 DF per rank (tiered: full 1-50, half 51-100, quarter 101-200)",
          :chart           => damage_factor_chart(1),
          :bonus_amount    => 0.001,
          :bonus_type      => :units,
          :bonus_to        => "damage factor",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "equipment weakening chance" => {
          :description     => "chance to weaken weapons/shields/armor for 60s (seed 6 summation)",
          :chart           => summation_chart(6),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "weakening chance",
          :bonus_max       => 0,
          :duration        => 60,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 708 - Limb Disruption
      # https://gswiki.play.net/Limb_Disruption_(708)
      #
      # Sorcerous Lore, Necromancy: Severed limbs have chance to reanimate
      # Chance based on caster's necromancy ranks vs target's level (formula NS)
      #
      SpellBonuses.table[:sorcerer][708] = {
        "limb reanimation chance" => {
          :description     => "severed limbs may reanimate (chance based on ranks vs target level, formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :percent,
          :bonus_to        => "limb reanimation",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 709 - Grasp of the Grave
      # https://gswiki.play.net/Grasp_of_the_Grave_(709)
      #
      # Sorcerous Lore, Necromancy: Grapple damage based on 2 × seed 2 summation
      # Includes small chance to strangle target
      #
      SpellBonuses.table[:sorcerer][709] = {
        "grapple damage"       => {
          :description     => "grapple damage based on 2 × seed 2 summation of ranks",
          :chart           => summation_chart(2),
          :bonus_amount    => 2,
          :bonus_type      => :units,
          :bonus_to        => "grapple damage",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "strangulation chance" => {
          :description     => "small chance to outright strangle target",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :percent,
          :bonus_to        => "strangulation",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 711 - Pain
      # https://gswiki.play.net/Pain_(711)
      #
      # Sorcerous Lore, Necromancy: Reduces endroll threshold for maximum effect
      # Base threshold: 166+ for max effect (35% health loss, 7s RT)
      # Minimum 0.3 ranks per level required; 1x training reduces to 141+
      #
      SpellBonuses.table[:sorcerer][711] = {
        "endroll threshold reduction" => {
          :description     => "reduces endroll threshold for max effect (base 166+, 1x training = 141+)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "threshold reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 712 - Cloak of Shadows
      # https://gswiki.play.net/Cloak_of_Shadows_(712)
      #
      # Sorcerous Lore, Demonology: Increases demon retaliation chance
      # +0.5% per rank (base 70%, max 95% at 50 ranks)
      # Also reduces backlash chance
      #
      SpellBonuses.table[:sorcerer][712] = {
        "retaliation chance increase" => {
          :description     => "+0.5% retaliation chance per rank (base 70%, max 95% at 50 ranks)",
          :chart           => divide_truncate_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "retaliation chance",
          :bonus_max       => 25,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "backlash reduction"          => {
          :description     => "reduces backlash (self-retaliation) chance (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :percent,
          :bonus_to        => "backlash reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 713 - Balefire
      # https://gswiki.play.net/Balefire_(713)
      #
      # Sorcerous Lore, Demonology provides two benefits:
      # 1. Damage factor increase (tiered progression)
      # 2. Additional targets (ball spell progression)
      #
      SpellBonuses.table[:sorcerer][713] = {
        "damage factor"      => {
          :description     => "+.001 DF per rank (tiered: full 1-50, half 51-100, quarter 101-200)",
          :chart           => damage_factor_chart(1),
          :bonus_amount    => 0.001,
          :bonus_type      => :units,
          :bonus_to        => "damage factor",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "additional targets" => {
          :description     => "additional targets per ball spell progression",
          :chart           => ball_spell_chart(),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "targets",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 715 - Curse
      # https://gswiki.play.net/Curse_(715)
      #
      # Spiritual Lore, Summoning: Increases curse power and strength
      # Curse Power = Sorcerer ranks + (Summoning ranks ÷ 3) + (WIS bonus ÷ 2) + (INF bonus ÷ 5)
      # Curse Strength increases with Summoning (affects item cursing, Remove Curse resistance)
      #
      SpellBonuses.table[:sorcerer][715] = {
        "curse power from summoning" => {
          :description     => "+1 curse power per 3 Summoning ranks",
          :chart           => divide_truncate_chart(3),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "curse power",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "curse strength"             => {
          :description     => "increases curse strength (affects item cursing, Remove Curse resistance)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "curse strength",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 716 - Pestilence
      # https://gswiki.play.net/Pestilence_(716)
      #
      # Sorcerous Lore, Necromancy provides three benefits:
      # 1. Charges: 5 + 1 per seed 9 summation
      # 2. Reactive attack chance: 25% + (2 × seed 9 summation)
      # 3. Spread chance: seed 1 summation percent
      #
      SpellBonuses.table[:sorcerer][716] = {
        "additional charges"     => {
          :description     => "+1 charge per seed 9 threshold (base 5 charges)",
          :chart           => summation_chart(9),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "charges",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "reactive attack chance" => {
          :description     => "+2% reactive attack chance per seed 9 threshold (base 25%)",
          :chart           => summation_chart(9),
          :bonus_amount    => 2,
          :bonus_type      => :percent,
          :bonus_to        => "reactive attack chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "spread chance"          => {
          :description     => "+1% spread chance per seed 1 threshold",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "spread chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 718 - Torment
      # https://gswiki.play.net/Torment_(718)
      #
      # Sorcerous Lore, Demonology: At 25 ranks, unlocks Quickened Misery buff
      # Cast RT -1s per curse/DoT on target (min 1s)
      # Mana cost -25% per curse/DoT (max 50% reduction)
      #
      SpellBonuses.table[:sorcerer][718] = {
        "enable Quickened Misery" => {
          :description     => "25 ranks unlocks Quickened Misery (-1s RT, -25% mana per affliction)",
          :chart           => flat_chart(25),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "Quickened Misery",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 719 - Dark Catalyst
      # https://gswiki.play.net/Dark_Catalyst_(719)
      #
      # Elemental Lores (Fire/Water/Earth/Air) each affect their corresponding damage cycle
      # Crit rank increase: +1 at 12 ranks, +2 at 50 ranks, +3 at 100 ranks
      # Uses polynomial equation, NOT summation chart
      # Flat modifier unaffected by warding margin
      #
      SpellBonuses.table[:sorcerer][719] = {
        "fire crit increase"      => {
          :description     => "+1 fire crit rank at 12/+2 at 50/+3 at 100 lore ranks",
          :chart           => fixed_spacing_chart([12, 50, 100]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "fire crit rank",
          :bonus_max       => 3,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "ice crit increase"       => {
          :description     => "+1 ice crit rank at 12/+2 at 50/+3 at 100 lore ranks",
          :chart           => fixed_spacing_chart([12, 50, 100]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "ice crit rank",
          :bonus_max       => 3,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "lightning crit increase" => {
          :description     => "+1 lightning crit rank at 12/+2 at 50/+3 at 100 lore ranks",
          :chart           => fixed_spacing_chart([12, 50, 100]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "lightning crit rank",
          :bonus_max       => 3,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "impact crit increase"    => {
          :description     => "+1 impact crit rank at 12/+2 at 50/+3 at 100 lore ranks",
          :chart           => fixed_spacing_chart([12, 50, 100]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "impact crit rank",
          :bonus_max       => 3,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 720 - Implosion
      # https://gswiki.play.net/Implosion_(720)
      #
      # Sorcerous Lore, Demonology provides two benefits:
      # 1. Vaporization chance: seed 1 summation of ((ranks - 10) / 2)
      # 2. Voidweaver buff: +1 stack at 90 ranks, +1 at 180 ranks
      #
      SpellBonuses.table[:sorcerer][720] = {
        "vaporization chance"    => {
          :description     => "% chance for instant death via vaporization (complex formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :percent,
          :bonus_to        => "vaporization chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "Voidweaver buff stacks" => {
          :description     => "+1 Voidweaver stack at 90 ranks, +1 at 180 ranks",
          :chart           => fixed_spacing_chart([90, 180]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "Voidweaver stacks",
          :bonus_max       => 2,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 725 - Minor Summoning
      # https://gswiki.play.net/Minor_Summoning_(725)
      #
      # Sorcerous Lore, Demonology provides multiple benefits:
      # 1. +1% summoning success rate per rank
      # 2. Increases demon silver/mana capacity (formula NS)
      # 3. Improves sanctuary interference/breaking (formula NS)
      #
      SpellBonuses.table[:sorcerer][725] = {
        "summoning success rate"  => {
          :description     => "+1% summoning success rate per rank",
          :chart           => divide_truncate_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "success rate",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "demon capacity increase" => {
          :description     => "increases demon silver/mana capacity (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "demon capacity",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "sanctuary interference"  => {
          :description     => "improves sanctuary interference/breaking capability (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "sanctuary interference",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 730 - Animate Dead
      # https://gswiki.play.net/Animate_Dead_(730)
      #
      # Sorcerous Lore, Necromancy provides three benefits:
      # 1. MAL increase: ranks ÷ 10
      # 2. Explosion targets: 2 + (ranks ÷ 20)
      # 3. Increases explosion hit chance (formula NS)
      #
      # Elemental Lores affect explosion damage for attuned element (formula NS)
      #
      SpellBonuses.table[:sorcerer][730] = {
        "MAL increase"                        => {
          :description     => "+1 Maximum Animatable Level per 10 ranks",
          :chart           => divide_truncate_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "MAL",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "explosion targets"                   => {
          :description     => "+1 explosion target per 20 ranks (base 2)",
          :chart           => divide_truncate_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "explosion targets",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "explosion hit chance"                => {
          :description     => "increases explosion hit chance (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :percent,
          :bonus_to        => "explosion hit chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "elemental attunement damage (fire)"  => {
          :description     => "increases explosion damage for fire attunement (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "fire explosion damage",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "elemental attunement damage (water)" => {
          :description     => "increases explosion damage for water attunement (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "water explosion damage",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "elemental attunement damage (air)"   => {
          :description     => "increases explosion damage for air attunement (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "air explosion damage",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "elemental attunement damage (earth)" => {
          :description     => "increases explosion damage for earth attunement (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "earth explosion damage",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 735 - Ensorcell
      # https://gswiki.play.net/Ensorcell_(735)
      #
      # Sorcerous Lore, Necromancy: Retain flare bonus for additional attacks
      # 90 ranks: +1 attack
      # 180 ranks: +2 attacks
      #
      SpellBonuses.table[:sorcerer][735] = {
        "retain flare bonus" => {
          :description     => "retain flare bonus for +1 attack at 90 ranks, +2 at 180 ranks",
          :chart           => fixed_spacing_chart([90, 180]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "additional flare attacks",
          :bonus_max       => 2,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_necromancy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 740 - Planar Shift
      # https://gswiki.play.net/Planar_Shift_(740)
      #
      # Sorcerous Lore, Demonology provides multiple benefits:
      # 1. Reduces failure rate (formula NS)
      # 2. +1 passenger per 20 ranks (max 10 at 200 ranks)
      # 3. 40 ranks: INCANT function unlocked (gold ring)
      # 4. 75 ranks: cross-realm with low-quality chalk + passengers
      #
      SpellBonuses.table[:sorcerer][740] = {
        "failure rate reduction"        => {
          :description     => "reduces failure rate (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :percent,
          :bonus_to        => "failure reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "additional passengers"         => {
          :description     => "+1 grouped passenger per 20 ranks (max 10 at 200 ranks)",
          :chart           => divide_truncate_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "passengers",
          :bonus_max       => 10,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable INCANT function"        => {
          :description     => "40 ranks unlocks INCANT function (gold ring teleportation)",
          :chart           => flat_chart(40),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "INCANT function",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable cross-realm with chalk" => {
          :description     => "75 ranks enables cross-realm travel with low-quality chalk + passengers",
          :chart           => flat_chart(75),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "cross-realm chalk",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :sorcerous_lore_demonology,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }
    end
  end
end
