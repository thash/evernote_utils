require "evernote_utils/filter"

module ENUtils
  class NoteList < Array

    attr_reader :core, :options

    def initialize(core, array, options={})
      @core    = core
      @options = options
      super(array)
    end

    def total_count
      @total_count ||= get_total_count
    end

    # findNoteCounts returns
    #   Evernote::EDAM::NoteStore::NoteCollectionCounts
    #     notebookCounts:{"xxxxxxxx-...xxx": 10, ...},
    #     tagCounts:{"xxxxxx-...xxxx": 1, ..."}
    def get_total_count
      counts = core.notestore.findNoteCounts(core.token, NoteFilter.build(core, options), false)
      counts.notebookCounts.reduce(0){|sum, pair| sum += pair.last }
    end
  end
end
