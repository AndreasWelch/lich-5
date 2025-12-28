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
#        :bonus_max: 0                                               <<-- maximum bonus capped at, even if theoretically more is possible, 0 is no cap
#        :duration: UNSPECIFIED                                      <<-- duration of the bonus, if applicable, use 0 if not
#        :skill_used: :skill_or_lore_name                            <<-- skill/lore/stat to calculate off (e.g., :spiritual_lore_blessings, :multi_opponent_combat)
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
            "  Lore Used        : #{effect[:skill_used]}",
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
        # @param [Integer] ranks The number of skill/lore/stat ranks trained (default: from :skill_used if available)
        # @return [Numeric, nil] The total bonus amount, or nil if invalid
        #
        # @example
        #   effect = SpellBonusFormatter.effect_for(:minor_spiritual, 104, "increased disease resistance")
        #   SpellBonusEvaluator.evaluate_bonus(effect, 42)
        def self.evaluate_bonus(effect, ranks = nil)
          return nil unless effect.is_a?(Hash)

          # Determine ranks from lore reference if not passed
          ranks ||= if effect[:skill_used].respond_to?(:call)
                      effect[:skill_used].call
                    else
                      0
                    end

          chart = effect[:chart]
          return nil unless chart.is_a?(Hash)

          bonus_step = chart[ranks.to_i] || 0
          bonus_total = bonus_step * effect[:bonus_amount]

          if effect[:bonus_max].to_i > 0
            [bonus_total, effect[:bonus_max]].min
          else
            bonus_total
          end
        end

        ##
        # Evaluates all effects for a spell and returns a hash of effect name => bonus.
        #
        # @param [Symbol] circle The spell circle symbol
        # @param [Integer] spell_id The spell number
        # @param [Integer] ranks The skill/lore ranks to use for evaluation
        # @return [Hash{String => Numeric}] Hash of effect names and their current bonuses
        #
        # @example
        #   SpellBonusEvaluator.evaluate_spell(:minor_spiritual, 104, 50)
        def self.evaluate_spell(circle, spell_id, ranks)
          result = {}
          spell = SpellBonuses.table.dig(circle, spell_id)
          return result unless spell

          spell.each do |name, effect|
            result[name] = evaluate_bonus(effect, ranks)
          end

          result
        end

        ##
        # Evaluates all spells in a circle and returns a hash of spell_id => effect bonuses.
        #
        # @param [Symbol] circle The spell circle
        # @param [Integer] ranks The number of relevant skill/lore ranks
        # @return [Hash{Integer => Hash{String => Numeric}}]
        #
        # @example
        #   SpellBonusEvaluator.evaluate_circle(:minor_spiritual, 60)
        def self.evaluate_circle(circle, ranks)
          result = {}
          spells = SpellBonuses.table[circle]
          return result unless spells

          spells.each do |spell_id, _|
            result[spell_id] = evaluate_spell(circle, spell_id, ranks)
          end

          result
        end

        ##
        # Evaluates all effects for a given spell and skill/lore rank.
        #
        # @param [Symbol] spell_circle The symbol representing the spell circle (e.g. `:minor_spiritual`)
        # @param [Integer] spell_id The spell number (e.g. `104`)
        # @param [Integer] skill_ranks The number of ranks trained in the relevant skill/lore
        # @return [Hash{String => Numeric}] A hash of effect names to evaluated bonus values
        #
        # @example
        #   SpellBonusEvaluator.evaluate_all_effects_for_spell(:minor_spiritual, 104, 50)
        #   # => { "increased disease resistance" => 10 }
        def self.evaluate_all_effects_for_spell(spell_circle, spell_id, skill_ranks)
          effects = SpellBonusFormatter.all_effects_for_spell(spell_circle, spell_id)
          return {} unless effects.is_a?(Hash)

          effects.each_with_object({}) do |(effect_name, effect_data), results|
            bonus = effective_bonus_for_rank(effect_data, skill_ranks)
            results[effect_name] = bonus
          end
        end

        ##
        # Evaluates all spells in a given spell circle at the specified skill/lore rank.
        #
        # @param [Symbol] spell_circle The spell circle symbol (e.g. `:minor_spiritual`)
        # @param [Integer] skill_ranks The number of trained skill/lore ranks
        # @return [Hash{Integer => Hash{String => Numeric}}] A hash mapping spell IDs to their effect bonuses
        #
        # @example
        #   SpellBonusEvaluator.evaluate_all_spells_for_circle(:minor_spiritual, 75)
        #   # => { 104 => { "increased disease resistance" => 12 }, 105 => { ... } }
        def self.evaluate_all_spells_for_circle(spell_circle, skill_ranks)
          SpellBonusFormatter.all_spell_ids(spell_circle).each_with_object({}) do |spell_id, results|
            results[spell_id] = evaluate_all_effects_for_spell(spell_circle, spell_id, skill_ranks)
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
