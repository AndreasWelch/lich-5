# frozen_string_literal: true

#
# Major Elemental (500s) Spell Bonuses
#
# This file defines skill/lore/stat-based bonuses for the Major Elemental spell circle.
# All bonus calculations use chart functions from Lich::Util::ChartCalculator.
#
# Reference: https://gswiki.play.net/Major_Elemental
# Last Updated: December 28, 2025
#

module Lich
  module Gemstone
    module Spell
      include Lich::Util::ChartCalculator

      SpellBonuses.table[:major_elemental] = {}

      #
      # Spell 501 - Sleep
      # https://gswiki.play.net/Sleep_(501)
      #
      # Elemental Lore, Air: Seed 1 summation % chance for grogginess when target wakes
      # Grogginess effect: -20 AS/DS and +2 second slow, duration 10 seconds
      #
      SpellBonuses.table[:major_elemental][501] = {
        "grogginess chance" => {
          :description     => "seed 1 summation % chance for grogginess when target wakes (-20 AS/DS, +2s slow)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "grogginess chance",
          :bonus_max       => 0,
          :duration        => 10,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 504 - Slow
      # https://gswiki.play.net/Slow_(504)
      #
      # Elemental Lore, Air provides three benefits:
      # 1. Additional RT on target at skill bonus thresholds (100/200/300)
      # 2. 20 ranks unlocks open cast version (4 mana)
      # 3. +1 target per 20 ranks for open cast
      #
      SpellBonuses.table[:major_elemental][504] = {
        "additional RT effect" => {
          :description     => "+1 RT at 24 ranks (100 skill), +2 at 100 ranks (200 skill), +3 at 200 ranks (300 skill)",
          :chart           => fixed_spacing_chart([24, 100, 200]),
          :bonus_amount    => 1,
          :bonus_type      => :time,
          :bonus_to        => "target roundtime",
          :bonus_max       => 3,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable open cast"     => {
          :description     => "20 ranks unlocks open cast version (4 mana)",
          :chart           => flat_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "open cast",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "additional targets"   => {
          :description     => "+1 target per 20 ranks for open cast version",
          :chart           => divide_truncate_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "targets",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 505 - Hand of Tonis
      # https://gswiki.play.net/Hand_of_Tonis_(505)
      #
      # Elemental Lore, Air: 20 ranks unlocks Tonis Bolt (unbalance crits) via EVOKE
      #
      SpellBonuses.table[:major_elemental][505] = {
        "enable bolt version" => {
          :description     => "20 ranks unlocks Tonis Bolt (unbalance crits) via EVOKE",
          :chart           => flat_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "bolt version",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 506 - Celerity
      # https://gswiki.play.net/Celerity_(506)
      #
      # Elemental Lore, Air provides three benefits:
      # 1. 50 ranks unlocks group version via EVOKE
      # 2. Stamina cost reduction (formula NS - varies with Air ranks)
      # 3. Utility RT reduction (formula NS - varies with Air ranks)
      #
      SpellBonuses.table[:major_elemental][506] = {
        "enable group version"   => {
          :description     => "50 ranks unlocks group version via EVOKE",
          :chart           => flat_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "group cast",
          :bonus_max       => 0,
          :duration        => 60,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "stamina cost reduction" => {
          :description     => "reduces stamina cost based on Air ranks (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "stamina reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "utility RT reduction"   => {
          :description     => "reduces utility action RT based on Air ranks (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :time,
          :bonus_to        => "utility RT reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 510 - Hurl Boulder
      # https://gswiki.play.net/Hurl_Boulder_(510)
      #
      # Elemental Lore, Earth: Damage factor increase (tiered progression)
      # +.001 DF per rank (1-50), per 2 ranks (51-100), per 4 ranks (101-200)
      #
      SpellBonuses.table[:major_elemental][510] = {
        "damage factor increase" => {
          :description     => "+.001 DF per rank (tiered: full 1-50, half 51-100, quarter 101-200)",
          :chart           => damage_factor_chart(1),
          :bonus_amount    => 0.001,
          :bonus_type      => :units,
          :bonus_to        => "damage factor",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 514 - Stone Fist
      # https://gswiki.play.net/Stone_Fist_(514)
      #
      # Elemental Lore, Earth: Unlocks additional commands at level-based thresholds
      # - SLAP: 0.5x ranks per level requirement
      # - CLENCH: 1.25x ranks per level requirement
      # - POUND: 2x ranks per level requirement
      #
      # Note: Formula is level-dependent (ranks needed = level * multiplier)
      #
      SpellBonuses.table[:major_elemental][514] = {
        "unlock commands" => {
          :description     => "unlocks SLAP (.5x), CLENCH (1.25x), POUND (2x) commands at level-based thresholds",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :ability,
          :bonus_to        => "additional commands",
          :bonus_max       => -> { Char.level },
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 518 - Cone of Elements
      # https://gswiki.play.net/Cone_of_Elements_(518)
      #
      # All Four Elemental Lores: 20 ranks unlocks respective element specification
      # - Fire: Uses Major Fire (908)
      # - Water: Uses Minor Water (903)
      # - Earth: Uses Hurl Boulder (510)
      # - Air: Uses vacuum bolt (unique)
      # - Lightning: Requires 10 Air + 10 Water (combined requirement)
      # - Acid: Requires 10 Earth + 10 Water (combined requirement)
      #
      SpellBonuses.table[:major_elemental][518] = {
        "enable fire specification"      => {
          :description     => "20 ranks unlocks fire specification (uses Major Fire)",
          :chart           => flat_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "fire specification",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable water specification"     => {
          :description     => "20 ranks unlocks water specification (uses Minor Water)",
          :chart           => flat_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "water specification",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable earth specification"     => {
          :description     => "20 ranks unlocks earth specification (uses Hurl Boulder)",
          :chart           => flat_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "earth specification",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable air specification"       => {
          :description     => "20 ranks unlocks air specification (vacuum bolt)",
          :chart           => flat_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "air specification",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable lightning specification" => {
          :description     => "10 Air + 10 Water unlocks lightning specification (uses Major Shock)",
          :chart           => flat_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "lightning specification",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => [:elemental_lore_air, :elemental_lore_water],
          :combine_method  => :all_required,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable acid specification"      => {
          :description     => "10 Earth + 10 Water unlocks acid specification (uses Major Acid)",
          :chart           => flat_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "acid specification",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => [:elemental_lore_earth, :elemental_lore_water],
          :combine_method  => :all_required,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 519 - Immolation
      # https://gswiki.play.net/Immolation_(519)
      #
      # Elemental Lore, Fire provides two benefits:
      # 1. Incineration chance = seed 1 summation of ((ranks - 10) / 2)
      #    Reduced by 2% per warding margin point below 50
      # 2. Extra damage cycle chance = ranks / 1.5 (100% at 150 ranks)
      #
      SpellBonuses.table[:major_elemental][519] = {
        "incineration chance"       => {
          :description     => "instant kill chance = seed 1 of ((ranks - 10) / 2), reduced if WM < 50",
          :chart           => custom_formula_chart { |ranks|
            adjusted = [(ranks - 10) / 2, 0].max
            adjusted > 0 ? summation_bonus(1, adjusted) : 0
          },
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "incineration chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "extra damage cycle chance" => {
          :description     => "chance for extra crit cycle = ranks / 1.5 (100% at 150 ranks)",
          :chart           => divide_truncate_chart(1.5),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "extra cycle chance",
          :bonus_max       => 100,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 520 - Mage Armor
      # https://gswiki.play.net/Mage_Armor_(520)
      #
      # All Four Elemental Lores provide aspect-specific benefits:
      # - Fire: Flare chance + follow-up flare chance
      # - Water: Dispel cooldown reduction
      # - Earth: Critical padding when stunned
      # - Air: Carrying capacity bonus
      # - Lightning: Stun retaliation cooldown (combined Air+Water)
      #
      SpellBonuses.table[:major_elemental][520] = {
        "fire flare chance"             => {
          :description     => "base 5% + seed 6 summation % for fire flare on attack (max 22%)",
          :chart           => summation_chart(6),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "fire flare chance",
          :bonus_max       => 17,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "fire follow-up flare"          => {
          :description     => "+17% follow-up flare chance per 50 ranks",
          :chart           => divide_truncate_chart(50),
          :bonus_amount    => 17,
          :bonus_type      => :percent,
          :bonus_to        => "follow-up flare chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "dispel cooldown reduction"     => {
          :description     => "-1 second dispel cooldown per seed 1 threshold (base 30s, min 9s)",
          :chart           => summation_chart(1),
          :bonus_amount    => -1,
          :bonus_type      => :time,
          :bonus_to        => "dispel cooldown",
          :bonus_max       => 21,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "critical padding when stunned" => {
          :description     => "+1 critical padding per seed 3 threshold when stunned (stacks with base)",
          :chart           => summation_chart(3),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "critical padding",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "carrying capacity bonus"       => {
          :description     => "+1 lb CC per seed 1 threshold (base 10 lbs, max +31 lbs at 231 ranks)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "carrying capacity",
          :bonus_max       => 31,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "stun retaliation cooldown"     => {
          :description     => "-1 second cooldown per seed 3 threshold of combined Air+Water (base 30s, min 10s)",
          :chart           => summation_chart(3),
          :bonus_amount    => -1,
          :bonus_type      => :time,
          :bonus_to        => "stun retaliation cooldown",
          :bonus_max       => 20,
          :duration        => 0,
          :skill_used      => [:elemental_lore_air, :elemental_lore_water],
          :combine_method  => :sum,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 525 - Meteor Swarm
      # https://gswiki.play.net/Meteor_Swarm_(525)
      #
      # Elemental Lore, Fire provides two benefits:
      # 1. Damage factor increase (tiered progression)
      # 2. Additional targets (ball spell progression)
      #
      SpellBonuses.table[:major_elemental][525] = {
        "damage factor increase" => {
          :description     => "+.001 DF per rank (tiered: full 1-50, half 51-100, quarter 101-200)",
          :chart           => damage_factor_chart(1),
          :bonus_amount    => 0.001,
          :bonus_type      => :units,
          :bonus_to        => "damage factor",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "additional targets"     => {
          :description     => "determines max targets hit (ball spell progression)",
          :chart           => ball_spell_chart(),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "targets",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 530 - Elemental Disjunction
      # https://gswiki.play.net/Elemental_Disjunction_(530)
      #
      # Major Elemental spell ranks (not lore): Increases minimum spells dispelled
      # Note: Formula not specified on gswiki
      #
      SpellBonuses.table[:major_elemental][530] = {
        "minimum spells dispelled" => {
          :description     => "increases minimum spells dispelled based on MjE spell ranks (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "minimum dispelled",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :major_elemental,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 535 - Haste
      # https://gswiki.play.net/Haste_(535)
      #
      # Elemental Lore, Air + Major Elemental spell ranks:
      # Base RT reduction: 20%
      # +1% per 5 MjE spell ranks (capped at level)
      # +1% per 5 Air Lore ranks
      # Maximum total reduction: 60%
      #
      # Note: MjE spell rank benefit tracked separately
      #
      SpellBonuses.table[:major_elemental][535] = {
        "RT reduction" => {
          :description     => "+1% RT reduction per 5 Air ranks (max 60% total with MjE ranks)",
          :chart           => divide_truncate_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "RT reduction",
          :bonus_max       => 40,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 550 - Time Stop
      # https://gswiki.play.net/Time_Stop_(550)
      #
      # All Four Elemental Lores provide different benefits:
      # - Earth: +1 use per day at 40, 115, 190 ranks
      # - Air: +1.5 seconds RT removal per seed 1 threshold (base 60s)
      # - Water: 50 ranks unlocks automatic Elemental Wave (410)
      # - Fire: 50 ranks unlocks automatic fire wave (50 both = Major Elemental Wave 435)
      #
      SpellBonuses.table[:major_elemental][550] = {
        "additional uses per day" => {
          :description     => "+1 use per day at 40, 115, 190 ranks",
          :chart           => fixed_spacing_chart([40, 115, 190]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "uses per day",
          :bonus_max       => 3,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "RT removal bonus"        => {
          :description     => "+1.5 seconds RT removal per seed 1 threshold (base 60s)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1.5,
          :bonus_type      => :time,
          :bonus_to        => "RT removal",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable water wave"       => {
          :description     => "50 ranks unlocks automatic Elemental Wave (410)",
          :chart           => flat_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "water wave",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable fire wave"        => {
          :description     => "50 ranks unlocks automatic fire wave (combines with water for 435)",
          :chart           => flat_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "fire wave",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }
    end
  end
end
