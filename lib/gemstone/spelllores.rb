# requireds template for a lore bonus
# note that spells can have multiple effects
#  GENERIC:                                                                <<-- the spell circle name
#    000:                                                                <<-- the spell number/id
#      "effect name"                                                   <<-- basic name of the effect
#        :description: "described effect/bonus"                      <<-- describes the effect or bonus that is applied
#        :chart: calculation_chart(value)                            <<-- chart/table to reference to determine bonus
#        :bonus_amount: 0                                            <<-- the bonus added per step, based on chart
#        :bonus_type: [percent, ability, units, time, ranks, bonus]  <<-- the type of bonus, i.e. units, percent, effect
#        :bonus_to: UNSPECIFIED                                      <<-- what the bonus actually applies to
#        :bonus_max: 0                                               <<-- maximum bonus capped at, even if theoretically more is possible, 0 is no cap
#        :duration: UNSPECIFIED                                      <<-- duration of the bonus, if applicable, use 0 if not
#        :lore_used: Skills.type_of_lore                             <<-- lore to calculate off, Skills.to_bonus(:type_of_lore) for bonus instead of ranks
#        :repetions: 999                                             <<-- number of times the ability can repeat, use 999 for infinite
#        :repeat_modifier: 0                                         <<-- % modifier of chance to recur bonus

=begin
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
=end

module Lich
  module Gemstone
    module SpellLoreBonuses
      #####
      ### Calculation Tables
      #####
      def self.summation_chart(seed)
        # TODO
      end

      def self.flat_chart(value)
        # TODO  bonus is active at value
      end

      def self.divide_truncate_chart(divisor)
        # TODO   lore_used/divisor
      end

      def self.damage_factor_chart(value)
        # TODO   1-50 gives + each step;  51-100 gives +1 every 2nd step; 101-200 +1 every 4th step
      end

      def ball_spell_chart()
        # TODO   (1 + SQRT (8 * ranks - 7))/2
      end

      def self.fixed_spacing_chart(value)
        # TODO   value is string array of #s for lore_used
      end

      def self.per_x_ranks_chart(per_rank, starting_rank, ending_rank)
        # TODO  Increase is given every value ranks.
        # use 999 for no ending rank
      end

      def self.generic_chart(value)
        # TODO  unspecified bonus
      end
    end
  end
end
