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
      class LoreBonusCalculator
        @@precomputed_summation_charts = {}
        @@precomputed_flat_charts = {}
        @@precomputed_divide_truncate_charts = {}
        @@precomputed_damage_factor_charts = {}
        @@precomputed_ball_charts = {}
        @@precomputed_per_x_ranks_charts = {}
        @@precomputed_fixed_spacing_charts = {}

        ##
        # Generates a summation chart mapping lore ranks to bonuses, or a compact grouped version.
        #
        # By default, returns a full hash of rank => bonus.
        # If `format: :compact` is passed, it returns a grouped hash of bonus => [ranks...].
        #
        # Uses the summation formula from GSWiki:
        #   bonus = floor((√(8 × ranks + (seed²)) − seed) / 2)
        #
        # @param [Integer] seed The seed multiplier used to determine bonus progression.
        # @param [Integer] max_rank The maximum rank to calculate (default: 400).
        # @param [Symbol] format The output format (`:standard` or `:compact`), default is `:standard`.
        # @return [Hash{Integer => Integer}] or [Hash{Integer => Array<Integer>}] depending on format.
        #
        # @example Standard output
        #   LoreBonusCalculator.summation_chart(1)[55]   # => 10
        #
        # @example Compact output
        #   LoreBonusCalculator.summation_chart(1, 100, format: :compact)
        #   # => { 1 => [1,2], 2 => [3,4,5], 3 => [6,7,8,9], ... }
        #
        # @see https://gswiki.play.net/Summation_chart
        def self.summation_chart(seed, max_rank = 400, format: :standard)
          raise ArgumentError, "Seed must be a positive integer" unless seed.is_a?(Integer) && seed > 0
          raise ArgumentError, "Max rank must be a positive integer" unless max_rank.is_a?(Integer) && max_rank > 0

          @@precomputed_summation_charts ||= {}

          @@precomputed_summation_charts[seed] ||= (1..400).each_with_object({}) do |ranks, hash|
            hash[ranks] = summation_bonus(ranks, seed)
          end

          chart = @@precomputed_summation_charts[seed].dup

          if format == :compact
            # Reformat: group ranks by shared bonus value
            chart.each_with_object(Hash.new { |h, k| h[k] = [] }) do |(rank, bonus), grouped|
              grouped[bonus] << rank
            end
          else
            chart
          end
        end

        ##
        # Calculates the summation-based bonus earned from a given number of lore ranks and seed.
        #
        # Uses the inverse triangular formula described on GSWiki:
        #   bonus = floor((√(8 × ranks + (seed²)) − seed) / 2)
        #
        # @param [Integer] seed The seed value required per bonus point (e.g. 5 ranks per +1 bonus).
        # @param [Integer] ranks The number of lore ranks trained.
        # @return [Integer] The total bonus value earned from the given ranks and seed.
        #
        # @example
        #   LoreBonusCalculator.summation_bonus(1, 55)  # => 10
        #   LoreBonusCalculator.summation_bonus(1, 1)   # => 1
        #   LoreBonusCalculator.summation_bonus(1, 400) # => 28
        #
        # @see https://gswiki.play.net/Summation_chart
        def self.summation_bonus(seed, ranks)
          raise ArgumentError, "Ranks and seed must be positive integers" unless ranks.is_a?(Integer) && seed.is_a?(Integer) && ranks > 0 && seed > 0

          Math.sqrt(8 * ranks + seed * seed).then { |root| ((root - seed) / 2).floor }
        end

        ##
        # Calculates the next rank threshold at which the summation bonus will increase,
        # given the current number of ranks and a seed value.
        #
        # It determines the current bonus using the summation formula, then
        # finds the next rank at which the bonus would increment.
        #
        # @param [Integer] current_ranks The current number of lore ranks.
        # @param [Integer] seed The seed multiplier used in the summation chart.
        # @return [Integer] The rank at which the next bonus point is earned.
        #
        # @example
        #   LoreBonusCalculator.next_summation_bonus_rank(55, 1)  # => 56
        #   LoreBonusCalculator.next_summation_bonus_rank(28, 1)  # => 36
        #
        # @see https://gswiki.play.net/Summation_chart
        def self.next_summation_bonus_rank(current_ranks, seed)
          raise ArgumentError, "Ranks and seed must be positive integers" unless current_ranks.is_a?(Integer) && seed.is_a?(Integer) && current_ranks > 0 && seed > 0

          current_bonus = summation_bonus(current_ranks, seed)

          # Linear search for the next rank where the bonus increases
          (current_ranks + 1).upto(400) do |r|
            return r if summation_bonus(r, seed) > current_bonus
          end

          nil # No further bonus found within 400 ranks
        end

        ##
        # Returns a flat bonus chart where every rank (1–400) maps to the same constant bonus value.
        #
        # Uses internal caching keyed by value, and returns a duplicate to prevent mutation.
        #
        # @param [Integer] value The flat bonus value to apply at every rank.
        # @return [Hash{Integer => Integer}] A chart mapping each rank to the same flat bonus.
        #
        # @example
        #   LoreBonusCalculator.flat_chart(10)
        #   # => { 1 => 10, 2 => 10, ..., 400 => 10 }
        def self.flat_chart(value)
          return {} unless value.is_a?(Integer)

          @@precomputed_flat_charts[value] ||= (1..400).each_with_object({}) do |rank, chart|
            chart[rank] = value
          end

          @@precomputed_flat_charts[value].dup
        end

        ##
        # Returns a chart where the bonus increases by 1 for every multiple of the given divisor.
        #
        # Example: a divisor of 5 gives a bonus of 1 at rank 5, 2 at rank 10, etc.
        # Caches results by divisor and returns a duplicate to prevent mutation.
        #
        # @param [Integer] divisor The number of ranks required to gain +1 bonus.
        # @return [Hash{Integer => Integer}] A chart mapping each rank to a bonus scaled by divisor.
        #
        # @example
        #   LoreBonusCalculator.divide_truncate_chart(10)[37]  # => 3
        def self.divide_truncate_chart(divisor)
          return {} unless divisor.is_a?(Integer) && divisor > 0

          @@precomputed_divide_truncate_charts[divisor] ||= (1..400).each_with_object({}) do |rank, chart|
            chart[rank] = (rank / divisor.to_f).floor
          end

          @@precomputed_divide_truncate_charts[divisor].dup
        end

        ##
        # Returns a chart representing damage factor scaling based on lore ranks.
        #
        # Scaling logic:
        # - 1–50:   +1 per rank (linear)
        # - 51–100: +1 per 2 ranks (i.e. +25 more)
        # - 101–200: +1 per 4 ranks (i.e. +25 more)
        # - 201+:   capped at +100 bonus
        #
        # Caches charts by initial value and returns a duplicate to prevent mutation.
        #
        # @param [Integer] value The starting bonus value (typically 1 or more).
        # @return [Hash{Integer => Integer}] A chart mapping each rank to its scaled bonus.
        #
        # @example
        #   LoreBonusCalculator.damage_factor_chart(1)[125]  # => 81
        def self.damage_factor_chart(value)
          return {} unless value.is_a?(Integer) && value > 0

          @@precomputed_damage_factor_charts[value] ||= (1..400).each_with_object({}) do |rank, chart|
            bonus = if rank <= 50
                      rank
                    elsif rank <= 100
                      50 + ((rank - 50) / 2)
                    elsif rank <= 200
                      75 + ((rank - 100) / 4)
                    else
                      100
                    end

            chart[rank] = bonus
          end

          @@precomputed_damage_factor_charts[value].dup
        end

        ##
        # Returns a chart for ball spell progression bonuses based on lore ranks.
        #
        # Formula (from GSWiki):
        #   bonus = floor((1 + sqrt(8 × ranks − 7)) / 2)
        #
        # Used to calculate number of projectiles or additional targets for ball spells.
        # Result is cached and returned as a duplicate to prevent mutation.
        #
        # @return [Hash{Integer => Integer}] A chart mapping each rank to the calculated bonus.
        #
        # @example
        #   LoreBonusCalculator.ball_spell_chart[55]  # => 10
        #
        # @see https://gswiki.play.net/Major_Earth
        def self.ball_spell_chart
          @@precomputed_ball_charts ||= {}

          @@precomputed_ball_charts[:default] ||= (1..400).each_with_object({}) do |ranks, chart|
            bonus = Math.sqrt(8 * ranks - 7)
            chart[ranks] = ((1 + bonus) / 2).floor
          end

          @@precomputed_ball_charts[:default].dup
        end

        ##
        # Returns a chart where the bonus increases by 1 each time the rank crosses one of the given thresholds.
        #
        # Thresholds should be an array of integer ranks where the bonus increases by +1 at each point.
        # The thresholds do not need to be sorted — sorting is done internally.
        # Result is cached and returned as a duplicate.
        #
        # @param [Array<Integer>] thresholds Array of rank thresholds for increasing bonuses.
        # @return [Hash{Integer => Integer}] A chart mapping each rank to the total earned bonus.
        #
        # @example
        #   LoreBonusCalculator.fixed_spacing_chart([5, 15, 30, 60])[45]  # => 3
        def self.fixed_spacing_chart(thresholds)
          return {} unless thresholds.is_a?(Array) && thresholds.all? { |r| r.is_a?(Integer) && r > 0 }

          @@precomputed_fixed_spacing_charts ||= {}
          sorted = thresholds.sort
          key = sorted.join(",")

          @@precomputed_fixed_spacing_charts[key] ||= (1..400).each_with_object({}) do |rank, chart|
            chart[rank] = sorted.count { |t| rank >= t }
          end

          @@precomputed_fixed_spacing_charts[key].dup
        end

        ##
        # Returns a chart where the bonus increases by 1 every `per_rank` steps
        # between `starting_rank` and `ending_rank`.
        #
        # Useful for effects like: "Gain +1 every 20 ranks, starting at 10, ending at 100."
        # The final bonus is capped unless `ending_rank` is 999 (meaning uncapped).
        # Result is cached and returned as a duplicate.
        #
        # @param [Integer] per_rank Number of ranks required per bonus increment.
        # @param [Integer] starting_rank Rank at which bonus calculation begins.
        # @param [Integer] ending_rank Final rank at which the bonus stops increasing (use 999 for uncapped).
        # @return [Hash{Integer => Integer}] A chart mapping each rank to its incremental bonus.
        #
        # @example
        #   LoreBonusCalculator.per_x_ranks_chart(20, 10, 100)[90]  # => 4
        def self.per_x_ranks_chart(per_rank, starting_rank, ending_rank)
          return {} unless [per_rank, starting_rank, ending_rank].all? { |n| n.is_a?(Integer) && n >= 0 }

          @@precomputed_per_x_ranks_charts ||= {}
          key = [per_rank, starting_rank, ending_rank]

          @@precomputed_per_x_ranks_charts[key] ||= (1..400).each_with_object({}) do |rank, chart|
            if rank < starting_rank
              chart[rank] = 0
            elsif rank > ending_rank && ending_rank != 999
              chart[rank] = ((ending_rank - starting_rank) / per_rank.to_f).floor
            else
              chart[rank] = ((rank - starting_rank) / per_rank.to_f).floor
            end
          end

          @@precomputed_per_x_ranks_charts[key].dup
        end

        ##
        # Returns a generic fallback chart where all ranks receive a bonus of 0.
        #
        # This chart is used when a spell effect has no scaling bonus,
        # or the actual bonus is undefined or handled externally.
        #
        # Result is cached and returned as a duplicate to prevent mutation.
        #
        # @return [Hash{Integer => Integer}] A chart mapping each rank to 0.
        #
        # @example
        #   LoreBonusCalculator.generic_chart[150]  # => 0
        def self.generic_chart
          @@precomputed_generic_chart ||= (1..400).each_with_object({}) do |rank, chart|
            chart[rank] = 0
          end

          @@precomputed_generic_chart.dup
        end
      end
    end
  end
end
