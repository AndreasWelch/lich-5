# required template for spell bonuses
# note that spells can have multiple effects from various sources (lores, skills, stats, etc.)
#  GENERIC:                                                          <<-- the spell circle name
#    000:                                                            <<-- the spell number/id
#      "effect name"                                                 <<-- basic name of the effect
#        :description: "described effect/bonus"                      <<-- describes the effect or bonus that is applied
#        :chart: calculation_chart(value)                            <<-- chart/table to reference to determine bonus
#        :bonus_amount: 0                                            <<-- the bonus added per step, based on chart
#        :bonus_type: [percent, ability, units, time, ranks, bonus]  <<-- the type of bonus, i.e. units, percent, effect
#        :bonus_to: UNSPECIFIED                                      <<-- what the bonus actually applies to
#        :bonus_max: 0                                               <<-- maximum bonus capped at, even if theoretically more is possible, 0 is no cap, can be lambda
#        :duration: UNSPECIFIED                                      <<-- duration of the bonus, if applicable, use 0 if not
#        :skill_used: :skill_or_lore_name                            <<-- skill/lore/stat to calculate off (single symbol, array for multiple, or lambda), can be nil
#        :combine_method: :sum                                       <<-- :sum, :max, :average, :all_required, or :at_least_one (when skill_used is array)
#        :bonus_used: :skill_or_lore_name                            <<-- uses skill BONUS instead of ranks (optional, defaults to nil), can be array
#        :repetitions: 999                                           <<-- number of times the ability can repeat, use 999 for infinite
#        :repeat_modifier: 0                                         <<-- % modifier of chance to recur bonus

include Lich::Util::ChartCalculator

