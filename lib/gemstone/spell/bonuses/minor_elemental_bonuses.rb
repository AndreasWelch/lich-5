# frozen_string_literal: true

#
# Minor Elemental (400s) Spell Bonuses
#
# This file defines skill/lore/stat-based bonuses for the Minor Elemental spell circle.
# All bonus calculations use chart functions from Lich::Util::ChartCalculator.
#
# Reference: https://gswiki.play.net/Minor_Elemental
# Last Updated: December 28, 2025
#

module Lich
  module Gemstone
    module Spell
      include Lich::Util::ChartCalculator

      SpellBonuses.table[:minor_elemental] = {}

      #
      # Spell 402 - Presence
      # https://gswiki.play.net/Presence_(402)
      #
      # Elemental Lore, Air: Chance to point out hidden targets
      # Formula highly favors the hider (formula not specified)
      #
      SpellBonuses.table[:minor_elemental][402] = {
        "hidden target detection" => {
          :description     => "Chance to point out hidden targets (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :ability,
          :bonus_to        => "hidden detection",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 403 - Lock Pick Enhancement
      # https://gswiki.play.net/Lock_Pick_Enhancement_(403)
      #
      # Elemental Lore, Water: -1 pick damage per seed 10 summation threshold
      # Can completely remove potential damage but won't fix previous damage
      #
      SpellBonuses.table[:minor_elemental][403] = {
        "pick damage reduction" => {
          :description     => "-1 potential pick damage per seed 10 threshold",
          :chart           => summation_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "pick damage reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 404 - Disarm Enhancement
      # https://gswiki.play.net/Disarm_Enhancement_(404)
      #
      # Elemental Lore, Water: Phantom ranks for trap safety at seed 1 rate
      #
      SpellBonuses.table[:minor_elemental][404] = {
        "trap safety phantom ranks" => {
          :description     => "+1 phantom rank per seed 1 threshold for trap safety",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :ranks,
          :bonus_to        => "trap safety",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 405 - Elemental Detection
      # https://gswiki.play.net/Elemental_Detection_(405)
      #
      # Elemental Lore, Air: At 30 ranks, detect flares and enhancives
      #
      SpellBonuses.table[:minor_elemental][405] = {
        "flare and enhancive detection" => {
          :description     => "At 30 ranks, detect elemental flares and enhancive status",
          :chart           => flat_chart(30),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "flare/enhancive detection",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 407 - Unlock
      # https://gswiki.play.net/Unlock_(407)
      #
      # Elemental Lore, Water: Corrodes lock on unsuccessful casts
      # Seed 1 summation, max 10% reduction, 60 second duration, cumulative
      #
      SpellBonuses.table[:minor_elemental][407] = {
        "lock corrosion" => {
          :description     => "Corrodes lock per seed 1 threshold (max 10%, 60s, cumulative)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "lock difficulty reduction",
          :bonus_max       => 10,
          :duration        => 60,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 408 - Disarm
      # https://gswiki.play.net/Disarm_(408)
      #
      # Elemental Lore, Water: Corrodes trap on unsuccessful casts
      # Seed 1 summation, max 10% reduction, 60 second duration, cumulative
      #
      SpellBonuses.table[:minor_elemental][408] = {
        "trap corrosion" => {
          :description     => "Corrodes trap per seed 1 threshold (max 10%, 60s, cumulative)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "trap difficulty reduction",
          :bonus_max       => 10,
          :duration        => 60,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 410 - Elemental Wave
      # https://gswiki.play.net/Elemental_Wave_(410)
      #
      # Elemental Lore, Air: 50 ranks transforms to spherical wave (affects flying)
      # Elemental Lore, Water: Reduces maneuver defense (formula NS)
      #
      SpellBonuses.table[:minor_elemental][410] = {
        "affect flying targets"   => {
          :description     => "At 50 ranks, spherical wave can affect flying targets",
          :chart           => flat_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "flying target",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "reduce maneuver defense" => {
          :description     => "Reduces target maneuver defense (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "maneuver defense reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 411 - Elemental Blade
      # https://gswiki.play.net/Elemental_Blade_(411)
      #
      # All Elemental Lores: Allows casting on enchanted weapons
      # Seed 3 summation determines max enchant (+1 per threshold)
      # Uses HIGHEST of any elemental lore
      # Examples: +5 = 25 ranks, +12 = 102 ranks, +20 = 250 ranks
      #
      SpellBonuses.table[:minor_elemental][411] = {
        "enchanted weapon threshold" => {
          :description     => "Max enchant for e-blade per seed 3 threshold (uses highest lore)",
          :chart           => summation_chart(3),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "max enchant",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => -> { [Skills.elair, Skills.elearth, Skills.elfire, Skills.elwater].max },
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 412 - Weapon Deflection
      # https://gswiki.play.net/Weapon_Deflection_(412)
      #
      # Elemental Lore, Earth: +1 additional target per 20 ranks (open cast)
      #
      SpellBonuses.table[:minor_elemental][412] = {
        "additional targets" => {
          :description     => "+1 additional target per 20 ranks for open cast",
          :chart           => divide_truncate_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "targets",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 413 - Elemental Saturation
      # https://gswiki.play.net/Elemental_Saturation_(413)
      #
      # Elemental Lore, Fire: +1 TD penalty per seed 5 threshold (base -25)
      #
      SpellBonuses.table[:minor_elemental][413] = {
        "TD penalty increase" => {
          :description     => "+1 TD penalty per seed 5 threshold (base -25)",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "TD penalty",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 414 - Elemental Defense III
      # https://gswiki.play.net/Elemental_Defense_III_(414)
      #
      # Elemental Lore, Earth: 5% barrier chance at 25 ranks, +1% per 20 additional
      # Requires all 3 ED spells active and knowledge to cast all
      # Reduced by 1% per 5 levels attacker is above caster
      #
      SpellBonuses.table[:minor_elemental][414] = {
        "magical barrier chance" => {
          :description     => "5% at 25 ranks, +1% per 20 ranks (deflects physical attack)",
          :chart           => base_plus_per_ranks_chart(25, 5, 20, 1),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "barrier deflection chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 415 - Elemental Strike
      # https://gswiki.play.net/Elemental_Strike_(415)
      #
      # Elemental Lore, Fire: Chance for 2nd strike on random opponent (+5 mana)
      # Formula: % chance = trunc(Fire Lore skill bonus / 2)
      # Uses skill BONUS, not ranks
      #
      SpellBonuses.table[:minor_elemental][415] = {
        "second strike chance" => {
          :description     => "% chance for 2nd strike = skill bonus / 2 (+5 mana cost)",
          :chart           => divide_truncate_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "second strike chance",
          :bonus_max       => 100,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 416 - Piercing Gaze
      # https://gswiki.play.net/Piercing_Gaze_(416)
      #
      # Elemental Lore, Water: Chance to show Unlock/Disarm success messaging
      # Formula: % chance = skill / 4
      # Uses skill BONUS, not ranks
      #
      SpellBonuses.table[:minor_elemental][416] = {
        "success messaging chance" => {
          :description     => "% chance for success messaging = skill bonus / 4",
          :chart           => divide_truncate_chart(4),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "success messaging",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 417 - Elemental Dispel
      # https://gswiki.play.net/Elemental_Dispel_(417)
      #
      # Elemental Lore, Fire provides two bonuses:
      # 1. Strip defensive spell: 10% at 10 ranks, +3% per 10 additional ranks
      # 2. Additional mana drain: skill bonus / 15
      #
      SpellBonuses.table[:minor_elemental][417] = {
        "strip defensive spell" => {
          :description     => "10% at 10 ranks, +3% per 10 ranks to strip a defensive spell",
          :chart           => base_plus_per_ranks_chart(10, 10, 10, 3),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "strip spell chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "additional mana drain" => {
          :description     => "Additional mana drained = skill bonus / 15",
          :chart           => divide_truncate_chart(15),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "mana drain",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 418 - Mana Focus
      # https://gswiki.play.net/Mana_Focus_(418)
      #
      # Elemental Lore, Water: +10 mana regen bonus duration in pulses
      # Seed 10 summation, caster only, persists after leaving noded room
      #
      SpellBonuses.table[:minor_elemental][418] = {
        "mana regen duration" => {
          :description     => "+10 mana regen duration pulses per seed 10 threshold",
          :chart           => summation_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "mana regen pulses",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 425 - Elemental Targeting
      # https://gswiki.play.net/Elemental_Targeting_(425)
      #
      # Elemental Lore, Fire: Chance for critical weighting on next spell
      # Seed 10 summation, must be attuned, only attuned attacks benefit
      #
      SpellBonuses.table[:minor_elemental][425] = {
        "critical weighting chance" => {
          :description     => "% chance for critical weighting per seed 10 threshold",
          :chart           => summation_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "critical weighting chance",
          :bonus_max       => 0,
          :duration        => 30,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 430 - Elemental Barrier
      # https://gswiki.play.net/Elemental_Barrier_(430)
      #
      # Elemental Lore, Earth: % chance for +10 critical padding (one attack)
      # Seed 10 summation
      #
      SpellBonuses.table[:minor_elemental][430] = {
        "critical padding chance" => {
          :description     => "% chance for +10 critical padding per seed 10 threshold",
          :chart           => summation_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "critical padding chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 435 - Major Elemental Wave
      # https://gswiki.play.net/Major_Elemental_Wave_(435)
      #
      # Elemental Lore, Air: 50 ranks transforms to spherical wave (affects flying)
      # Elemental Lore, Water: Reduces maneuver defense (formula NS)
      #
      SpellBonuses.table[:minor_elemental][435] = {
        "affect flying targets"   => {
          :description     => "At 50 ranks, spherical wave can affect flying targets",
          :chart           => flat_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "flying target",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "reduce maneuver defense" => {
          :description     => "Reduces target maneuver defense (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "maneuver defense reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }
    end
  end
end
