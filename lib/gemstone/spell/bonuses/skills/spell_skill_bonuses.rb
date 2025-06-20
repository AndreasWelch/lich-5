
# required template for a lore bonus
# note that spells can have multiple effects
#  GENERIC:                                                          <<-- the spell circle name
#    000:                                                            <<-- the spell number/id
#      "effect name"                                                 <<-- basic name of the effect
#        :description: "described effect/bonus"                      <<-- describes the effect or bonus that is applied
#        :chart: calculation_chart(value)                            <<-- chart/table to reference to determine bonus
#        :bonus_amount: 0                                            <<-- the bonus added per step, based on chart
#        :bonus_type: [percent, ability, units, time, ranks, bonus]  <<-- the type of bonus, i.e. units, percent, effect
#        :bonus_to: UNSPECIFIED                                      <<-- what the bonus actually applies to
#        :bonus_max: 0                                               <<-- maximum bonus capped at, even if theoretically more is possible, 0 is no cap
#        :duration: UNSPECIFIED                                      <<-- duration of the bonus, if applicable, use 0 if not
#        :lore_used: Skills.type_of_skill                            <<-- lore to calculate off, Skills.to_bonus(:type_of_skill) for bonus instead of ranks
#        :repetions: 999                                             <<-- number of times the ability can repeat, use 999 for infinite
#        :repeat_modifier: 0                                         <<-- % modifier of chance to recur bonus

require_relative 'spell/bonuses/skills/arcane_skill_bonuses'
require_relative 'spell/bonuses/skills/bard_base_skill_bonuses'
require_relative 'spell/bonuses/skills/cleric_base_skill_bonuses'
require_relative 'spell/bonuses/skills/empathic_skill_bonuses'
require_relative 'spell/bonuses/skills/major_elemental_skill_bonuses'
require_relative 'spell/bonuses/skills/major_mental_skill_bonuses'
require_relative 'spell/bonuses/skills/major_spiritual_skill_bonuses'
require_relative 'spell/bonuses/skills/minor_elemental_skill_bonuses'
require_relative 'spell/bonuses/skills/minor_mental_skill_bonuses'
require_relative 'spell/bonuses/skills/minor_spiritual_skill_bonuses'
require_relative 'spell/bonuses/skills/paladin_skill_bonuses'
require_relative 'spell/bonuses/skills/ranger_base_skill_bonuses'
require_relative 'spell/bonuses/skills/savant_base_skill_bonuses'
require_relative 'spell/bonuses/skills/sorcerer_base_skill_bonuses'
require_relative 'spell/bonuses/skills/wizard_base_skill_bonuses'

include Lich::Util::ChartCalculator

module Lich
  module Gemstone
    module Spell
      module Bonuses
        module Skills
          # This module contains skill bonuses for spells.

          # Currently, it does not contain any specific functionality.
        end
      end
    end
  end
end
