# frozen_string_literal: true

#
# Cleric Base (300s) Spell Bonuses
#
# This file defines skill/lore/stat-based bonuses for the Cleric Base spell circle.
# All bonus calculations use chart functions from Lich::Util::ChartCalculator.
#
# Reference: https://gswiki.play.net/Cleric_Base
# Last Updated: December 28, 2025
#
# Lores used in this circle:
#   - Spiritual Lore, Blessings
#   - Spiritual Lore, Religion
#

module Lich
  module Gemstone
    module Spell
      include Lich::Util::ChartCalculator

      SpellBonuses.table[:cleric] = {}

      #
      # Spell 302 - Smite/Bane
      # https://gswiki.play.net/Smite/Bane_(302)
      #
      # Spiritual Lore, Religion: Grants/increases chance for infusion of extra damage
      # Formula: Approximately (Religion skill bonus / 10)%
      # Also provides instant death chance based on warding margin + lore (caps ~9%)
      #
      SpellBonuses.table[:cleric][302] = {
        "extra damage chance" => {
          :description     => "Chance for infusion of extra damage (Religion skill bonus / 10)%",
          :chart           => divide_truncate_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "extra damage chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 303 - Prayer of Protection
      # https://gswiki.play.net/Prayer_of_Protection_(303)
      #
      # Spiritual Lore, Blessings: At 40 ranks, allows casting on others (2 minute duration)
      #
      SpellBonuses.table[:cleric][303] = {
        "enable other-cast" => {
          :description     => "40 ranks allows casting on others with 2 minute duration",
          :chart           => flat_chart(40),
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
      # Spell 304 - Bless
      # https://gswiki.play.net/Bless_(304)
      #
      # Spiritual Lore, Blessings provides two bonuses:
      # 1. +1 swing per rank
      # 2. At 40 ranks, blessed weapons anchor noncorporeal undead for 30 seconds
      #
      SpellBonuses.table[:cleric][304] = {
        "additional swings"          => {
          :description     => "+1 swing per Blessings rank",
          :chart           => divide_truncate_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "swings",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "anchor noncorporeal undead" => {
          :description     => "40 ranks: blessed weapons anchor noncorporeal undead for 30 seconds",
          :chart           => flat_chart(40),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "anchor undead",
          :bonus_max       => 0,
          :duration        => 30,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 305 - Preservation
      # https://gswiki.play.net/Preservation_(305)
      #
      # Spiritual Lore, Blessings: +15 seconds duration per rank (base 10 minutes)
      #
      SpellBonuses.table[:cleric][305] = {
        "duration increase" => {
          :description     => "+15 seconds duration per Blessings rank (base 10 minutes)",
          :chart           => divide_truncate_chart(1),
          :bonus_amount    => 15,
          :bonus_type      => :time,
          :bonus_to        => "duration",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 306 - Holy Bolt
      # https://gswiki.play.net/Holy_Bolt_(306)
      #
      # Spiritual Lore, Religion provides three bonuses:
      # 1. At 30 ranks: Unlocks acid degeneration vs undead
      # 2. At 30 ranks: Unlocks EVOKE version for living (plasma damage)
      # 3. DF increase vs undead (tiered: +0.001/rank 1-50, /2 ranks 51-100, /4 ranks 101-200)
      #    Note: First 30 ranks don't count for DF when using EVOKE version
      #
      SpellBonuses.table[:cleric][306] = {
        "unlock acid degeneration"    => {
          :description     => "30 ranks unlocks acid degeneration vs undead",
          :chart           => flat_chart(30),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "acid degeneration",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "unlock EVOKE living version" => {
          :description     => "30 ranks unlocks EVOKE version for plasma damage vs living",
          :chart           => flat_chart(30),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "EVOKE living",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "damage factor increase"      => {
          :description     => "+0.001 DF per rank vs undead (tiered progression)",
          :chart           => damage_factor_chart(1),
          :bonus_amount    => 0.001,
          :bonus_type      => :units,
          :bonus_to        => "damage factor",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 307 - Benediction
      # https://gswiki.play.net/Benediction_(307)
      #
      # Spiritual Lore, Blessings: Chance for +15 AS bonus on attack
      # Formula: 1% per seed 6 summation (1% at 6 ranks, max 15% at 195 ranks)
      #
      SpellBonuses.table[:cleric][307] = {
        "AS bonus chance" => {
          :description     => "1% chance per seed 6 threshold for +15 AS bonus on attack",
          :chart           => summation_chart(6),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "AS bonus chance",
          :bonus_max       => 15,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 308 - Well of Life
      # https://gswiki.play.net/Well_of_Life_(308)
      #
      # Spiritual Lore, Religion: Increases chance to discover CONVERT status
      # Spiritual Lore, Blessings: -1 second cooldown per rank (base 300 seconds)
      #
      SpellBonuses.table[:cleric][308] = {
        "deity discovery chance" => {
          :description     => "Increases chance to discover target's CONVERT status",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "deity discovery",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "cooldown reduction"     => {
          :description     => "-1 second cooldown per Blessings rank (base 300 seconds)",
          :chart           => divide_truncate_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :time,
          :bonus_to        => "cooldown reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 309 - Condemn
      # https://gswiki.play.net/Condemn_(309)
      #
      # Spiritual Lore, Religion: -1 kills needed per charge per 50 skill bonus
      #   Ranks 0/10/24/50/100/150/200/250 → Kills 10/9/8/7/6/5/4/3
      # Spiritual Lore, Blessings: +1 stored charge per seed 10 summation
      #
      SpellBonuses.table[:cleric][309] = {
        "kills reduction" => {
          :description     => "-1 kills needed per charge per 50 Religion skill bonus",
          :chart           => divide_truncate_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "kills reduction",
          :bonus_max       => 7,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "stored charges"  => {
          :description     => "+1 stored charge per seed 10 threshold (base 1 charge)",
          :chart           => summation_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "stored charges",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 311 - Blind
      # https://gswiki.play.net/Blind_(311)
      #
      # Spiritual Lore, Religion: Increases chance target is forced to kneel (on 120+ endroll)
      # Formula: +1% per 3 ranks
      #
      SpellBonuses.table[:cleric][311] = {
        "kneel chance" => {
          :description     => "+1% kneel chance per 3 Religion ranks (on 120+ endroll)",
          :chart           => divide_truncate_chart(3),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "kneel chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 312 - Fervent Reproach
      # https://gswiki.play.net/Fervent_Reproach_(312)
      #
      # Spiritual Lore, Religion: Increases number of damage cycles
      #   Formula: (warding margin / 50) + (Religion ranks / 15), min 2, max 6
      # Spiritual Lore, Blessings: +2 seconds duration of Wisdom/health/mana boost per rank
      #
      SpellBonuses.table[:cleric][312] = {
        "damage cycles"      => {
          :description     => "+1 damage cycle per 15 Religion ranks (min 2, max 6 total)",
          :chart           => divide_truncate_chart(15),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "damage cycles",
          :bonus_max       => 4,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enhancive duration" => {
          :description     => "+2 seconds duration of Wisdom/health/mana boost per rank",
          :chart           => divide_truncate_chart(1),
          :bonus_amount    => 2,
          :bonus_type      => :time,
          :bonus_to        => "enhancive duration",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 314 - Relieve Burden
      # https://gswiki.play.net/Relieve_Burden_(314)
      #
      # Spiritual Lore, Blessings provides two bonuses:
      # 1. +2,000 silvers negated per seed 5 summation (base 10,000)
      # 2. +2% corpse weight reduction per seed 5 summation (base 50%)
      #
      SpellBonuses.table[:cleric][314] = {
        "silvers negated"         => {
          :description     => "+2,000 silvers negated per seed 5 threshold (base 10,000)",
          :chart           => summation_chart(5),
          :bonus_amount    => 2000,
          :bonus_type      => :units,
          :bonus_to        => "silvers negated",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "corpse weight reduction" => {
          :description     => "+2% corpse weight reduction per seed 5 threshold (base 50%)",
          :chart           => summation_chart(5),
          :bonus_amount    => 2,
          :bonus_type      => :percent,
          :bonus_to        => "weight reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 315 - Remove Curse
      # https://gswiki.play.net/Remove_Curse_(315)
      #
      # Spiritual Lore, Blessings: Increases effectiveness (formula not specified)
      #
      SpellBonuses.table[:cleric][315] = {
        "increased effectiveness" => {
          :description     => "Increases effectiveness of curse removal (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "effectiveness",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 317 - Divine Fury
      # https://gswiki.play.net/Divine_Fury_(317)
      #
      # Spiritual Lore, Religion: Chance for extra (3rd) plasma critical cycle
      # Formula: (Religion ranks / 1.5)%
      #
      SpellBonuses.table[:cleric][317] = {
        "third critical chance" => {
          :description     => "(Religion ranks / 1.5)% chance for 3rd critical cycle",
          :chart           => divide_truncate_chart(1.5),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "third critical chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 318 - Raise Dead
      # https://gswiki.play.net/Raise_Dead_(318)
      #
      # TODO: Implement spell rank bonuses (not lore bonuses)
      # This spell has Cleric Base spell rank requirements, not lore requirements:
      #   - 25 Cleric Base ranks: Unlocks Life Restoration (no decay timer penalty)
      #   - 40 Cleric Base ranks: Unlocks Resurrection (no experience loss)
      #
      # Implementation would require :skill_used => :cleric (spell ranks)
      # May need special handling since these are spell circle ranks, not lore ranks
      #
      # SpellBonuses.table[:cleric][318] = {
      #   "life restoration unlock" => {
      #     :description     => "25 Cleric Base ranks unlocks Life Restoration",
      #     :chart           => flat_chart(25),
      #     :bonus_amount    => 1,
      #     :bonus_type      => :ability,
      #     :bonus_to        => "life restoration",
      #     :bonus_max       => 0,
      #     :duration        => 0,
      #     :skill_used      => :cleric,
      #     :repetitions     => 999,
      #     :repeat_modifier => 0
      #   },
      #   "resurrection unlock" => {
      #     :description     => "40 Cleric Base ranks unlocks Resurrection",
      #     :chart           => flat_chart(40),
      #     :bonus_amount    => 1,
      #     :bonus_type      => :ability,
      #     :bonus_to        => "resurrection",
      #     :bonus_max       => 0,
      #     :duration        => 0,
      #     :skill_used      => :cleric,
      #     :repetitions     => 999,
      #     :repeat_modifier => 0
      #   }
      # }

      #
      # Spell 319 - Soul Ward
      # https://gswiki.play.net/Soul_Ward_(319)
      #
      # Spiritual Lore, Blessings: Chance to negate opponent's subsequent attack
      # Formula: 1% per seed 1 summation
      #
      SpellBonuses.table[:cleric][319] = {
        "attack negation chance" => {
          :description     => "1% chance per seed 1 threshold to negate subsequent attack",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "negation chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 320 - Ethereal Censer
      # https://gswiki.play.net/Ethereal_Censer_(320)
      #
      # Spiritual Lore, Religion: Increases maneuver attack strength and
      # chance of reduced cooldown (exact formula not specified)
      #
      SpellBonuses.table[:cleric][320] = {
        "maneuver strength"         => {
          :description     => "Increases maneuver attack strength (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "maneuver strength",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "cooldown reduction chance" => {
          :description     => "Increases chance of reduced cooldown (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :percent,
          :bonus_to        => "cooldown reduction chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 325 - Holy Receptacle
      # https://gswiki.play.net/Holy_Receptacle_(325)
      #
      # Spiritual Lore, Religion: Required for tier unlocks
      #   Tier 1 (Silver to Gold): 10 ranks
      #   Tier 2 (Brimstone): 15 ranks
      #   Tier 3 (Nexus): 20 ranks
      #   Tier 4 (Chrism): 25 ranks
      #   Tier 5 (Intercession): 30 ranks
      # Spiritual Lore, Blessings: Reduces failure chance (caps at 21 ranks, 7-9%)
      #
      SpellBonuses.table[:cleric][325] = {
        "tier unlocks"      => {
          :description     => "Unlocks tiers at 10/15/20/25/30 Religion ranks",
          :chart           => fixed_spacing_chart([10, 15, 20, 25, 30]),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "tier unlock",
          :bonus_max       => 5,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "failure reduction" => {
          :description     => "Reduces failure chance 7-9% (caps at 21 Blessings ranks)",
          :chart           => per_x_ranks_chart(1, 0, 21),
          :bonus_amount    => 0,
          :bonus_type      => :percent,
          :bonus_to        => "failure reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 330 - Sanctify
      # https://gswiki.play.net/Sanctify_(330)
      #
      # Spiritual Lore, Religion: Extra Holy Fire flare charges at 90 and 180 ranks
      # Spiritual Lore, Blessings: 100 ranks allows bestowing Holy Fire flares on T5 armaments
      #
      SpellBonuses.table[:cleric][330] = {
        "extra flare charges" => {
          :description     => "+1 Holy Fire flare charge at 90 and 180 Religion ranks",
          :chart           => fixed_spacing_chart([90, 180]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "flare charges",
          :bonus_max       => 2,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "T5 Holy Fire flares" => {
          :description     => "100 ranks allows bestowing Holy Fire flares on T5 armaments",
          :chart           => flat_chart(100),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "T5 flares",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 335 - Divine Wrath
      # https://gswiki.play.net/Divine_Wrath_(335)
      #
      # Spiritual Lore, Religion: Increases critical damage via crit rank modifier
      # Formula: seed 6 summation / 5 = crit rank modifier
      #   40 ranks = +1.0, 110 ranks = +2.0, 195 ranks = +3.0
      #
      SpellBonuses.table[:cleric][335] = {
        "crit rank modifier" => {
          :description     => "Crit rank modifier = seed 6 threshold / 5 (+1 at 40, +2 at 110, +3 at 195)",
          :chart           => summation_chart(6),
          :bonus_amount    => 0.2,
          :bonus_type      => :units,
          :bonus_to        => "crit rank",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 340 - Symbol of the Proselyte
      # https://gswiki.play.net/Symbol_of_the_Proselyte_(340)
      #
      # Spiritual Lore, Blessings: +1 charge to holy symbol per 50 skill bonus
      #
      SpellBonuses.table[:cleric][340] = {
        "additional charges" => {
          :description     => "+1 charge per 50 Blessings skill bonus",
          :chart           => divide_truncate_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "charges",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 350 - Miracle
      # https://gswiki.play.net/Miracle_(350)
      #
      # Spiritual Lore, Religion: Additional daily uses at 60, 125, 195 ranks
      # Spiritual Lore, Blessings: 5% chance per seed 2 summation for free MANA SPELLUP
      #
      SpellBonuses.table[:cleric][350] = {
        "additional daily uses"    => {
          :description     => "+1 daily use at 60, 125, and 195 Religion ranks",
          :chart           => fixed_spacing_chart([60, 125, 195]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "daily uses",
          :bonus_max       => 3,
          :duration        => 0,
          :skill_used      => :spiritual_lore_religion,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "free MANA SPELLUP chance" => {
          :description     => "5% chance per seed 2 threshold for free MANA SPELLUP after resurrection",
          :chart           => summation_chart(2),
          :bonus_amount    => 5,
          :bonus_type      => :percent,
          :bonus_to        => "free spellup chance",
          :bonus_max       => 90,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }
    end
  end
end
