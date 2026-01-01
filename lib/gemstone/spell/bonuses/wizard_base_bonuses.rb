# frozen_string_literal: true

#
# Wizard Base (900s) Spell Bonuses
#
# This file defines skill/lore/stat-based bonuses for the Wizard Base spell circle.
# All bonus calculations use chart functions from Lich::Util::ChartCalculator.
#
# Wizards use all four Elemental Lores (Air, Earth, Fire, Water) and Elemental Mana Control.
# Several effects use skill BONUS (:bonus_used) rather than ranks (:skill_used).
#
# Reference: https://gswiki.play.net/Wizard_Base
# Last Updated: January 1, 2026
#

module Lich
  module Gemstone
    module Spell
      include Lich::Util::ChartCalculator

      SpellBonuses.table[:wizard] = {}

      #
      # Spell 901 - Minor Shock
      # https://gswiki.play.net/Minor_Shock_(901)
      #
      # Air Lore: Seed 5 summation chance for Stun Shock effect
      # Water Lore: +1 second Stun Shock duration per seed 10 threshold (base 8s)
      # Air Lore: DF increase +.001 per 2 ranks (1-100), +.001 per 4 ranks (101-200)
      #
      SpellBonuses.table[:wizard][901] = {
        "Stun Shock chance"      => {
          :description     => "seed 5 summation % chance for Stun Shock effect",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "Stun Shock chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "Stun Shock duration"    => {
          :description     => "+1 second Stun Shock duration per seed 10 threshold (base 8s)",
          :chart           => summation_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :time,
          :bonus_to        => "Stun Shock duration",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "damage factor increase" => {
          :description     => "+.001 DF per 2 ranks (1-100), +.001 per 4 ranks (101-200)",
          :chart           => damage_factor_chart(2),
          :bonus_amount    => 0.001,
          :bonus_type      => :units,
          :bonus_to        => "damage factor",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 902 - Minor Elemental Edge
      # https://gswiki.play.net/Minor_Elemental_Edge_(902)
      #
      # Earth Lore: EVOKE version for warmages provides +10 enhancive weapon skill
      # Earth Lore: +1 weapon skill per seed 7 summation threshold (EVOKE version)
      #
      SpellBonuses.table[:wizard][902] = {
        "EVOKE base weapon skill"       => {
          :description     => "EVOKE version provides +10 enhancive weapon skill (warmages)",
          :chart           => flat_chart(1),
          :bonus_amount    => 10,
          :bonus_type      => :units,
          :bonus_to        => "weapon skill",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "EVOKE additional weapon skill" => {
          :description     => "+1 weapon skill per seed 7 threshold (EVOKE version)",
          :chart           => summation_chart(7),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "weapon skill",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 903 - Minor Water
      # https://gswiki.play.net/Minor_Water_(903)
      #
      # Fire Lore: 20 ranks unlocks CHANNEL for Steam Bolt
      # Water Lore: Soaking effect 20% base + (skill bonus/2)% up to 100%
      #
      SpellBonuses.table[:wizard][903] = {
        "enable Steam Bolt CHANNEL" => {
          :description     => "20 ranks unlocks CHANNEL for Steam Bolt conversion",
          :chart           => flat_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "Steam Bolt",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "soaking effect chance"     => {
          :description     => "soaking chance = 20% + (skill bonus / 2), max 100%",
          :chart           => divide_truncate_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "soaking chance",
          :bonus_max       => 80,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 904 - Minor Acid
      # https://gswiki.play.net/Minor_Acid_(904)
      #
      # Earth Lore: 10 ranks unlocks 25% splash chance, damage scales with ranks
      # Water Lore: 30 ranks unlocks CHANNEL for Major Acid (1710) at +1 mana
      # Water Lore: DF increase +.001 per 2 ranks (1-100), +.001 per 4 ranks (101-200)
      #
      SpellBonuses.table[:wizard][904] = {
        "enable acid splash"        => {
          :description     => "10 ranks unlocks 25% splash chance, damage scales with ranks",
          :chart           => flat_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "acid splash",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable Major Acid CHANNEL" => {
          :description     => "30 ranks unlocks CHANNEL for Major Acid (1710) at +1 mana",
          :chart           => flat_chart(30),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "Major Acid",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "damage factor increase"    => {
          :description     => "+.001 DF per 2 ranks (1-100), +.001 per 4 ranks (101-200)",
          :chart           => damage_factor_chart(2),
          :bonus_amount    => 0.001,
          :bonus_type      => :units,
          :bonus_to        => "damage factor",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 905 - Prismatic Guard
      # https://gswiki.play.net/Prismatic_Guard_(905)
      #
      # Earth Lore: +1 DS per seed 5 summation threshold
      #
      SpellBonuses.table[:wizard][905] = {
        "DS bonus" => {
          :description     => "+1 DS per seed 5 threshold",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "DS",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 906 - Minor Fire
      # https://gswiki.play.net/Minor_Fire_(906)
      #
      # Fire Lore: 10 ranks unlocks ignite effect
      # Fire Lore: ignite chance = skill bonus / 5 (10s duration, damage every 5s)
      #
      SpellBonuses.table[:wizard][906] = {
        "enable ignite effect" => {
          :description     => "10 ranks unlocks ignite effect",
          :chart           => flat_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "ignite",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "ignite chance"        => {
          :description     => "ignite chance = skill bonus / 5 (10s duration, damage every 5s)",
          :chart           => divide_truncate_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "ignite chance",
          :bonus_max       => 0,
          :duration        => 10,
          :skill_used      => nil,
          :bonus_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 909 - Tremors
      # https://gswiki.play.net/Tremors_(909)
      #
      # Earth Lore: EVOKE charges: 5 base + bonus at 20/50/90/150/200 ranks
      # Earth Lore: EBP penalty (5 + seed 4/2)% for 10s on knocked down targets
      #
      SpellBonuses.table[:wizard][909] = {
        "EVOKE charges" => {
          :description     => "EVOKE charges: 5 base + bonus at 20/50/90/150/200 ranks",
          :chart           => fixed_spacing_chart([20, 50, 90, 150, 200]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "EVOKE charges",
          :bonus_max       => 5,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "EBP penalty"   => {
          :description     => "EBP penalty (5 + seed 4/2)% for 10s on knocked down targets",
          :chart           => divide_truncate_chart_from(summation_chart(4), 2),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "EBP penalty",
          :bonus_max       => 0,
          :duration        => 10,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 910 - Major Shock
      # https://gswiki.play.net/Major_Shock_(910)
      #
      # Same lore benefits as Minor Shock (901):
      # Air Lore: Seed 5 summation chance for Stun Shock effect
      # Water Lore: +1 second Stun Shock duration per seed 10 threshold (base 8s)
      # Air Lore: DF increase +.001 per 2 ranks (1-100), +.001 per 4 ranks (101-200)
      #
      SpellBonuses.table[:wizard][910] = {
        "Stun Shock chance"      => {
          :description     => "seed 5 summation % chance for Stun Shock effect",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "Stun Shock chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "Stun Shock duration"    => {
          :description     => "+1 second Stun Shock duration per seed 10 threshold (base 8s)",
          :chart           => summation_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :time,
          :bonus_to        => "Stun Shock duration",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "damage factor increase" => {
          :description     => "+.001 DF per 2 ranks (1-100), +.001 per 4 ranks (101-200)",
          :chart           => damage_factor_chart(2),
          :bonus_amount    => 0.001,
          :bonus_type      => :units,
          :bonus_to        => "damage factor",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 911 - Mass Blur
      # https://gswiki.play.net/Mass_Blur_(911)
      #
      # Air Lore: +1 dodge per seed 1 summation threshold (self-cast only)
      #
      SpellBonuses.table[:wizard][911] = {
        "dodge bonus" => {
          :description     => "+1 dodge per seed 1 threshold (self-cast only)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "dodge",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 912 - Call Wind
      # https://gswiki.play.net/Call_Wind_(912)
      #
      # Air Lore: Knockdown chance = seed 5 summation * 2 (32% at 200 ranks)
      # Note: Non-standard formula using doubled seed 5 summation
      #
      SpellBonuses.table[:wizard][912] = {
        "knockdown chance" => {
          :description     => "knockdown chance = seed 5 summation * 2 (32% at 200 ranks)",
          :chart           => custom_formula_chart { |ranks| ChartCalculator.summation_bonus(5, ranks) * 2 },
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "knockdown chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 914 - Sandstorm
      # https://gswiki.play.net/Sandstorm_(914)
      #
      # Air Lore: Increases wind damage using seed 6 summation
      # Earth Lore: Increases sand damage using seed 6 summation
      #
      SpellBonuses.table[:wizard][914] = {
        "wind damage increase" => {
          :description     => "wind damage increase per seed 6 threshold",
          :chart           => summation_chart(6),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "wind damage",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "sand damage increase" => {
          :description     => "sand damage increase per seed 6 threshold",
          :chart           => summation_chart(6),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "sand damage",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 916 - Invisibility
      # https://gswiki.play.net/Invisibility_(916)
      #
      # Air Lore: 50 ranks unlocks group EVOKE version (2-min duration, disbands group)
      #
      SpellBonuses.table[:wizard][916] = {
        "enable group EVOKE" => {
          :description     => "50 ranks unlocks group EVOKE version (2-min duration, disbands group)",
          :chart           => flat_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "group cast",
          :bonus_max       => 0,
          :duration        => 120,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 917 - Earthen Fury
      # https://gswiki.play.net/Earthen_Fury_(917)
      #
      # Earth Lore: Cycles 2-6 gain (100 * ranks/202)% of prone/stun bonus when not prone
      # Fire Lore: (ranks/5)% chance for extra powerful critical (fire version)
      # Water Lore: (ranks/5)% chance for extra powerful critical (cold version)
      #
      SpellBonuses.table[:wizard][917] = {
        "partial prone stun bonus"   => {
          :description     => "cycles 2-6 gain (100 * ranks/202)% of prone/stun bonus when not prone",
          :chart           => divide_truncate_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "prone stun bonus",
          :bonus_max       => 100,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "fire extra critical chance" => {
          :description     => "(ranks/5)% chance for extra powerful critical (fire version)",
          :chart           => divide_truncate_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "extra critical chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "cold extra critical chance" => {
          :description     => "(ranks/5)% chance for extra powerful critical (cold version)",
          :chart           => divide_truncate_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "extra critical chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 920 - Call Familiar
      # https://gswiki.play.net/Call_Familiar_(920)
      #
      # Air Lore: 100/200 skill bonus reduces familiar travel time
      # Water Lore: 50 ranks unlocks ability to anchor familiar to earthnode
      # Water Lore: 75 ranks unlocks TELL FAMILIAR TO TRAVEL within zone
      #
      SpellBonuses.table[:wizard][920] = {
        "reduced travel time"     => {
          :description     => "100/200 skill bonus reduces familiar travel time",
          :chart           => fixed_spacing_chart([100, 200]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "travel time reduction",
          :bonus_max       => 2,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable earthnode anchor" => {
          :description     => "50 ranks unlocks ability to anchor familiar to earthnode",
          :chart           => flat_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "earthnode anchor",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable town travel"      => {
          :description     => "75 ranks unlocks TELL FAMILIAR TO TRAVEL within zone",
          :chart           => flat_chart(75),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "town travel",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 925 - Enchant
      # https://gswiki.play.net/Enchant_(925)
      #
      # Air Lore: Retains (20 + seed 5 * 5)% of remaining static essence
      # Fire Lore: Bonus static essence (seed 5 + 4)% on mana pulse
      # Water Lore: Increases max essence conversion per pulse by skill bonus
      # EMC: Increases essence absorption rate (min 26 ranks for any gain)
      #
      SpellBonuses.table[:wizard][925] = {
        "static essence retention"        => {
          :description     => "retains (20 + seed 5 * 5)% of remaining static essence",
          :chart           => summation_chart(5),
          :bonus_amount    => 5,
          :bonus_type      => :percent,
          :bonus_to        => "essence retention",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "bonus static essence"            => {
          :description     => "(seed 5 + 4)% bonus static essence on mana pulse",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "bonus essence",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "max essence conversion increase" => {
          :description     => "increases max essence conversion per pulse by skill bonus",
          :chart           => divide_truncate_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "max essence conversion",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "essence absorption increase"     => {
          :description     => "increases essence absorption rate (min 26 ranks for any gain)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "essence absorption",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_mana_control,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 930 - Familiar Gate
      # https://gswiki.play.net/Familiar_Gate_(930)
      #
      # EMC: Increases portal capacity (formula NS, 100 Wiz + 100 EMC = 24 people)
      # Water Lore: 75+ ranks reduces inter-realm penalty 1% per 3 ranks (base 33%)
      # Water Lore: Reduces Chronomage interception (base 80%, -1% per 2 ranks over 75, min 5%)
      #
      SpellBonuses.table[:wizard][930] = {
        "portal capacity increase"          => {
          :description     => "increases portal capacity (formula NS, 100 Wiz + 100 EMC = 24 people)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "portal capacity",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_mana_control,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "inter-realm penalty reduction"     => {
          :description     => "75+ ranks reduces inter-realm penalty 1% per 3 ranks (base 33%)",
          :chart           => per_x_ranks_chart(3, 75, 999),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "penalty reduction",
          :bonus_max       => 33,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "Chronomage interception reduction" => {
          :description     => "reduces interception (base 80%, -1% per 2 ranks over 75, min 5%)",
          :chart           => per_x_ranks_chart(2, 75, 225),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "interception reduction",
          :bonus_max       => 75,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 950 - Core Tap
      # https://gswiki.play.net/Core_Tap_(950)
      #
      # Earth Lore: +1 use per minute at 60/135/210 ranks
      # Air Lore: (5 * seed 1)% chance to CHANNEL spells without RT
      # Water Lore: Free mana = 6 * seed 10 summation
      # Fire Lore: +AS/+CS for subsequent spells = 6 * seed 10 summation
      # EMC: Max targets = 5 + (skill bonus / 50)
      #
      SpellBonuses.table[:wizard][950] = {
        "additional uses per minute" => {
          :description     => "+1 use per minute at 60/135/210 ranks",
          :chart           => fixed_spacing_chart([60, 135, 210]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "uses per minute",
          :bonus_max       => 3,
          :duration        => 0,
          :skill_used      => :elemental_lore_earth,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "CHANNEL without RT chance"  => {
          :description     => "(5 * seed 1)% chance to CHANNEL spells without RT",
          :chart           => summation_chart(1),
          :bonus_amount    => 5,
          :bonus_type      => :percent,
          :bonus_to        => "no RT chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_air,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "free mana"                  => {
          :description     => "free mana = 6 * seed 10 summation",
          :chart           => summation_chart(10),
          :bonus_amount    => 6,
          :bonus_type      => :units,
          :bonus_to        => "free mana",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_water,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "AS CS boost"                => {
          :description     => "+AS/+CS for subsequent spells = 6 * seed 10 summation",
          :chart           => summation_chart(10),
          :bonus_amount    => 6,
          :bonus_type      => :units,
          :bonus_to        => "AS CS",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :elemental_lore_fire,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "max targets"                => {
          :description     => "max targets = 5 + (skill bonus / 50)",
          :chart           => divide_truncate_chart(50),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "max targets",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :elemental_mana_control,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }
    end
  end
end
