module Lich
  module Util
    ##
    # ChartCalculator provides various static methods for generating
    # rank-to-bonus charts used in areas like training bonus evaluations.
    #
    # All methods return a `Hash{Integer => Numeric}` mapping training
    # ranks (1 to 400) to the effective bonus granted.
    #
    # Bonus curves include summation-based, flat-rate, per-x-rank, and
    # specialized formulas for things like damage factors and ball spells.
    #
    # Caching is used internally to reduce redundant computation, and charts
    # are returned as `.dup` to avoid mutation.
    #
    # @see https://gswiki.play.net/Summation_chart
    #
    class ChartCalculator
      UNCAPPED_RANK = 999

      @@cached_summation_charts = {}
      @@cached_flat_charts = {}
      @@cached_divide_truncate_charts = {}
      @@cached_damage_factor_charts = {}
      @@cached_ball_charts = {}
      @@cached_per_x_ranks_charts = {}
      @@cached_fixed_spacing_charts = {}
      @@cached_base_plus_per_ranks_charts = {}

      ##
      # Generates a summation chart mapping ranks (1 to 400) to bonuses, or a compact grouped version.
      #
      # By default, returns a full hash of rank => bonus.
      # If `format: :compact` is passed, it returns a grouped hash of bonus => [ranks...].
      #
      # Uses the summation formula from GSWiki:
      #   bonus = floor((√(8 × ranks + (seed²)) − seed) / 2)
      #
      # This creates a diminishing returns curve — higher seeds cause bonuses to increase more slowly.
      #
      # @param [Integer] seed The seed spacing used to determine bonus progression (must be > 0).
      # @param [Symbol] format The output format (`:standard` or `:compact`). Default is `:standard`.
      # @return [Hash{Integer => Integer}] when `format: :standard`
      # @return [Hash{Integer => Array<Integer>}] when `format: :compact`
      #
      # @example Standard output (rank => bonus)
      #   ChartCalculator.summation_chart(1)[55]   # => 10
      #
      # @example Compact output (bonus => [ranks...])
      #   ChartCalculator.summation_chart(1, format: :compact)
      #   # => { 1 => [1, 2], 2 => [3, 4, 5], 3 => [6, 7, 8, 9], ... }
      #
      # @see https://gswiki.play.net/Summation_chart
      def self.summation_chart(seed, format: :standard)
        raise ArgumentError, "Seed must be a positive integer" unless seed.is_a?(Integer) && seed > 0

        @@cached_summation_charts[seed] ||= (1..400).each_with_object({}) do |ranks, chart|
          chart[ranks] = summation_bonus(seed, ranks)
        end

        chart = @@cached_summation_charts[seed].dup

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
      # Returns a flat bonus chart where every rank (1–400) maps to the same constant bonus value.
      #
      # Uses internal caching keyed by value, and returns a duplicate to prevent mutation.
      #
      # @param [Integer] value The flat bonus value to apply at every rank.
      # @return [Hash{Integer => Integer}] A chart mapping each rank to the same flat bonus.
      #
      # @example
      #   ChartCalculator.flat_chart(10)
      #   # => { 1 => 10, 2 => 10, ..., 400 => 10 }
      def self.flat_chart(value)
        return {} unless value.is_a?(Integer)

        @@cached_flat_charts[value] ||= (1..400).each_with_object({}) do |rank, chart|
          chart[rank] = value
        end

        @@cached_flat_charts[value].dup
      end

      ##
      # Returns a chart where the bonus increases by 1 for every multiple of the given divisor.
      #
      # Example: a divisor of 5 gives a bonus of 1 at rank 5, 2 at rank 10, etc.
      # Accepts both integer and float divisors for fine-grained progression control.
      # Caches results by divisor and returns a duplicate to prevent mutation.
      #
      # @param [Numeric] divisor The number of ranks required to gain +1 bonus (integer or float).
      # @return [Hash{Integer => Integer}] A chart mapping each rank to a bonus scaled by divisor.
      #
      # @example
      #   ChartCalculator.divide_truncate_chart(10)[37]  # => 3
      #   ChartCalculator.divide_truncate_chart(1.5)[15] # => 10
      def self.divide_truncate_chart(divisor)
        return {} unless divisor.is_a?(Numeric) && divisor > 0

        @@cached_divide_truncate_charts[divisor] ||= (1..400).each_with_object({}) do |rank, chart|
          chart[rank] = (rank / divisor.to_f).floor
        end

        @@cached_divide_truncate_charts[divisor].dup
      end

      ##
      # Returns a chart representing damage factor scaling based on ranks.
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
      #   ChartCalculator.damage_factor_chart(1)[125]  # => 81
      def self.damage_factor_chart(value)
        return {} unless value.is_a?(Integer) && value > 0

        @@cached_damage_factor_charts[value] ||= (1..400).each_with_object({}) do |rank, chart|
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

        @@cached_damage_factor_charts[value].dup
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
      #   ChartCalculator.ball_spell_chart[55]  # => 10
      #
      # @see https://gswiki.play.net/Major_Earth
      def self.ball_spell_chart
        @@cached_ball_charts[:default] ||= (1..400).each_with_object({}) do |ranks, chart|
          bonus = Math.sqrt(8 * ranks - 7)
          chart[ranks] = ((1 + bonus) / 2).floor
        end

        @@cached_ball_charts[:default].dup
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
      #   ChartCalculator.fixed_spacing_chart([5, 15, 30, 60])[45]  # => 3
      def self.fixed_spacing_chart(thresholds)
        return {} unless thresholds.is_a?(Array) && thresholds.all? { |r| r.is_a?(Integer) && r > 0 }

        sorted = thresholds.sort
        key = sorted.join(",")

        @@cached_fixed_spacing_charts[key] ||= (1..400).each_with_object({}) do |rank, chart|
          chart[rank] = sorted.count { |t| rank >= t }
        end

        @@cached_fixed_spacing_charts[key].dup
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
      #   ChartCalculator.per_x_ranks_chart(20, 10, 100)[90]  # => 4
      def self.per_x_ranks_chart(per_rank, starting_rank, ending_rank)
        return {} unless [per_rank, starting_rank, ending_rank].all? { |n| n.is_a?(Integer) && n >= 0 }

        key = [per_rank, starting_rank, ending_rank]

        @@cached_per_x_ranks_charts[key] ||= (1..400).each_with_object({}) do |rank, chart|
          if rank < starting_rank
            chart[rank] = 0
          elsif rank > ending_rank && ending_rank != UNCAPPED_RANK
            chart[rank] = ((ending_rank - starting_rank) / per_rank.to_f).floor
          else
            chart[rank] = ((rank - starting_rank) / per_rank.to_f).floor
          end
        end

        @@cached_per_x_ranks_charts[key].dup
      end

      ##
      # Returns a chart generated by a custom formula block.
      #
      # Allows arbitrary calculations to be applied to each rank (1-400).
      # The block receives the rank as a parameter and should return the calculated bonus.
      #
      # Note: This function is NOT cached. Use sparingly for truly unique cases.
      # If the formula becomes common, consider adding a dedicated chart function.
      #
      # @param [Proc] block A block that receives rank and returns the bonus value.
      # @return [Hash{Integer => Numeric}] A chart mapping each rank to the calculated bonus.
      #
      # @example Simple formula
      #   ChartCalculator.custom_formula_chart { |ranks| (ranks * 2) + (ranks / 10).floor }
      #
      # @example Conditional formula
      #   ChartCalculator.custom_formula_chart { |ranks| ranks < 50 ? ranks : 50 + (ranks - 50) / 2 }
      #
      # @example Math operations
      #   ChartCalculator.custom_formula_chart { |ranks| (ranks ** 0.5 * 3).floor }
      def self.custom_formula_chart(&block)
        return {} unless block_given?

        (1..400).each_with_object({}) do |rank, chart|
          chart[rank] = block.call(rank)
        end
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
      #   ChartCalculator.generic_chart[150]  # => 0
      def self.generic_chart
        @@cached_generic_chart ||= (1..400).each_with_object({}) do |rank, chart|
          chart[rank] = 0
        end

        @@cached_generic_chart.dup
      end

      ##
      # Given a base chart (Hash{rank => bonus}), returns a new chart where each bonus
      # is divided by a constant and truncated.
      #
      # @param [Hash{Integer => Integer}] base_chart The original chart to transform.
      # @param [Integer] divisor The divisor to apply.
      # @return [Hash{Integer => Integer}] A new chart with bonuses divided and floored.
      #
      # @example
      #   base = ChartCalculator.summation_chart(10)
      #   ChartCalculator.divide_truncate_chart_from(base, 2)[100]  # => floor(base[100] / 2)
      def self.divide_truncate_chart_from(base_chart, divisor)
        return {} unless divisor.is_a?(Integer) && divisor > 0
        return {} unless base_chart.is_a?(Hash)

        base_chart.each_with_object({}) do |(rank, value), chart|
          chart[rank] = (value / divisor.to_f).floor
        end
      end

      ##
      # Calculates the next rank threshold at which the summation bonus will increase,
      # given the current number of ranks and a seed value.
      #
      # It determines the current bonus using the cached summation chart, then
      # scans forward in that chart to find the next rank with a higher bonus.
      #
      # @param [Integer] current_ranks The current number of lore ranks.
      # @param [Integer] seed The seed multiplier used in the summation chart.
      # @return [Integer, nil] The rank at which the next bonus point is earned, or nil if none found.
      #
      # @example
      #   ChartCalculator.next_summation_bonus_rank(55, 1)  # => 56
      #   ChartCalculator.next_summation_bonus_rank(28, 1)  # => 36
      #
      # @see https://gswiki.play.net/Summation_chart
      def self.next_summation_bonus_rank(current_ranks, seed)
        raise ArgumentError, "Ranks and seed must be positive integers" unless current_ranks.is_a?(Integer) && seed.is_a?(Integer) && current_ranks > 0 && seed > 0

        chart = summation_chart(seed)
        current_bonus = chart[current_ranks]

        ((current_ranks + 1)..400).each do |r|
          return r if chart[r] > current_bonus
        end

        nil # No further bonus found within 400 ranks
      end

      ##
      # Calculates the summation-based bonus earned from a given number of ranks and seed.
      #
      # This method first checks if the full summation chart has already been computed
      # for the given seed and returns the cached value. If not, it performs the math directly.
      #
      # @param [Integer] seed The seed value required per bonus point (e.g. 5 ranks per +1 bonus).
      # @param [Integer] ranks The number of ranks trained.
      # @return [Integer] The total bonus value earned from the given ranks and seed.
      #
      # @example
      #   ChartCalculator.summation_bonus(1, 55)  # => 10
      def self.summation_bonus(seed, ranks)
        raise ArgumentError, "Ranks and seed must be positive integers" unless ranks.is_a?(Integer) && seed.is_a?(Integer) && ranks > 0 && seed > 0

        if @@cached_summation_charts[seed]
          @@cached_summation_charts[seed][ranks]
        else
          Math.sqrt(8 * ranks + seed * seed).then { |root| ((root - seed) / 2).floor }
        end
      end

      ##
      # Returns a chart with a base bonus that increases incrementally every X ranks after a starting threshold.
      #
      # This provides a "base + incremental" progression:
      # - Below `start_rank`: 0 bonus
      # - At and above `start_rank`: `base_bonus + floor((rank - start_rank) / per_rank) * bonus_per_threshold`
      #
      # Useful for effects like: "Base +10, then +5 every 20 ranks starting at rank 50"
      #
      # Result is cached and returned as a duplicate to prevent mutation.
      #
      # @param [Integer] start_rank The rank at which bonuses begin (0 bonus below this).
      # @param [Integer] base_bonus The initial bonus granted at start_rank.
      # @param [Integer] per_rank Number of ranks required for each additional bonus increment.
      # @param [Integer] bonus_per_threshold The bonus amount added for each threshold passed (default: 1).
      # @return [Hash{Integer => Integer}] A chart mapping each rank to its calculated bonus.
      #
      # @example Base 10, +1 every 5 ranks starting at rank 25
      #   ChartCalculator.base_plus_per_ranks_chart(25, 10, 5, 1)
      #   # Rank 24 => 0, Rank 25 => 10, Rank 30 => 11, Rank 50 => 15
      #
      # @example Base 20, +5 every 10 ranks starting at rank 10
      #   ChartCalculator.base_plus_per_ranks_chart(10, 20, 10, 5)
      #   # Rank 9 => 0, Rank 10 => 20, Rank 20 => 25, Rank 50 => 40
      def self.base_plus_per_ranks_chart(start_rank, base_bonus, per_rank, bonus_per_threshold)
        return {} unless [start_rank, base_bonus, per_rank, bonus_per_threshold].all? { |n| n.is_a?(Integer) && n >= 0 }

        key = [start_rank, base_bonus, per_rank, bonus_per_threshold]

        @@cached_base_plus_per_ranks_charts[key] ||= (1..400).each_with_object({}) do |rank, chart|
          if rank < start_rank
            chart[rank] = 0
          else
            thresholds_passed = ((rank - start_rank) / per_rank.to_f).floor
            chart[rank] = base_bonus + (thresholds_passed * bonus_per_threshold)
          end
        end

        @@cached_base_plus_per_ranks_charts[key].dup
      end
    end
  end
end
