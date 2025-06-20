module Lich
  module Gemstone
    module Spell
      module Bonuses
        module Skills
          SpellSkillBonuses.table[:arcane] = {
            000 => {
              "effect" => {
                :description     => "",
                :bonus_amount    => 0,
                :bonus_type      => "",
                :bonus_to        => "",
                :chart           => chart_function,
                :duration        => 0,
                :skill_used      => Skills.type_of_skill,
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
                :chart           => chart_function,
                :duration        => 0,
                :skill_used      => Skills.type_of_skill,
                :repetions       => 999,
                :repeat_modifier => 0
              }
            }
          }
        end
      end
    end
  end
end
