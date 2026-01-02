# frozen_string_literal: true

#
# Bard Base (1000s) Spell Bonuses
#
# This file defines skill/lore/stat-based bonuses for the Bard Base spell circle.
# All bonus calculations use chart functions from Lich::Util::ChartCalculator.
#
# Bards use three primary lores:
# - Mental Lore, Telepathy - Physical bard focus, song duration, AS bonuses
# - Mental Lore, Manipulation - Pure/caster bard focus, gem purification, sonic disruption
# - Elemental Lore, Air - Sonic equipment benefits, Song of Tonis enhancements
#
# Note: All renewable songs gain +2 seconds duration per rank of Mental Lore, Telepathy.
# This universal benefit is not tracked per-spell but is inherent to the spellsong system.
#
# Reference: https://gswiki.play.net/Bard_Base
# Last Updated: January 1, 2026
#

module Lich
  module Gemstone
    module Spell
      include Lich::Util::ChartCalculator

      SpellBonuses.table[:bard] = {}

      #
      # Spell 1002 - Vibration Chant
      # https://gswiki.play.net/Vibration_Chant_(1002)
      #
      # Mental Lore, Manipulation: Reduces minimum endroll threshold to shatter items
      # Base reduction: 2, with diminishing returns per rank tier
      # Ranks 1-5: +1.2 per rank, Ranks 6-10: +0.8 per rank, Ranks 11-15: +0.6 per rank
      #
      SpellBonuses.table[:bard][1002] = {
        "shatter threshold reduction" => {
          :description     => "reduces endroll threshold to shatter items (diminishing returns)",
          :chart           => custom_formula_chart { |ranks|
            base = 2
            bonus = 0.0
            bonus += [ranks, 5].min * 1.2
            bonus += [[ranks - 5, 0].max, 5].min * 0.8 if ranks > 5
            bonus += [[ranks - 10, 0].max, 5].min * 0.6 if ranks > 10
            # Ranks 16+ not specified, assume 0.6 continues
            bonus += [ranks - 15, 0].max * 0.6 if ranks > 15
            (base + bonus).floor
          },
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "shatter threshold reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :mental_lore_manipulation,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1004 - Purification Song
      # https://gswiki.play.net/Purification_Song_(1004)
      #
      # Mental Lore, Manipulation: Reduces gem shattering failure chance
      # Formula: -3% failure chance per seed 1 summation threshold
      #
      SpellBonuses.table[:bard][1004] = {
        "reduce gem shattering" => {
          :description     => "-3% gem shattering chance per seed 1 threshold",
          :chart           => summation_chart(1),
          :bonus_amount    => 3,
          :bonus_type      => :percent,
          :bonus_to        => "failure reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :mental_lore_manipulation,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1007 - Kai's Triumph Song
      # https://gswiki.play.net/Kai%27s_Triumph_Song_(1007)
      #
      # Mental Lore, Telepathy: Additional AS bonus beyond spell ranks
      # +1 AS per seed 3 summation, capped at +11 at 88 ranks
      # Thresholds: 3→+1, 7→+2, 12→+3, 18→+4, 25→+5, 33→+6, 42→+7, 52→+8, 63→+9, 75→+10, 88→+11
      # Note: This bonus does NOT increase mana cost
      #
      SpellBonuses.table[:bard][1007] = {
        "AS bonus" => {
          :description     => "+1 AS per seed 3 threshold (capped at +11 at 88 ranks)",
          :chart           => summation_chart(3),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "attack strength",
          :bonus_max       => 11,
          :duration        => 0,
          :skill_used      => :mental_lore_telepathy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1008 - Stunning Shout
      # https://gswiki.play.net/Stunning_Shout_(1008)
      #
      # Elemental Lore, Air: +1 HP damage per 3 ranks
      # Formula: 10 base + trunc((endroll-100) × 0.25) + (EL:Air ranks ÷ 3)
      #
      SpellBonuses.table[:bard][1008] = {
        "damage bonus" => {
          :description     => "+1 HP damage per 3 ranks",
          :chart           => divide_truncate_chart(3),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "damage",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1009 - Sonic Shield Song
      # https://gswiki.play.net/Sonic_Shield_Song_(1009)
      #
      # Elemental Lore, Air: Reduces effective shield size for Dodge hindrance
      # -1 size at 20 ranks, -2 at 50 ranks, -3 at 100 ranks
      # At 100 ranks, Tower shield hinders like a Small shield
      #
      SpellBonuses.table[:bard][1009] = {
        "effective size reduction" => {
          :description     => "-1 effective size at 20/50/100 ranks for Dodge hindrance",
          :chart           => fixed_spacing_chart([20, 50, 100]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "size reduction",
          :bonus_max       => 3,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1011 - Song of Peace
      # https://gswiki.play.net/Song_of_Peace_(1011)
      #
      # Mental Lore, Telepathy: Reduces failure chance and increases sanctuary resistance
      # Formula: NS (not specified)
      #
      SpellBonuses.table[:bard][1011] = {
        "sanctuary effectiveness" => {
          :description     => "reduces failure chance and increases resistance to interference (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "sanctuary effectiveness",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :mental_lore_telepathy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1012 - Sonic Weapon Song
      # https://gswiki.play.net/Sonic_Weapon_Song_(1012)
      #
      # Elemental Lore, Air: Chance for secondary flare (independent of primary)
      # 3% chance per seed 3 summation of ranks
      # Second flare has distinct "With a loud snap" messaging
      #
      SpellBonuses.table[:bard][1012] = {
        "secondary flare chance" => {
          :description     => "3% chance for secondary flare per seed 3 threshold",
          :chart           => summation_chart(3),
          :bonus_amount    => 3,
          :bonus_type      => :percent,
          :bonus_to        => "secondary flare chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1014 - Sonic Armor
      # https://gswiki.play.net/Sonic_Armor_(1014)
      #
      # Elemental Lore, Air: Improves heat, cold, and electrical resistances
      # Formula: NS (scales with Bard ranks + Air lore)
      #
      SpellBonuses.table[:bard][1014] = {
        "elemental resistance" => {
          :description     => "improves heat/cold/electrical resistance (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "elemental resistance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1015 - Song of Depression
      # https://gswiki.play.net/Song_of_Depression_(1015)
      #
      # Mental Lore, Telepathy provides two benefits:
      # 1. Additional -1 TD penalty per seed 1 summation threshold
      # 2. Additional +1 RT at thresholds: 10, 25, 45, 75, 100 ranks
      #
      SpellBonuses.table[:bard][1015] = {
        "TD penalty increase" => {
          :description     => "-1 additional TD penalty per seed 1 threshold",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "TD penalty",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :mental_lore_telepathy,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "RT increase"         => {
          :description     => "+1 RT at 10/25/45/75/100 ranks",
          :chart           => fixed_spacing_chart([10, 25, 45, 75, 100]),
          :bonus_amount    => 1,
          :bonus_type      => :time,
          :bonus_to        => "roundtime",
          :bonus_max       => 5,
          :duration        => 0,
          :skill_used      => :mental_lore_telepathy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1016 - Song of Rage
      # https://gswiki.play.net/Song_of_Rage_(1016)
      #
      # Mental Lore, Telepathy: Increases maximum rage level
      # +1 level at 5 ranks, +2 at 15, +3 at 30, +4 at 50
      #
      SpellBonuses.table[:bard][1016] = {
        "max rage level increase" => {
          :description     => "+1 max rage level at 5/15/30/50 ranks",
          :chart           => fixed_spacing_chart([5, 15, 30, 50]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "max rage level",
          :bonus_max       => 4,
          :duration        => 0,
          :skill_used      => :mental_lore_telepathy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1025 - Singing Sword Song
      # https://gswiki.play.net/Singing_Sword_Song_(1025)
      #
      # Mental Lore, Manipulation: Increases AS of manifestation
      # +1 AS per 2 Manipulation ranks
      # Full Formula: Weapon skill + (Bard ranks - 25)/2 + (INF+AURA)/2 + (CMAN/2) + (ML:Manip/2) + MB
      #
      SpellBonuses.table[:bard][1025] = {
        "manifestation AS bonus" => {
          :description     => "+1 AS per 2 Manipulation ranks",
          :chart           => divide_truncate_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "attack strength",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :mental_lore_manipulation,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1030 - Song of Sonic Disruption
      # https://gswiki.play.net/Song_of_Sonic_Disruption_(1030)
      #
      # Mental Lore, Manipulation provides two benefits:
      # 1. +0.6 HP damage per rank (capped at 36 damage at 60 ranks)
      # 2. 15 ranks enables focused (single target) version at half mana cost
      #
      # Additional thresholds for instrument equivalence:
      # - 30 ranks: Non-focused = 1H instrument adept damage
      # - 45 ranks: Focused = 1H instrument adept damage
      # - 60 ranks: Non-focused = 2H instrument adept damage
      # - 75 ranks: Focused = 2H instrument adept damage
      #
      SpellBonuses.table[:bard][1030] = {
        "damage bonus"           => {
          :description     => "+0.6 HP damage per rank (max 36 at 60 ranks)",
          :chart           => divide_truncate_chart(1),
          :bonus_amount    => 0.6,
          :bonus_type      => :units,
          :bonus_to        => "damage",
          :bonus_max       => 36,
          :duration        => 0,
          :skill_used      => :mental_lore_manipulation,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable focused version" => {
          :description     => "15 ranks enables focused version at half mana cost",
          :chart           => flat_chart(15),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "focused version",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :mental_lore_manipulation,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1035 - Song of Tonis
      # https://gswiki.play.net/Song_of_Tonis_(1035)
      #
      # Mental Lore, Telepathy: Duration increase
      # - +1 second per rank for first 20 ranks
      # - +1 second per 2 ranks for ranks 21+
      # - Max: +60 seconds at 100 ranks (total 120 second duration)
      #
      # Elemental Lore, Air provides two benefits:
      # 1. +1 Dodge rank per seed 1 threshold (max +20 at 96 ranks)
      # 2. -1 RT at 30 ranks, -1 more at 75 ranks (total -3 with base -1)
      #
      SpellBonuses.table[:bard][1035] = {
        "duration increase" => {
          :description     => "+1s/rank for 20, then +1s/2 ranks (max +60s at 100 ranks)",
          :chart           => custom_formula_chart { |ranks|
            if ranks <= 20
              ranks
            else
              20 + ((ranks - 20) / 2)
            end
          },
          :bonus_amount    => 1,
          :bonus_type      => :time,
          :bonus_to        => "duration",
          :bonus_max       => 60,
          :duration        => 0,
          :skill_used      => :mental_lore_telepathy,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "Dodge bonus"       => {
          :description     => "+1 Dodge rank per seed 1 threshold (max +20 at 96 ranks)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :ranks,
          :bonus_to        => "Dodge",
          :bonus_max       => 20,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "RT reduction"      => {
          :description     => "-1 RT at 30 ranks, -1 more at 75 ranks",
          :chart           => fixed_spacing_chart([30, 75]),
          :bonus_amount    => 1,
          :bonus_type      => :time,
          :bonus_to        => "RT reduction",
          :bonus_max       => 2,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 1040 - Troubadour's Rally
      # https://gswiki.play.net/Troubadour%27s_Rally_(1040)
      #
      # Mental Lore, Telepathy: Increases effectiveness at removing stuns/immobility/webs
      # Base chance: 90% - 3% per second remaining (minimum 10%)
      # Lore adds to chance per seed 1 summation
      #
      SpellBonuses.table[:bard][1040] = {
        "removal effectiveness" => {
          :description     => "+1% removal chance per seed 1 threshold",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "removal chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :mental_lore_telepathy,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }
    end
  end
end
