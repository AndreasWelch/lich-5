
module Lich
    module Gemstone
        module SpellLoreBonuses
            SpellLoreBonuses.table[:cleric_base] = {
                000 => {
                    "effect" => {
                        :description        => "",
                        :chart              => chart_function(),
                        :bonus_amount       => 0,
                        :bonus_type         => "",
                        :bonus_to           => "",
                        :bonus_max          => 0,
                        :duration           => 0,
                        :lore_used          => Skills.type_of_lore,
                        :repetions          => 999,
                        :repeat_modifier    => 0
                    }
                },
                001 => {
                    "effect" => {
                        :description        => "",
                        :chart              => chart_function(),
                        :bonus_amount       => 0,
                        :bonus_type         => "",
                        :bonus_to           => "",
                        :bonus_max          => 0,
                        :duration           => 0,
                        :lore_used          => Skills.type_of_lore,
                        :repetions          => 999,
                        :repeat_modifier    => 0
                    }
                }
            }
        end
    end
end