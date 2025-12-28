module Lich
  module Gemstone
    module Spell
      SpellBonuses.table[:cleric_base] = {
        000 => {
          "effect" => {
            :description     => "",
            :chart           => chart_function(),
            :bonus_amount    => 0,
            :bonus_type      => "",
            :bonus_to        => "",
            :bonus_max       => 0,
            :duration        => 0,
            :skill_used      => :type_of_lore,
            :repetitions     => 999,
            :repeat_modifier => 0
          }
        },
        001 => {
          "effect" => {
            :description     => "",
            :chart           => chart_function(),
            :bonus_amount    => 0,
            :bonus_type      => "",
            :bonus_to        => "",
            :bonus_max       => 0,
            :duration        => 0,
            :skill_used      => :type_of_lore,
            :repetitions     => 999,
            :repeat_modifier => 0
          }
        }
      }
    end
  end
end
