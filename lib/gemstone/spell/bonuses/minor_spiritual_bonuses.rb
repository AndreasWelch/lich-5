#
# Minor Spiritual (100s) Spell Bonuses
#
# This file defines skill/lore/stat-based bonuses for the Minor Spiritual spell circle.
# All bonus calculations use chart functions from Lich::Util::ChartCalculator.
#
# Reference: https://gswiki.play.net/Minor_Spiritual
# Last Updated: December 28, 2025
#

module Lich
  module Gemstone
    module Spell
      include Lich::Util::ChartCalculator

      SpellBonuses.table[:minor_spiritual] = {}

      #
      # Spell 102 - Spirit Barrier
      # https://gswiki.play.net/Spirit_Barrier_(102)
      #
      # Spell rank bonus: +1 DS/UDF per 2 Minor Spiritual ranks over 102, capped at level
      #
      SpellBonuses.table[:minor_spiritual][102] = {
        "spell rank DS bonus" => {
          :description     => "+1 DS/UDF per 2 Minor Spiritual ranks over 102, capped at level",
          :chart           => per_x_ranks_chart(2, 102, 999),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "DS/UDF",
          :bonus_max       => -> { Char.level },
          :duration        => 0,
          :skill_used      => :minor_spiritual,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 104 - Disease Resistance
      # https://gswiki.play.net/Disease_Resistance_(104)
      #
      # Spiritual Lore, Blessings: +2 resistance per seed 1 summation threshold
      #
      SpellBonuses.table[:minor_spiritual][104] = {
        "increased disease resistance" => {
          :description     => "+2 disease resistance per Spiritual Lore, Blessings threshold",
          :chart           => summation_chart(1),
          :bonus_amount    => 2,
          :bonus_type      => :units,
          :bonus_to        => "disease resistance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 105 - Poison Resistance
      # https://gswiki.play.net/Poison_Resistance_(105)
      #
      # Spiritual Lore, Blessings: +2 resistance per seed 1 summation threshold
      #
      SpellBonuses.table[:minor_spiritual][105] = {
        "increased poison resistance" => {
          :description     => "+2 poison resistance per Spiritual Lore, Blessings threshold",
          :chart           => summation_chart(1),
          :bonus_amount    => 2,
          :bonus_type      => :units,
          :bonus_to        => "poison resistance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 106 - Spirit Fog
      # https://gswiki.play.net/Spirit_Fog_(106)
      #
      # Spiritual Lore, Summoning: At 40 ranks, enables 30 second concealment form
      #
      SpellBonuses.table[:minor_spiritual][106] = {
        "enable concealing fog" => {
          :description     => "At 40 ranks, fog provides 30 seconds of concealment",
          :chart           => flat_chart(40),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "concealment",
          :bonus_max       => 0,
          :duration        => 30,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 107 - Spirit Warding II
      # https://gswiki.play.net/Spirit_Warding_II_(107)
      #
      # Spiritual Lore, Blessings: 1% chance per seed 10 threshold for +25 TD boost (max 12%)
      # Thresholds: 10→1%, 21→2%, 33→3%, 46→4%, 60→5%, 75→6%, 91→7%, 108→8%, 126→9%, 145→10%, 165→11%, 186→12%
      #
      SpellBonuses.table[:minor_spiritual][107] = {
        "temporary TD boost chance" => {
          :description     => "1% chance per threshold for +25 TD boost on warding attack",
          :chart           => summation_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "TD boost chance",
          :bonus_max       => 12,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 110 - Unbalance
      # https://gswiki.play.net/Unbalance_(110)
      #
      # Spiritual Lore, Summoning: Chance to affect second target
      # Formula: % chance = trunc(Spiritual Lore Summoning skill bonus / 2)
      # Note: Uses skill BONUS, not ranks - hence :bonus_used instead of :skill_used
      # Table: 4 ranks→10%, 8→20%, 13→30%, 18→40%, 24→50%, 30→60%, 40→70%, 60→80%, 80→90%, 100→100%
      #
      SpellBonuses.table[:minor_spiritual][110] = {
        "second target chance" => {
          :description     => "Chance to affect a second target based on skill bonus",
          :chart           => divide_truncate_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "second target chance",
          :bonus_max       => 100,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 111 - Fire Spirit
      # https://gswiki.play.net/Fire_Spirit_(111)
      #
      # Spiritual Lore, Summoning provides two bonuses:
      # 1. Damage factor increase (tiered progression)
      # 2. Additional splash targets (ball spell progression)
      #
      SpellBonuses.table[:minor_spiritual][111] = {
        "increased damage factor"   => {
          :description     => "+0.001 DF per rank (tiered: full 1-50, half 51-100, quarter 101-200)",
          :chart           => damage_factor_chart(1),
          :bonus_amount    => 0.001,
          :bonus_type      => :units,
          :bonus_to        => "damage factor",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "additional splash targets" => {
          :description     => "Additional splash targets per ball spell progression",
          :chart           => ball_spell_chart(),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "splash targets",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 115 - Fasthr's Reward
      # https://gswiki.play.net/Fasthr%27s_Reward_(115)
      #
      # Spiritual Lore, Blessings: +1% activation chance per seed 1 summation threshold
      #
      SpellBonuses.table[:minor_spiritual][115] = {
        "increased activation chance" => {
          :description     => "+1% activation chance per Spiritual Lore, Blessings threshold",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "activation chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 116 - Locate Person
      # https://gswiki.play.net/Locate_Person_(116)
      #
      # Spiritual Lore, Summoning provides four threshold-based abilities:
      # - 30 ranks: Adjacent realm range + trace back ability
      # - 60 ranks: Near-adjacent realm range
      # - 90 ranks: Far realms range
      #
      SpellBonuses.table[:minor_spiritual][116] = {
        "enable adjacent realm range"      => {
          :description     => "At 30 ranks, locate targets in adjacent realms",
          :chart           => flat_chart(30),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "adjacent realm",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable trace back"                => {
          :description     => "At 30 ranks, enables trace back to caster",
          :chart           => flat_chart(30),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "trace back",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable near-adjacent realm range" => {
          :description     => "At 60 ranks, locate targets in near-adjacent realms",
          :chart           => flat_chart(60),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "near-adjacent realm",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable far realms range"          => {
          :description     => "At 90 ranks, locate targets in far realms",
          :chart           => flat_chart(90),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "far realms",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 117 - Spirit Strike
      # https://gswiki.play.net/Spirit_Strike_(117)
      #
      # Spiritual Lore, Blessings: 3% chance per seed 5 threshold to remain active
      # Chance halves with each subsequent attack (repeat_modifier: -50)
      # Thresholds: 5→3%, 11→6%, 18→9%, 26→12%, 35→15%, 45→18%, 56→21%...
      #
      SpellBonuses.table[:minor_spiritual][117] = {
        "chance to remain active" => {
          :description     => "3% chance per threshold to remain active for additional attack",
          :chart           => summation_chart(5),
          :bonus_amount    => 3,
          :bonus_type      => :percent,
          :bonus_to        => "remain active chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => -50
        }
      }

      #
      # Spell 118 - Web
      # https://gswiki.play.net/Web_(118)
      #
      # Spiritual Lore, Summoning provides four bonuses:
      # 1. At 20 ranks: Enables bolt version
      # 2. Area snare charges at thresholds: 5→3, 15→4, 30→5, 50→6, 75→7, 105→8, 140→9, 180→10
      # 3. Bolt webbed condition chance: +1% per 2 ranks (base 40%, max 100% at 140 ranks)
      # 4. Bolt damage factor (tiered progression)
      #
      SpellBonuses.table[:minor_spiritual][118] = {
        "enable bolt version"          => {
          :description     => "At 20 ranks, unlocks bolt version of Web",
          :chart           => flat_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "bolt version",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "area snare charges"           => {
          :description     => "Additional snare charges at lore thresholds (base 2)",
          :chart           => fixed_spacing_chart([5, 15, 30, 50, 75, 105, 140, 180]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "snare charges",
          :bonus_max       => 8,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "bolt webbed condition chance" => {
          :description     => "+1% webbed condition chance per 2 ranks (base 40%)",
          :chart           => divide_truncate_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "webbed condition chance",
          :bonus_max       => 60,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "bolt damage factor"           => {
          :description     => "+0.001 DF per rank (tiered progression)",
          :chart           => damage_factor_chart(1),
          :bonus_amount    => 0.001,
          :bonus_type      => :units,
          :bonus_to        => "damage factor",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 120 - Lesser Shroud
      # https://gswiki.play.net/Lesser_Shroud_(120)
      #
      # Spiritual Lore, Blessings: At 60 ranks, enables casting on others (2 min duration)
      #
      SpellBonuses.table[:minor_spiritual][120] = {
        "enable other-cast" => {
          :description     => "At 60 ranks, can cast on others with 2 minute duration",
          :chart           => flat_chart(60),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "other-cast",
          :bonus_max       => 0,
          :duration        => 120,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 125 - Call Lightning
      # https://gswiki.play.net/Call_Lightning_(125)
      #
      # Spiritual Lore, Summoning provides three bonuses:
      # 1. Rangers with 625: Indoor casting at 40 ranks
      # 2. Everyone: Indoor casting at 80 ranks
      # 3. Buildup time reduction: -4 sec per threshold (10, 20, 30, 40, 50, 60, 70)
      #
      SpellBonuses.table[:minor_spiritual][125] = {
        "enable indoor casting (ranger with 625)" => {
          :description     => "At 40 ranks, Rangers with 625 can cast indoors",
          :chart           => flat_chart(40),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "indoor casting",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable indoor casting (everyone)"        => {
          :description     => "At 80 ranks, anyone can cast indoors",
          :chart           => flat_chart(80),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "indoor casting",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "reduce buildup time"                     => {
          :description     => "-4 seconds buildup time per threshold (base 36 sec)",
          :chart           => fixed_spacing_chart([10, 20, 30, 40, 50, 60, 70]),
          :bonus_amount    => -4,
          :bonus_type      => :time,
          :bonus_to        => "buildup time",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 130 - Spirit Guide
      # https://gswiki.play.net/Spirit_Guide_(130)
      #
      # Spiritual Lore, Summoning: Decreases landing location variance
      # Formula: seed 10 summation / 2
      # Thresholds: 21→-1, 46→-2, 75→-3, 108→-4, 145→-5
      #
      SpellBonuses.table[:minor_spiritual][130] = {
        "decrease landing variance" => {
          :description     => "Reduces landing location variance (seed 10 / 2)",
          :chart           => divide_truncate_chart_from(summation_chart(10), 2), # TODO:  Check if this if truncate is applicable here or if it's just a 10/2
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "landing variance reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }
    end
  end
end
