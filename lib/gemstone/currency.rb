module Lich
  module Gemstone
    # Provides access to currency-related information for Gemstone characters.
    # This module retrieves currency data from the Infomon data store.
    module Currency
      # Class variable to track notes in inventory
      @notes_inventory = []
      @note_names = ['Northwatch bond note', 'Icemule promissory note', 'Borthuum Mining Company scrip', "Wehnimer's promissory note", 'Torren promissory note', 'mining chit', 'City-States promissory note', 'Vornavis promissory note', 'Mist Harbor promissory note', 'salt-stained kraken chit']

      # Represents a banknote with its details.
      class Note
        # @return [Integer] the unique identifier of the note
        attr_accessor :id

        # @return [String] the name or denomination of the note
        attr_accessor :name

        # @return [String] the city where the note is valid
        attr_accessor :city

        # @return [Integer] the monetary value of the note
        attr_accessor :value

        # Initializes a Note.
        #
        # @param id [Integer] the unique identifier of the note
        # @param name [String] the name or denomination of the note
        # @param city [String] the city where the note is valid
        # @param value [Integer] the monetary value of the note
        def initialize(id, name, city, value)
          @id = id
          @name = name
          @city = city
          @value = value
        end
      end

      # Gets the current amount of silver.
      #
      # @return [Integer] the amount of silver
      def self.silver
        Lich::Gemstone::Infomon.get('currency.silver')
      end

      # Gets the container where silver is stored.
      #
      # @return [String] the silver container location or identifier
      def self.silver_container
        Lich::Gemstone::Infomon.get('currency.silver_container')
      end

      # Gets the current amount of Redsteel marks.
      #
      # @return [Integer] the amount of Redsteel marks
      def self.redsteel_marks
        Lich::Gemstone::Infomon.get('currency.redsteel_marks')
      end

      # Gets the current amount of tickets.
      #
      # @return [Integer] the amount of tickets
      def self.tickets
        Lich::Gemstone::Infomon.get('currency.tickets')
      end

      # Gets the current amount of Blackscrip.
      #
      # @return [Integer] the amount of Blackscrip
      def self.blackscrip
        Lich::Gemstone::Infomon.get('currency.blackscrip')
      end

      # Gets the current amount of Bloodscrip.
      #
      # @return [Integer] the amount of Bloodscrip
      def self.bloodscrip
        Lich::Gemstone::Infomon.get('currency.bloodscrip')
      end

      # Gets the current amount of Ethereal Scrip.
      #
      # @return [Integer] the amount of Ethereal Scrip
      def self.ethereal_scrip
        Lich::Gemstone::Infomon.get('currency.ethereal_scrip')
      end

      # Gets the current amount of Raikhen.
      #
      # @return [Integer] the amount of Raikhen
      def self.raikhen
        Lich::Gemstone::Infomon.get('currency.raikhen')
      end

      # Gets the current amount of Elans.
      #
      # @return [Integer] the amount of Elans
      def self.elans
        Lich::Gemstone::Infomon.get('currency.elans')
      end

      # Gets the current amount of Soul Shards.
      #
      # @return [Integer] the amount of Soul Shards
      def self.soul_shards
        Lich::Gemstone::Infomon.get('currency.soul_shards')
      end

      # Gets the current amount of gold.
      #
      # @return [Integer] the amount of gold
      def self.gold
        Lich::Gemstone::Infomon.get('currency.gold')
      end

      # Gets the current amount of Gigas Artifact Fragments.
      #
      # @return [Integer] the amount of Gigas Artifact Fragments
      def self.gigas_artifact_fragments
        Lich::Gemstone::Infomon.get('currency.gigas_artifact_fragments')
      end

      # Gets the current amount of Gemstone Dust.
      #
      # @return [Integer] the amount of Gemstone Dust
      def self.gemstone_dust
        Lich::Gemstone::Infomon.get('currency.gemstone_dust')
      end

      # Gets all notes currently in inventory.
      #
      # @return [Array<Note>] array of Note objects in inventory
      def self.notes_inventory
        @notes_inventory
      end

      # Adds a note to the inventory.
      #
      # @param note [Note] the note to add to inventory
      # @return [Array<Note>] the updated inventory
      def self.add_note_to_inventory(note)
        @notes_inventory << note
      end

      # Removes a note from the inventory by ID.
      #
      # @param note_id [Integer] the ID of the note to remove
      # @return [Note, nil] the removed note, or nil if not found
      def self.remove_note_from_inventory(note_id)
        @notes_inventory.delete_if { |note| note.id == note_id }
      end

      # Clears all notes from the inventory.
      #
      # @return [void]
      def self.clear_notes_inventory
        @notes_inventory.clear
      end

      # Gets the total value of all notes in inventory.
      #
      # @return [Integer] the sum of all note values
      def self.notes_inventory_value
        @notes_inventory.sum(&:value)
      end

      # Gets all notes from a specific city.
      #
      # @param city [String] the city to filter notes by
      # @return [Array<Note>] array of notes from the specified city
      def self.notes_by_city(city)
        @notes_inventory.select { |note| note.city == city }
      end

      # Finds a note by its ID.
      #
      # @param note_id [Integer] the ID of the note to find
      # @return [Note, nil] the note if found, nil otherwise
      def self.find_note_by_id(note_id)
        @notes_inventory.find { |note| note.id == note_id }
      end

      # Synchronizes the notes inventory with items in GameObj.inv.
      # Adds new notes found in inventory and removes notes no longer present.
      #
      # @return [void]
      def self.sync_notes_from_inventory
        # Get all note-like items from GameObj.inv
        inv_notes = GameObj.inv.select { |item| item.is_a?(Note) } # TODO: that's not how this works, unfortunately
        inv_note_ids = inv_notes.map(&:id)

        # Remove notes from our inventory that are no longer in GameObj.inv
        @notes_inventory.delete_if { |note| !inv_note_ids.include?(note.id) }

        # Add new notes from GameObj.inv that we don't already have
        inv_notes.each do |note|
          @notes_inventory << note unless find_note_by_id(note.id)
        end
      end

      # Gets the total amount of money available.
      #
      # @return [Integer] the total amount of money
      def self.total_money
        # TODO: Implement central intelligence for total money calculation
      end

      # Withdraws a specified amount of silver from the bank.
      #
      # @param amount [Integer] the amount of silver to withdraw
      # @return [Boolean] true if successful, false otherwise
      def self.get_silver(amount)
        # TODO: Implement silver withdrawal logic
      end

      # Withdraws a note of a specified denomination.
      #
      # @param denomination [String] the type of note to withdraw
      # @return [Boolean] true if successful, false otherwise
      def self.get_note(denomination)
        # TODO: Implement note withdrawal logic
        # When implemented, add retrieved note to inventory with add_note_to_inventory
      end

      # Deposits silver into the bank.
      #
      # @param amount [Integer, Symbol] the amount to deposit, or :all to deposit all silver
      # @return [Boolean] true if successful, false otherwise
      def self.deposit_silver(amount)
        # TODO: Implement silver deposit logic
      end

      # Deposits a note into the bank.
      #
      # @return [Boolean] true if successful, false otherwise
      def self.deposit_note
        # TODO: Implement note deposit logic
        # When implemented, remove note from inventory with remove_note_from_inventory
      end

      # Deposits all money and notes into the bank.
      #
      # @return [Boolean] true if successful, false otherwise
      def self.deposit_all
        # TODO: Implement deposit all logic
        # When implemented, clear notes from inventory with clear_notes_inventory
      end

      # Gets information about notes in possession.
      #
      # @return [Array<Note>] list of Note objects
      def self.get_notes
        # TODO: Implement get notes logic
      end

      # Gets information about notes in a specific town.
      #
      # @param town [String] the name of the town
      # @return [Array<Note>] list of Note objects for the town
      def self.get_notes_for_town(town)
        # TODO: Implement get notes for town logic
      end

      # Gets a note that can be used for transactions.
      #
      # @return [Note] a Note object to use
      def self.get_note_to_use
        # TODO: Implement get note to use logic
      end

=begin
  Something that centrally and intelligently handles common script tasks
  (how much money do I have,
    go get x silvers,
    go get x note,
    go deposit silvers (x or all),
    go deposit a note,
    go deposit everything,
    what note(s) do I have,
    what note(s) do I have for this town,
    get my note to use, etc
  )...
=end
    end
  end
end
