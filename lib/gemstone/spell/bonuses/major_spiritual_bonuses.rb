#
# Major Spiritual (200s) Spell Bonuses
#
# This file defines skill/lore/stat-based bonuses for the Major Spiritual spell circle.
# All bonus calculations use chart functions from Lich::Util::ChartCalculator.
#
# Reference: https://gswiki.play.net/Major_Spiritual
# Last Updated: December 28, 2025
#

module Lich
  module Gemstone
    module Spell
      include Lich::Util::ChartCalculator

      SpellBonuses.table[:major_spiritual] = {}

      #
      # Spell 203 - Manna
      # https://gswiki.play.net/Manna_(203)
      #
      # Spiritual Lore, Blessings: +5 max mana per seed 10 summation threshold (cap +50)
      #
      SpellBonuses.table[:major_spiritual][203] = {
        "max mana bonus" => {
          :description     => "+5 max mana per seed 10 threshold when consuming manna bread (cap +50)",
          :chart           => summation_chart(10),
          :bonus_amount    => 5,
          :bonus_type      => :units,
          :bonus_to        => "max mana",
          :bonus_max       => 50,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 206 - Tend Lore
      # https://gswiki.play.net/Tend_Lore_(206)
      #
      # Spiritual Lore, Blessings: +1 First Aid rank per seed 2 summation threshold
      #
      SpellBonuses.table[:major_spiritual][206] = {
        "First Aid bonus" => {
          :description     => "+1 First Aid rank per seed 2 threshold (in addition to base +20)",
          :chart           => summation_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :ranks,
          :bonus_to        => "First Aid",
          :bonus_max       => 0,
          :duration        => 60,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 209 - Untrammel
      # https://gswiki.play.net/Untrammel_(209)
      #
      # Spiritual Lore, Blessings: At 10 ranks, unlocks persistent web ward effect
      #
      SpellBonuses.table[:major_spiritual][209] = {
        "persistent web ward" => {
          :description     => "10 ranks unlocks persistent effect: second chance to ward web",
          :chart           => flat_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "web ward",
          :bonus_max       => 0,
          :duration        => 600,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 210 - Silence
      # https://gswiki.play.net/Silence_(210)
      #
      # Spiritual Lore, Summoning: +1 target per 20 ranks for open cast version
      #
      SpellBonuses.table[:major_spiritual][210] = {
        "additional targets" => {
          :description     => "+1 target per 20 ranks for open cast version",
          :chart           => divide_truncate_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "targets",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 211 - Bravery
      # https://gswiki.play.net/Bravery_(211)
      #
      # Spiritual Lore, Blessings: At 25 ranks, unlocks group version via EVOKE
      #
      SpellBonuses.table[:major_spiritual][211] = {
        "enable group version" => {
          :description     => "25 ranks unlocks group version via EVOKE (60s duration, 180s cooldown)",
          :chart           => flat_chart(25),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "group cast",
          :bonus_max       => 0,
          :duration        => 60,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 212 - Interference
      # https://gswiki.play.net/Interference_(212)
      #
      # Spiritual Lore, Summoning: +1 TD penalty per seed 5 summation threshold
      #
      SpellBonuses.table[:major_spiritual][212] = {
        "TD penalty increase" => {
          :description     => "+1 TD penalty per seed 5 threshold (base -15)",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "TD penalty",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 213 - Minor Sanctuary
      # https://gswiki.play.net/Minor_Sanctuary_(213)
      #
      # Spiritual Lore, Summoning: Increases effectiveness (formula not specified)
      #
      SpellBonuses.table[:major_spiritual][213] = {
        "increased effectiveness" => {
          :description     => "increases effectiveness in creating a sanctuary (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "effectiveness",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "reduce failure chance"   => {
          :description     => "reduces failure chance from hostile creatures (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "effectiveness",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 215 - Heroism
      # https://gswiki.play.net/Heroism_(215)
      #
      # Spiritual Lore, Blessings provides two bonuses:
      # 1. At 35 ranks, unlocks group version via EVOKE
      # 2. +1 AS per 10 ranks (self-cast only)
      #
      SpellBonuses.table[:major_spiritual][215] = {
        "enable group version"     => {
          :description     => "35 ranks unlocks group version via EVOKE (60s duration, 180s cooldown)",
          :chart           => flat_chart(35),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "group cast",
          :bonus_max       => 0,
          :duration        => 60,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "attack strength increase" => {
          :description     => "+1 AS per 10 ranks (self-cast only, +1 MP per +3 AS)",
          :chart           => divide_truncate_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "attack strength",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 216 - Frenzy
      # https://gswiki.play.net/Frenzy_(216)
      #
      # Spiritual Lore, Summoning: +1 TD penalty per seed 1 summation threshold
      #
      SpellBonuses.table[:major_spiritual][216] = {
        "TD pushdown" => {
          :description     => "+1 TD penalty per seed 1 threshold (base -30)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "TD penalty",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 217 - Mass Interference
      # https://gswiki.play.net/Mass_Interference_(217)
      #
      # Spiritual Lore, Summoning: +1 TD penalty per seed 5 summation threshold
      # Spiritual Mana Control: +1 target per 50 skill bonus (base 3 targets)
      #
      SpellBonuses.table[:major_spiritual][217] = {
        "TD penalty increase" => {
          :description     => "+1 TD penalty per seed 5 threshold (base -15)",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "TD penalty",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "additional targets"  => {
          :description     => "+1 target per 50 SMC skill bonus (base 3 targets)",
          :chart           => divide_truncate_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "targets",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_mana_control,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 218 - Spirit Servant
      # https://gswiki.play.net/Spirit_Servant_(218)
      #
      # Spiritual Lore, Summoning: Increases preservation duration on caster's corpse
      # Ranks 1-100: +15 seconds per rank
      # Ranks 101-202: +10 seconds per rank
      #
      SpellBonuses.table[:major_spiritual][218] = {
        "preservation duration 1-100" => {
          :description     => "+15s preservation duration per rank (ranks 1-100)",
          :chart           => per_x_ranks_chart(1, 0, 100),
          :bonus_amount    => 15,
          :bonus_type      => :time,
          :bonus_to        => "preservation duration",
          :bonus_max       => 1500,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "preservation duration 101+"  => {
          :description     => "+10s preservation duration per rank (ranks 101+)",
          :chart           => per_x_ranks_chart(1, 101, 202),
          :bonus_amount    => 10,
          :bonus_type      => :time,
          :bonus_to        => "preservation duration",
          :bonus_max       => 1010,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 219 - Spell Shield
      # https://gswiki.play.net/Spell_Shield_(219)
      #
      # Spiritual Lore, Blessings: At 50 ranks, unlocks group version via EVOKE
      #
      SpellBonuses.table[:major_spiritual][219] = {
        "enable group version" => {
          :description     => "50 ranks unlocks group version via EVOKE (120s duration, 360s cooldown)",
          :chart           => flat_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "group cast",
          :bonus_max       => 0,
          :duration        => 120,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 225 - Transference
      # https://gswiki.play.net/Transference_(225)
      #
      # Spiritual Lore, Blessings: -1% interception chance per 2 ranks over 75 (min 5%)
      # Note: Only applies when NOT wearing a gold ring
      #
      SpellBonuses.table[:major_spiritual][225] = {
        "interception reduction" => {
          :description     => "-1% interception chance per 2 ranks over 75 (min 5%, no gold ring)",
          :chart           => per_x_ranks_chart(2, 75, 225),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "interception reduction",
          :bonus_max       => 75,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 240 - Spirit Slayer
      # https://gswiki.play.net/Spirit_Slayer_(240)
      #
      # Spiritual Lore, Summoning: +2% first recast chance per seed 1 summation threshold
      # Base: 60%, Max: 100% at 210 ranks with enhancives
      #
      SpellBonuses.table[:major_spiritual][240] = {
        "recast chance" => {
          :description     => "+2% first recast chance per seed 1 threshold (base 60%, max 100%)",
          :chart           => summation_chart(1),
          :bonus_amount    => 2,
          :bonus_type      => :percent,
          :bonus_to        => "first recast chance",
          :bonus_max       => 40,
          :duration        => 30,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }
    end
  end
end