module Lich
  module Gemstone
    module Spell
      class SpellBonuses
        @@spell_bonuses = {}

        ##
        # Accessor for the class variable.
        # @return [Hash]
        def self.table
          @@spell_bonuses
        end
      end

      ##
      # SpellBonusFormatter provides utility methods to access structured
      # spell bonus data stored in `SpellBonuses.table`.
      #
      # It supports retrieving individual effects, spell entries, and the
      # spell list for a given spell circle.
      #
      # All lookups are safe, returning `nil` or `{}` on missing entries.
      #
      class SpellBonusFormatter
        ##
        # Fetches a specific effect from the spell bonus table.
        #
        # @param [Symbol] circle The spell circle symbol (e.g., :minor_spiritual)
        # @param [Integer] spell_id The spell number (e.g., 104)
        # @param [String] effect_name The effect name as written in the table
        # @return [Hash, nil] The effect hash or nil if not found
        def self.effect_for(circle, spell_id, effect_name)
          table = SpellBonuses.table
          return nil unless table[circle]
          return nil unless table[circle][spell_id]
          table[circle][spell_id][effect_name]
        end

        ##
        # Formats a single effect hash into a human-readable string.
        #
        # @param [Hash] effect The effect hash to format
        # @return [String] A formatted string describing the effect
        def self.pretty_effect(effect)
          return "(nil)" unless effect.is_a?(Hash)

          [
            "Effect:",
            "  Description      : #{effect[:description]}",
            "  Chart            : #{effect[:chart].is_a?(Hash) ? "(chart: #{effect[:chart].size} entries)" : effect[:chart]}",
            "  Bonus Amount     : #{effect[:bonus_amount]}",
            "  Bonus Type       : #{effect[:bonus_type]}",
            "  Applies To       : #{effect[:bonus_to]}",
            "  Max Bonus        : #{effect[:bonus_max]}",
            "  Duration         : #{effect[:duration]} sec",
            "  Skill/Lore Used  : #{format_skill_used(effect)}",
            "  Repetitions      : #{effect[:repetitions]}",
            "  Repeat Modifier  : #{effect[:repeat_modifier]}%",
          ].join("\n")
        end

        ##
        # Formats all effects for a given spell.
        #
        # @param [Symbol] circle The spell circle symbol
        # @param [Integer] spell_id The spell number
        # @return [String] Formatted string for all effects of the spell
        def self.pretty_spell(circle, spell_id)
          table = SpellBonuses.table
          return "(nil)" unless table[circle] && table[circle][spell_id]

          effects = table[circle][spell_id]
          output = ["Spell #{spell_id} Effects:"]
          effects.each do |name, effect|
            output << "== #{name} =="
            output << pretty_effect(effect)
            output << ""
          end

          output.join("\n")
        end

        ##
        # Formats all spells in a circle with all their effects.
        #
        # @param [Symbol] circle The spell circle symbol
        # @return [String] All spells and effects in the circle
        def self.pretty_circle(circle)
          table = SpellBonuses.table
          return "(nil)" unless table[circle]

          output = ["=== Spell Circle: #{circle.to_s.tr('_', ' ').capitalize} ==="]
          table[circle].sort.each do |spell_id, _|
            output << pretty_spell(circle, spell_id)
            output << "-" * 60
          end

          output.join("\n")
        end

        ##
        # Returns the full spell table mapping circles to spell bonuses.
        #
        # @return [Hash{Symbol => Hash{Integer => Hash}}] Full spell table
        def self.table
          SpellBonuses.table
        end

        ##
        # Formats the :skill_used field for display, handling arrays.
        #
        # @param [Hash] effect The effect hash
        # @return [String] Formatted skill used string
        def self.format_skill_used(effect)
          skill = effect[:skill_used]
          return skill.to_s unless skill.is_a?(Array)

          method = effect[:combine_method] || :sum
          "[#{skill.join(', ')}] (#{method})"
        end

        ##
        # Looks up the bonus effect hash for a specific spell.
        #
        # @param [Symbol] circle The spell circle symbol (e.g., :minor_spiritual)
        # @param [Integer] spell_id The spell number (e.g., 111)
        # @param [String] effect_name The exact effect name string
        # @param [Boolean] with_metadata If true, returns both effect and metadata
        # @return [Hash, [Hash, Hash]] The effect hash, or [effect, metadata]
        def self.find_effect(circle, spell_id, effect_name, with_metadata: false)
          spell = table.dig(circle, spell_id)
          return nil unless spell && spell[effect_name]

          effect = spell[effect_name]
          return effect unless with_metadata

          metadata = {
            circle: circle,
            spell_id: spell_id,
            effect_name: effect_name
          }

          [effect, metadata]
        end

        ##
        # Lists all effect names for a given spell.
        #
        # @param [Symbol] circle The spell circle
        # @param [Integer] spell_id The spell number
        # @return [Array<String>] The names of all effects, or empty array if not found
        def self.list_all_effects(circle, spell_id)
          spell = table.dig(circle, spell_id)
          return [] unless spell.is_a?(Hash)

          spell.keys
        end

        ##
        # Finds the spell circle that contains the specified spell ID.
        #
        # @param [Integer] spell_id The spell number to look up
        # @return [Symbol, nil] The matching circle symbol, or nil if not found
        def self.find_circle_by_spell(spell_id)
          table.each do |circle, spells|
            return circle if spells.key?(spell_id)
          end
          nil
        end

        ##
        # Pretty-prints the evaluated results for a single spell's effects.
        #
        # @param [Integer] spell_id the numeric spell identifier
        # @param [Hash{String => Numeric}] results A map of effect names to final bonus values
        # @return [String] formatted output
        def self.pretty_results_for_spell(spell_id, results)
          output = []
          output << "Spell #{spell_id}".center(40, '-')

          results.each do |effect_name, bonus|
            output << format("  %-40s : %s", effect_name, bonus.inspect)
          end

          output.join("\n")
        end

        ##
        # Pretty-prints the evaluated results for an entire spell circle.
        #
        # @param [Symbol] circle the spell circle (e.g., :minor_spiritual)
        # @param [Hash{Integer => Hash{String => Numeric}}] results_by_spell the results by spell and effect
        # @return [String] formatted output
        def self.pretty_results_for_circle(circle, results_by_spell)
          output = []
          output << "Results for spell circle: #{circle.to_s.gsub('_', ' ').capitalize}".center(60, '=')

          results_by_spell.each do |spell_id, effect_results|
            output << pretty_results_for_spell(spell_id, effect_results)
            output << ""
          end

          output.join("\n")
        end
      end

      ##
      # SpellBonusEvaluator handles logic for computing the actual bonus
      # of a spell effect given skill/lore/stat ranks or bonuses.
      #
      # Supports evaluation of:
      # - a single effect
      # - all effects of a spell
      # - all spells in a spell circle
      #
      # Can optionally use the `:skill_used` proc to auto-calculate ranks.
      #
      # Returns a Numeric value (with max cap applied) or a hash of such values.
      #
      class SpellBonusEvaluator
        ##
        # Evaluates the current total bonus from a spell effect for a given character.
        #
        # @param [Hash] effect A spell effect hash from SpellBonuses.table
        # @param [Integer, Hash] skill_values The skill ranks or bonuses to use for chart lookup.
        #                                      Can be a single Integer value, or a Hash mapping skill symbols to their values.
        #                                      Values can be either ranks (training levels) or bonuses (stat bonus from training).
        # @return [Numeric, nil] The total bonus amount, or nil if invalid
        #
        # @example Single skill with ranks
        #   effect = SpellBonusFormatter.effect_for(:minor_spiritual, 104, "increased disease resistance")
        #   SpellBonusEvaluator.evaluate_bonus(effect, 42)
        #
        # @example Multiple skills with ranks hash
        #   SpellBonusEvaluator.evaluate_bonus(effect, { spiritual_lore_blessings: 50, spiritual_lore_religion: 30 })
        #
        # @example Multiple skills with bonus values
        #   SpellBonusEvaluator.evaluate_bonus(effect, { spiritual_lore_blessings: 15, spiritual_lore_religion: 10 })
        def self.evaluate_bonus(effect, skill_values = nil)
          return nil unless effect.is_a?(Hash)

          # Determine which skill source to use: bonus_used takes precedence over skill_used
          skill_source = effect[:bonus_used] || effect[:skill_used]
          combine_method = effect[:combine_method]

          # Determine lookup value from skill source if not passed
          if skill_values.nil?
            lookup_value = if skill_source.respond_to?(:call)
                             skill_source.call
                           elsif skill_source.is_a?(Array)
                             # Array of skills - need skill_values hash to evaluate
                             0
                           else
                             0
                           end
          elsif skill_values.is_a?(Hash) && skill_source.is_a?(Array)
            # Multiple skills: combine according to :combine_method
            lookup_value = combine_skill_values(skill_source, skill_values, combine_method)
          else
            # Single value or single skill
            lookup_value = skill_values
          end

          chart = effect[:chart]
          return nil unless chart.is_a?(Hash)

          bonus_step = chart[lookup_value.to_i] || 0
          bonus_total = bonus_step * effect[:bonus_amount]

          # Handle bonus_max - can be lambda, integer, or nil/0
          max_bonus = if effect[:bonus_max].respond_to?(:call)
                        effect[:bonus_max].call
                      else
                        effect[:bonus_max]
                      end

          if max_bonus.to_i > 0
            [bonus_total, max_bonus].min
          else
            bonus_total
          end
        end

        ##
        # Combines multiple skill ranks or bonuses according to the specified method.
        # Supports :sum (add all values), :max (use highest value), :average (average of all values),
        # :all_required (use minimum - all must meet threshold), and :at_least_one (use max - at least one must meet threshold).
        #
        # @param [Array<Symbol>] skills Array of skill symbols
        # @param [Hash{Symbol => Integer}] values_hash Hash mapping skills to their values (ranks or bonuses)
        # @param [Symbol] method Combination method: :sum (default), :max, :average, :all_required, or :at_least_one
        # @return [Integer] Combined value
        def self.combine_skill_values(skills, values_hash, method = nil)
          values = skills.map { |skill| values_hash[skill] || 0 }

          case method
          when :sum, nil
            # nil = Default to sum if not specified
            # :sum = Add all skill values together
            values.sum
          when :max, :at_least_one
            # :max = Use the highest skill value
            # :at_least_one = requires that at least one of the skills meets the mimumum, which is the same as max here
            values.max || 0
          when :average
            # :average = Average all skill values
            values.empty? ? 0 : (values.sum / values.size.to_f).floor
          when :all_required, :min
            # :all_required = All skills must meet threshold - use the minimum and if it's enough, then the others are equal ore more and meet the requirement
            # :min = Use the minimum skill value
            values.min || 0
          else
            # Default to sum if combine_method not recognized
            # TODO: We should probably handle this as an error case instead of silently defaulting
            values.sum
          end
        end

        ##
        # Evaluates all effects for a spell and returns a hash of effect name => bonus.
        #
        # @param [Symbol] circle The spell circle symbol
        # @param [Integer] spell_id The spell number
        # @param [Integer, Hash] skill_values The skill ranks or bonuses to use for evaluation.
        #                                      Can be a single Integer or a Hash mapping skill symbols to values.
        # @return [Hash{String => Numeric}] Hash of effect names and their current bonuses
        #
        # @example
        #   SpellBonusEvaluator.evaluate_spell(:minor_spiritual, 104, 50)
        def self.evaluate_spell(circle, spell_id, skill_values)
          result = {}
          spell = SpellBonuses.table.dig(circle, spell_id)
          return result unless spell

          spell.each do |name, effect|
            result[name] = evaluate_bonus(effect, skill_values)
          end

          result
        end

        ##
        # Evaluates all spells in a circle and returns a hash of spell_id => effect bonuses.
        #
        # @param [Symbol] circle The spell circle
        # @param [Integer, Hash] skill_values The skill ranks or bonuses to use for evaluation.
        #                                      Can be a single Integer or a Hash mapping skill symbols to values.
        # @return [Hash{Integer => Hash{String => Numeric}}]
        #
        # @example
        #   SpellBonusEvaluator.evaluate_circle(:minor_spiritual, 60)
        def self.evaluate_circle(circle, skill_values)
          result = {}
          spells = SpellBonuses.table[circle]
          return result unless spells

          spells.each do |spell_id, _|
            result[spell_id] = evaluate_spell(circle, spell_id, skill_values)
          end

          result
        end

        ##
        # Evaluates all effects for a given spell and skill/lore rank or bonus.
        #
        # @param [Symbol] spell_circle The symbol representing the spell circle (e.g. `:minor_spiritual`)
        # @param [Integer] spell_id The spell number (e.g. `104`)
        # @param [Integer, Hash] skill_values The skill ranks or bonuses to use for evaluation.
        #                                      Can be a single Integer or a Hash mapping skill symbols to values.
        # @return [Hash{String => Numeric}] A hash of effect names to evaluated bonus values
        #
        # @example
        #   SpellBonusEvaluator.evaluate_all_effects_for_spell(:minor_spiritual, 104, 50)
        #   # => { "increased disease resistance" => 10 }
        def self.evaluate_all_effects_for_spell(spell_circle, spell_id, skill_values)
          effects = SpellBonusFormatter.all_effects_for_spell(spell_circle, spell_id)
          return {} unless effects.is_a?(Hash)

          effects.each_with_object({}) do |(effect_name, effect_data), results|
            bonus = evaluate_bonus(effect_data, skill_values)
            results[effect_name] = bonus
          end
        end

        ##
        # Evaluates all spells in a given spell circle at the specified skill/lore rank or bonus.
        #
        # @param [Symbol] spell_circle The spell circle symbol (e.g. `:minor_spiritual`)
        # @param [Integer, Hash] skill_values The skill ranks or bonuses to use for evaluation.
        #                                      Can be a single Integer or a Hash mapping skill symbols to values.
        # @return [Hash{Integer => Hash{String => Numeric}}] A hash mapping spell IDs to their effect bonuses
        #
        # @example
        #   SpellBonusEvaluator.evaluate_all_spells_for_circle(:minor_spiritual, 75)
        #   # => { 104 => { "increased disease resistance" => 12 }, 105 => { ... } }
        def self.evaluate_all_spells_for_circle(spell_circle, skill_values)
          SpellBonusFormatter.all_spell_ids(spell_circle).each_with_object({}) do |spell_id, results|
            results[spell_id] = evaluate_all_effects_for_spell(spell_circle, spell_id, skill_values)
          end
        end
      end
    end
  end
end

# these have to be after the SpellBonuses class definition to work properly
require_relative 'arcane_bonuses'
require_relative 'bard_base_bonuses'
require_relative 'cleric_base_bonuses'
require_relative 'empath_base_bonuses'
require_relative 'major_elemental_bonuses'
require_relative 'major_mental_bonuses'
require_relative 'major_spiritual_bonuses'
require_relative 'minor_elemental_bonuses'
require_relative 'minor_mental_bonuses'
require_relative 'minor_spiritual_bonuses'
require_relative 'paladin_base_bonuses'
require_relative 'ranger_base_bonuses'
require_relative 'savant_base_bonuses'
require_relative 'sorcerer_base_bonuses'
require_relative 'wizard_base_bonuses'
