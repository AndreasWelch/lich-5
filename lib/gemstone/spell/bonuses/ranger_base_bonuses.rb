# frozen_string_literal: true

#
# Ranger Base (600s) Spell Bonuses
#
# This file defines skill/lore/stat-based bonuses for the Ranger Base spell circle.
# All bonus calculations use chart functions from Lich::Util::ChartCalculator.
#
# Rangers use Spiritual Lore, Blessings and Spiritual Lore, Summoning.
# Several effects use skill BONUS (:bonus_used) rather than ranks (:skill_used).
#
# Reference: https://gswiki.play.net/Ranger_Base
# Last Updated: January 1, 2026
#

module Lich
  module Gemstone
    module Spell
      include Lich::Util::ChartCalculator

      SpellBonuses.table[:ranger] = {}

      #
      # Spell 601 - Natural Colors
      # https://gswiki.play.net/Natural_Colors_(601)
      #
      # Spiritual Lore, Blessings provides three benefits:
      # 1. +1 DS per seed 5 threshold (caster only)
      # 2. +1 stealth roll bonus per seed 1 threshold
      # 3. +1 bolt DS (fire, ice, steam, electrical) per seed 5 threshold
      #
      SpellBonuses.table[:ranger][601] = {
        "DS bonus"           => {
          :description     => "+1 DS per seed 5 threshold (caster only)",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "DS",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "stealth roll bonus" => {
          :description     => "+1 stealth roll bonus per seed 1 threshold",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "stealth roll",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "bolt DS bonus"      => {
          :description     => "+1 bolt DS (fire, ice, steam, electrical) per seed 5 threshold",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "bolt DS",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 602 - Resist Elements
      # https://gswiki.play.net/Resist_Elements_(602)
      #
      # Spiritual Lore, Blessings: +1 bolt DS per seed 5 threshold
      # Also increases weather protection (formula NS - not tracked)
      #
      SpellBonuses.table[:ranger][602] = {
        "bolt DS bonus" => {
          :description     => "+1 bolt DS (fire, ice, steam, electrical) per seed 5 threshold",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "bolt DS",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 603 - Wild Entropy
      # https://gswiki.play.net/Wild_Entropy_(603)
      #
      # Spiritual Lore, Summoning: +1 nature resistance debuff magnitude per seed 1 threshold
      # Base magnitude: 10, debuff stacks with diminishing returns
      #
      SpellBonuses.table[:ranger][603] = {
        "nature resistance debuff" => {
          :description     => "+1 nature resistance debuff magnitude per seed 1 threshold (base 10)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "debuff magnitude",
          :bonus_max       => 0,
          :duration        => 30,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 604 - Nature's Bounty
      # https://gswiki.play.net/Nature%27s_Bounty_(604)
      #
      # Spiritual Lore, Blessings provides three benefits:
      # 1. +1 skinning/foraging bonus per rank (max 30)
      # 2. 30 ranks unlocks EVOKE to restore forage slots (1/hour)
      # 3. +1% skin value per seed 5 threshold
      #
      SpellBonuses.table[:ranger][604] = {
        "skinning foraging bonus" => {
          :description     => "+1 skinning/foraging bonus per rank (max 30)",
          :chart           => divide_truncate_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "skinning foraging",
          :bonus_max       => 30,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable EVOKE restore"    => {
          :description     => "30 ranks unlocks EVOKE to restore forage slots (1/hour)",
          :chart           => flat_chart(30),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "EVOKE restore",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "skin value increase"     => {
          :description     => "+1% skin value per seed 5 threshold",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "skin value",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 605 - Barkskin
      # https://gswiki.play.net/Barkskin_(605)
      #
      # Spiritual Lore, Blessings provides three benefits:
      # 1. +1% endure chance per 2 ranks (base 50%)
      # 2. 15 ranks unlocks COMMUNE cast while incapacitated (1/hour)
      # 3. 50 ranks unlocks group EVOKE (15 mana)
      #
      SpellBonuses.table[:ranger][605] = {
        "endure chance increase" => {
          :description     => "+1% endure chance per 2 ranks (base 50%)",
          :chart           => divide_truncate_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "endure chance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable COMMUNE cast"    => {
          :description     => "15 ranks unlocks cast while incapacitated (1/hour)",
          :chart           => flat_chart(15),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "COMMUNE cast",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable group EVOKE"     => {
          :description     => "50 ranks unlocks group version via EVOKE (15 mana)",
          :chart           => flat_chart(50),
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
      # Spell 607 - Sounds
      # https://gswiki.play.net/Sounds_(607)
      #
      # Spiritual Lore, Summoning: +1% spell-casting hindrance per seed 1 threshold
      # Base hindrance: 10%
      #
      SpellBonuses.table[:ranger][607] = {
        "spell hindrance increase" => {
          :description     => "+1% spell-casting hindrance per seed 1 threshold (base 10%)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "spell hindrance",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 608 - Camouflage
      # https://gswiki.play.net/Camouflage_(608)
      #
      # Spiritual Lore, Blessings: 20 ranks unlocks companion camo
      # Provides +30 SMRv2 bonus to companion's next attack from hiding
      #
      SpellBonuses.table[:ranger][608] = {
        "enable companion camo" => {
          :description     => "20 ranks unlocks companion camo (+30 SMRv2 for attack from hiding)",
          :chart           => flat_chart(20),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "companion camo",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 610 - Tangleweed
      # https://gswiki.play.net/Tangleweed_(610)
      #
      # Two lore benefits:
      # 1. Blessings: 10 ranks unlocks strength drain conversion to AS/CS boost
      # 2. Summoning: Poison chance = skill bonus / 2 (uses bonus, not ranks)
      #
      SpellBonuses.table[:ranger][610] = {
        "enable strength drain conversion" => {
          :description     => "10 ranks unlocks AS boost equal to strength drain, CS = 60% of drain",
          :chart           => flat_chart(10),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "strength conversion",
          :bonus_max       => 0,
          :duration        => 120,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "poison chance"                    => {
          :description     => "poison chance = skill bonus / 2 (100% at 200 bonus)",
          :chart           => divide_truncate_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "poison chance",
          :bonus_max       => 100,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 611 - Moonbeam
      # https://gswiki.play.net/Moonbeam_(611)
      #
      # Two lore benefits:
      # 1. Blessings: +1 immobilization recurrence cycle per 30 ranks
      # 2. Summoning: Bolt DF increase (tiered progression)
      #
      SpellBonuses.table[:ranger][611] = {
        "immobilization recurrence" => {
          :description     => "+1 immobilization recurrence cycle per 30 ranks",
          :chart           => divide_truncate_chart(30),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "recurrence cycles",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "bolt damage factor"        => {
          :description     => "+.001 DF per rank (tiered progression)",
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
      # Spell 612 - Breeze
      # https://gswiki.play.net/Breeze_(612)
      #
      # Two lore benefits:
      # 1. Blessings: +1 second ranged RT reduction duration per 12 ranks (base 10s)
      # 2. Summoning: Increases success of gale RT on enemies (formula NS)
      #
      SpellBonuses.table[:ranger][612] = {
        "ranged RT reduction duration" => {
          :description     => "+1 second ranged RT reduction duration per 12 ranks (base 10s)",
          :chart           => divide_truncate_chart(12),
          :bonus_amount    => 1,
          :bonus_type      => :time,
          :bonus_to        => "RT reduction duration",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "gale RT success"              => {
          :description     => "increases success of inflicted RT on enemies (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "gale success",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 613 - Self Control
      # https://gswiki.play.net/Self_Control_(613)
      #
      # Spiritual Lore, Blessings: +1 spiritual TD per seed 5 threshold
      # Added to base +20 TD from spell
      #
      SpellBonuses.table[:ranger][613] = {
        "spiritual TD bonus" => {
          :description     => "+1 spiritual TD per seed 5 threshold (base +20 TD)",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "spiritual TD",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 614 - Imbue
      # https://gswiki.play.net/Imbue_(614)
      #
      # Spiritual Lore, Summoning: +1 mana capacity per seed 1 threshold
      # Spiritual Lore, Blessings provides two benefits:
      # 1. 5 ranks: enables Wild Entropy (603) imbed creation
      # 2. 40 ranks: double MIU for using created items
      #
      SpellBonuses.table[:ranger][614] = {
        "mana capacity increase"       => {
          :description     => "+1 mana capacity per seed 1 threshold",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "mana capacity",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "enable Wild Entropy imbed"    => {
          :description     => "5 ranks enables Wild Entropy (603) imbed creation (creator only)",
          :chart           => flat_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "Wild Entropy imbed",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "double MIU for created items" => {
          :description     => "40 ranks grants double MIU for using created items",
          :chart           => flat_chart(40),
          :bonus_amount    => 1,
          :bonus_type      => :ability,
          :bonus_to        => "double MIU",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 615 - Call Swarm
      # https://gswiki.play.net/Call_Swarm_(615)
      #
      # Spiritual Lore, Summoning: +1 to swarm effects per seed 5 threshold
      # Affects: roundtime, DS penalty, AS penalty, poison, disease
      #
      SpellBonuses.table[:ranger][615] = {
        "swarm effect increase" => {
          :description     => "+1 to swarm effects (RT, DS/AS penalty, poison, disease) per seed 5 threshold",
          :chart           => summation_chart(5),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "swarm effects",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 616 - Spike Thorn
      # https://gswiki.play.net/Spike_Thorn_(616)
      #
      # Spiritual Lore, Summoning: Extra damage cycle chance
      # Formula: (skill bonus / 2) - 30 (uses bonus, not ranks)
      # Minimum 62 bonus needed for any chance (approximately 13 ranks)
      #
      SpellBonuses.table[:ranger][616] = {
        "extra damage cycle chance" => {
          :description     => "extra cycle chance = (skill bonus / 2) - 30 (min 62 bonus for 1%)",
          :chart           => custom_formula_chart { |bonus| [(bonus / 2) - 30, 0].max },
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "extra cycle chance",
          :bonus_max       => 100,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 617 - Sneaking
      # https://gswiki.play.net/Sneaking_(617)
      #
      # Spiritual Lore, Blessings: Decreases slip chance in icy conditions
      # Formula NS (not specified)
      #
      SpellBonuses.table[:ranger][617] = {
        "ice slip reduction" => {
          :description     => "decreases slip chance in icy conditions (formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "slip chance reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 620 - Resist Nature
      # https://gswiki.play.net/Resist_Nature_(620)
      #
      # Spiritual Lore, Blessings provides two benefits:
      # 1. +1% group resistance per 4 ranks (base 20%, max 50% at 120 ranks)
      # 2. +1 item cast success per rank
      #
      SpellBonuses.table[:ranger][620] = {
        "group resistance increase" => {
          :description     => "+1% group resistance per 4 ranks (base 20%, max 50%)",
          :chart           => divide_truncate_chart(4),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "group resistance",
          :bonus_max       => 30,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "item cast success bonus"   => {
          :description     => "+1 item cast success per rank",
          :chart           => divide_truncate_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "item cast success",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 625 - Nature's Touch
      # https://gswiki.play.net/Nature%27s_Touch_(625)
      #
      # Spiritual Lore, Blessings: +1 AS boost from Wild Entropy flare per seed 1 threshold
      # Base AS boost: 10
      #
      SpellBonuses.table[:ranger][625] = {
        "Wild Entropy flare AS boost" => {
          :description     => "+1 AS boost from Wild Entropy flare per seed 1 threshold (base 10)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "flare AS boost",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 635 - Nature's Fury
      # https://gswiki.play.net/Nature%27s_Fury_(635)
      #
      # Spiritual Lore, Summoning: Additional critical damage cycles
      # Based on skill bonus thresholds: 100 bonus = +1 cycle, 200 = +2, 300 = +3
      # Uses bonus, not ranks
      #
      SpellBonuses.table[:ranger][635] = {
        "additional damage cycles" => {
          :description     => "+1 additional crit cycle at skill bonus 100/200/300 thresholds",
          :chart           => fixed_spacing_chart([100, 200, 300]),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "additional cycles",
          :bonus_max       => 3,
          :duration        => 0,
          :skill_used      => nil,
          :bonus_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        }
      }

      #
      # Spell 650 - Assume Aspect
      # https://gswiki.play.net/Assume_Aspect_(650)
      #
      # Both lores provide aspect-specific benefits:
      #
      # Blessings:
      # 1. +1 stat benefit per seed 2 threshold (base +20)
      # 2. +1% evade/block/parry per seed 2 threshold (base 10%)
      # 3. +3% RT reduction per seed 1 threshold (base 25%, Yierka aspect)
      #
      # Summoning:
      # 4. +1 skill rank benefit per seed 2 threshold (base +20)
      # 5. +1 HP per seed 1 threshold (base +25, Bear aspect)
      # 6. Wall of Thorns enhancement (Porcupine aspect, formula NS)
      #
      SpellBonuses.table[:ranger][650] = {
        "stat benefit increase (Porcupine/Rat/Owl/Wolf/Lion/Bear)" => {
          :description     => "+1 stat benefit per seed 2 threshold (base +20, stat-granting aspects)",
          :chart           => summation_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "stat benefit",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "evade block parry increase (Serpent/Burgee/Mantis)"       => {
          :description     => "+1% evade/block/parry per seed 2 threshold (base 10%, defensive aspects)",
          :chart           => summation_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :percent,
          :bonus_to        => "evade block parry",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "RT reduction increase (Yierka)"                           => {
          :description     => "+3% sense/forage/healing RT reduction per seed 1 threshold (base 25%, Yierka only)",
          :chart           => summation_chart(1),
          :bonus_amount    => 3,
          :bonus_type      => :percent,
          :bonus_to        => "RT reduction",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_blessings,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "skill rank increase (Jackal/Panther/Hawk/Yierka)"         => {
          :description     => "+1 skill rank benefit per seed 2 threshold (base +20, skill-granting aspects)",
          :chart           => summation_chart(2),
          :bonus_amount    => 1,
          :bonus_type      => :ranks,
          :bonus_to        => "skill ranks",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "HP increase (Bear)"                                       => {
          :description     => "+1 HP per seed 1 threshold (base +25 HP, Bear only)",
          :chart           => summation_chart(1),
          :bonus_amount    => 1,
          :bonus_type      => :units,
          :bonus_to        => "HP",
          :bonus_max       => 0,
          :duration        => 0,
          :skill_used      => :spiritual_lore_summoning,
          :repetitions     => 999,
          :repeat_modifier => 0
        },
        "Wall of Thorns enhancement (Porcupine)"                   => {
          :description     => "increases Wall of Thorns (640) block rate and poison effect (Porcupine only, formula NS)",
          :chart           => generic_chart(),
          :bonus_amount    => 0,
          :bonus_type      => :units,
          :bonus_to        => "thorns enhancement",
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
