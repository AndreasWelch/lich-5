module Lich
  module Gemstone
    module Spell
      SpellBonuses.table[:minor_mental] = {
        000 => {
          "effect" => {
            :description     => "",
            :bonus_amount    => 0,
            :bonus_type      => "",
            :bonus_to        => "",
            :chart           => chart_function(),
            :duration        => 0,
            :skill_used      => :type_of_lore,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        },
        001 => {
          "effect" => {
            :description     => "",
            :bonus_amount    => 0,
            :bonus_type      => "",
            :bonus_to        => "",
            :chart           => chart_function(),
            :duration        => 0,
            :skill_used      => :type_of_lore,
            :repetions       => 999,
            :repeat_modifier => 0
          }
        }
      }
    end
  end
end
