module Lich
  module Gemstone
    module Spell
      SpellBonuses.table[:major_spiritual] = {
        203 => {
          "increase max mana" => {
            :description     => "increases the consumer's maximum mana",
            :chart           => summation_chart(10),
            :bonus_amount    => 5,
            :bonus_type      => :units,
            :bonus_to        => "max mana",
            :bonus_max       => 50,
            :duration        => 0,
            :skill_used      => :spiritual_lore_blessings,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        },
        206 => {
          "bonus to first aid ranks" => {
            :description     => "provides a bonus to first aid ranks",
            :chart           => summation_chart(2),
            :bonus_amount    => 1,
            :bonus_type      => :ranks,
            :bonus_to        => "first aid ranks",
            :bonus_max       => 0,
            :duration        => 0,
            :skill_used      => :spiritual_lore_blessings,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        },
        209 => {
          "additional web warding chance" => {
            :description     => "persistent effect allowing for a second web warding/manuever attempt",
            :chart           => flat_chart(10),
            :bonus_amount    => 0,
            :bonus_type      => :ability,
            :bonus_to        => "enable",
            :bonus_max       => 0,
            :duration        => 7740, # 2 hours + 60/major spirit rank - this is the minimum time if knowning the spell
            :skill_used      => :spiritual_lore_blessings,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        },
        211 => {
          "enables group version" => {
            :description     => "evoke for a short-duration group version",
            :chart           => flat_chart(25),
            :bonus_amount    => 0,
            :bonus_type      => :ability,
            :bonus_to        => "enable",
            :bonus_max       => 0,
            :duration        => 60,
            :skill_used      => :spiritual_lore_blessings,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        },
        212 => {
          "increase penalty on target TD for follow-ups" => {
            :description     => "increase penalty on target TD for follow-ups",
            :chart           => summation_chart(5),
            :bonus_amount    => -1,
            :bonus_type      => :units,
            :bonus_to        => "target target defensive",
            :bonus_max       => 0,
            :duration        => 0,
            :skill_used      => :spiritual_lore_summoning,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        },
        213 => {
          "increased effectiveness"                => {
            :description     => "increases effectiveness in creating a sanctuary",
            :chart           => generic_chart(1),
            :bonus_amount    => 0,
            :bonus_type      => :units,
            :bonus_to        => "effectiveness",
            :bonus_max       => 0,
            :duration        => 0,
            :skill_used      => :spiritual_lore_summoning,
            :repetitions       => 999,
            :repeat_modifier => 0
          },
          "reduce the failure chance of the spell" => {
            :description     => "reduce the failure chance of the spell",
            :chart           => generic_chart(1),
            :bonus_amount    => 0,
            :bonus_type      => :units,
            :bonus_to        => "effectiveness",
            :bonus_max       => 0,
            :duration        => 0,
            :skill_used      => :spiritual_lore_summoning,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        },
        215 => {
          "enable group version"     => {
            :description     => "enables the EVOKED group version of the spell",
            :chart           => flat_chart(35),
            :bonus_amount    => 0,
            :bonus_type      => :ability,
            :bonus_to        => "enable",
            :bonus_max       => 0,
            :duration        => 60,
            :skill_used      => :spiritual_lore_blessings,
            :repetitions       => 999,
            :repeat_modifier => 0
          },
          "attack strength increase" => {
            :description     => "increases the self-cast AS bonus",
            :chart           => flat_chart(35),
            :bonus_amount    => 1,
            :bonus_type      => :units,
            :bonus_to        => "attack strength",
            :bonus_max       => 0,
            :duration        => 60,
            :skill_used      => :spiritual_lore_blessings,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        },
        216 => {
          "increase TD pushdown" => {
            :description     => "increases TD pushdown on creature",
            :chart           => summation_chart(1),
            :bonus_amount    => -1,
            :bonus_type      => :units,
            :bonus_to        => "target target defensive",
            :bonus_max       => 0,
            :duration        => 0,
            :skill_used      => :spiritual_lore_summoning,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        },
        217 => {
          "increase TD pushdown" => {
            :description     => "increases TD pushdown on targets' TD for spiritual warding spells",
            :chart           => summation_chart(5),
            :bonus_amount    => -1,
            :bonus_type      => :units,
            :bonus_to        => "target target defensive",
            :bonus_max       => 0,
            :duration        => 0,
            :skill_used      => :spiritual_lore_summoning,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        },
        218 => {
          "increase preservation duration to 100 ranks"   => {
            :description     => "increases the duration of Preservation that the Spirit Servant bestows on its caster",
            :chart           => per_x_ranks_chart(1, 0, 100),
            :bonus_amount    => 15,
            :bonus_type      => :time,
            :bonus_to        => "duration",
            :bonus_max       => 0,
            :duration        => 0,
            :skill_used      => :spiritual_lore_summoning,
            :repetitions       => 999,
            :repeat_modifier => 0
          },
          "increase preservation duration over 100 ranks" => {
            :description     => "increases the duration of Preservation that the Spirit Servant bestows on its caster",
            :chart           => per_x_ranks_chart(1, 101, 999),
            :bonus_amount    => 10,
            :bonus_type      => :time,
            :bonus_to        => "duration",
            :bonus_max       => 0,
            :duration        => 0,
            :skill_used      => :spiritual_lore_summoning,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        },
        219 => {
          "enable group version" => {
            :description     => "enables a group version when evoked",
            :chart           => flat_chart(50),
            :bonus_amount    => 0,
            :bonus_type      => :ability,
            :bonus_to        => "affecting group",
            :bonus_max       => 0,
            :duration        => 120,
            :skill_used      => :spiritual_lore_blessings,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        },
        240 => {
          "increase spirit activation chance" => {
            :description     => " increases the chance for the spirit to activate and recast a spell",
            :chart           => summation_chart(1),
            :bonus_amount    => 2,
            :bonus_type      => :percent,
            :bonus_to        => "probability",
            :bonus_max       => 100,
            :duration        => 0,
            :skill_used      => :spiritual_lore_summoning,
            :repetitions       => 999,
            :repeat_modifier => 0
          }
        }
      }
    end
  end
end
