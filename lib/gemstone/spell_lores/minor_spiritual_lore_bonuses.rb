module Lich
  module Gemstone
    module SpellLoreBonuses
      SpellLoreBonuses.table[:minor_spiritual] = {
        104 => {
          "increased disesase resistance" => {
            :description     => "resistance bonus on second warding attempt by +2",
            :chart           => summation_chart(1),
            :bonus_amount    => 2,
            :bonus_type      => "units",
            :bonus_to        => "Char.TD",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_blessings,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        105 => {
          "increased poison resistance" => {
            :description     => "resistance bonus on second warding attempt by +2",
            :chart           => summation_chart(1),
            :bonus_amount    => 2,
            :bonus_type      => "units",
            :bonus_to        => "Char.TD",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_blessings,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        106 => {
          "enable concealing fog" => {
            :description     => "conceal the caster on cast and allow hiding in",
            :chart           => flat_chart(40),
            :bonus_amount    => 0,
            :bonus_type      => "ability",
            :bonus_to        => "enable",
            :bonus_max       => 0,
            :duration        => 30,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        107 => {
          "temporary warding bonus chance" => {
            :description     => "chance to temporarily gain a +25 boost in warding attempt",
            :chart           => summation_chart(10),
            :bonus_amount    => 1,
            :bonus_type      => "percent",
            :bonus_to        => "effect",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_blessings,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        110 => {
          "second target chance" => {
            :description     => "chance to affect a second target in the room",
            :chart           => divide_truncate_chart(2),
            :bonus_amount    => 1,
            :bonus_type      => "percent",
            :bonus_to        => "additional targets",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.to_bonus(:spiritual_lore_summoning),
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        111 => {
          "additional damage factor"            => {
            :description     => "increased damage factor 1-50 by 0.001/rank, 50-100 by 0.001/2 ranks, 101 to 200 by 0.001/4 ranks truncated at 3 decimals",
            :chart           => damage_factor_chart(1),
            :bonus_amount    => 0.001,
            :bonus_type      => "units",
            :bonus_to        => "Spell DF",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          },
          "additional potential splash targets" => {
            :description     => "increase potential splash targets",
            :chart           => ball_spell_chart(),
            :bonus_amount    => 1,
            :bonus_type      => "units",
            :bonus_to        => "additional targets",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        115 => {
          "additional percentage chance of activation" => {
            :description     => "increases the percentage chance of activation",
            :chart           => summation_chart(1),
            :bonus_amount    => 10,
            :bonus_type      => "percent",
            :bonus_to        => "activation chance",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_blessings,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        116 => {
          "enable adjacent realm range"      => {
            :description     => "the caster can view targets in adjacent realms",
            :chart           => flat_chart(30),
            :bonus_amount    => 1,
            :bonus_type      => "unit",
            :bonus_to        => "distance",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          },
          "enable trace back"                => {
            :description     => "the caster can identify the origin of a locate in their room",
            :chart           => flat_chart(30),
            :bonus_amount    => 0,
            :bonus_type      => "ability",
            :bonus_to        => "enable",
            :bonus_max       => 0,
            :duration        => 30,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          },
          "enable near-adjacent realm range" => {
            :description     => "the caster can view targets in near-adjacent realms",
            :chart           => flat_chart(60),
            :bonus_amount    => 1,
            :bonus_type      => "unit",
            :bonus_to        => "distance",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          },
          "enable far realms range"          => {
            :description     => "the caster can view targets in far realms",
            :chart           => flat_chart(90),
            :bonus_amount    => 1,
            :bonus_type      => "unit",
            :bonus_to        => "distance",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        117 => {
          "enable and increase chance to remain active" => {
            :description     => "allows for a chance for the spell to remain active for an additional attack",
            :chart           => summation_chart(5),
            :bonus_amount    => 3,
            :bonus_type      => "percent",
            :bonus_to        => "quantity",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_blessings,
            :repetions       => 999,
            :repeat_modifier => -50
          }
        },
        118 => {
          "enable bolt version"                                      => {
            :description     => "the spell may be EVOKED or CHANNELED for bolt version",
            :chart           => flat_chart(20),
            :bonus_amount    => 0,
            :bonus_type      => "ability",
            :bonus_to        => "enable",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          },
          "open cast area version additional ensnare charges"        => {
            :description     => "additional ensnare chances for the open cast version (base 2)",
            :chart           => fixed_spacing("5,15,30,50,75,105,140,180"),
            :bonus_type      => "activations",
            :bonus_amount    => 1,
            :bonus_to        => "quantity",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skill.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          },
          "bolt version additional chance to apply webbed condition" => {
            :description     => "additional percent chance to apply webbed condition to target",
            :chart           => divide_truncate_chart(2),
            :bonus_amount    => 1,
            :bonus_type      => "percent",
            :bonus_to        => "chance",
            :bonus_max       => 0,
            :durcation       => 0,
            :lore_used       => Skill.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          },
          "bolt version additional damage factor"                    => {
            :description     => "increased damage factor 1-50 by 0.001/rank, 50-100 by 0.001/2 ranks, 101 to 200 by 0.001/4 ranks truncated at 3 decimals",
            :chart           => damage_factor_chart(1),
            :bonus_amount    => 0.001,
            :bonus_type      => "units",
            :bonus_to        => "Spell DF",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        120 => {
          "enable casting on others" => {
            :description     => "allow for the casting on others (remove self-only restriction)",
            :chart           => flat_chart(60),
            :bonus_amount    => 0,
            :bonus_type      => "ability",
            :bonus_to        => "enable",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_blessings,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        125 => {
          "rangers with 625: enable indoor casting" => {
            :description     => "allow casting indoors for rangers with 625 active",
            :chart           => flat_chart(40),
            :bonus_amount    => 0,
            :bonus_type      => "ability",
            :bonus_to        => "enable",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          },
          "everyone: enable indoor casting"         => {
            :description     => "allow casting indoors for everyone",
            :chart           => flat_chart(80),
            :bonus_amount    => 0,
            :bonus_type      => "ability",
            :bonus_to        => "enable",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          },
          "reduce buildup time"                     => {
            :description     => "reduce the time needed to buildup the cloud",
            :chart           => fixed_spacing("10,20,30,40,50,60,70"),
            :bonus_amount    => -4,
            :bonus_type      => "time",
            :bonus_to        => "duration",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        130 => {
          "decrease random range of the landing location" => {
            :description     => "reduces the random range of the landing location",
            :chart           => divide_truncate_chart(summation_chart(10)),
            :bonus_amount    => 0,
            :bonus_type      => "units",
            :bonus_to        => "deviation range",
            :bonus_max       => 0,
            :duration        => 0,
            :lore_used       => Skills.spiritual_lore_summoning,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        }
      }
    end
  end
end
