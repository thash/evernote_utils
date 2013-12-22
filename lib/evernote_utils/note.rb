require 'active_support/core_ext/object'

module ENUtils
  class Note < Evernote::EDAM::Type::Note

    DEFAULT_LIMIT = 10

    # Evernote::EDAM::Type::Note fields
    #   guid:"f1df2a4d-5852-4cb6-82f7-6240ee4e2b5c"
    #   title:"Note title"
    #   contentHash:eeeeeeee6bxxxxxxxxxxxxxxxa889ca7
    #   contentLength:2246
    #   created:1266881336000
    #   updated:1266881347000
    #   active:true
    #   updateSequenceNum:2653
    #   notebookGuid:"4xxxxxda-xxxx-xxxx-xxxx-zzzzzzzzzzzz"
    #   attributes:<Evernote::EDAM::Type::NoteAttributes >

    attr_reader :guid, :title, :contentHash, :contentLength, :created, :updated, :active, :updateSequenceNum, :notebookGuid, :attributes

    # created: 1, updated: 2, relevance: 3, update_sequence_number: 4, title: 5
    OrderFields = Evernote::EDAM::Type::NoteSortOrder::VALUE_MAP.reduce({}){|accum, pair|
      accum.merge(pair.last.downcase.to_sym => pair.first)
    }

    def initialize(edam_note)
       @guid              = edam_note.guid
       @title             = edam_note.title
       @contentHash       = edam_note.contentHash
       @contentLength     = edam_note.contentLength
       @created           = Time.at(edam_note.created/1000)
       @updated           = Time.at(edam_note.updated/1000)
       @active            = edam_note.active
       @updateSequenceNum = edam_note.updateSequenceNum
       @notebookGuid      = edam_note.notebookGuid
       @attributes        = edam_note.attributes
    end

    def self.where(core, options={})
      offset = options.delete(:offset) || 0
      limit  = options.delete(:limit)  || DEFAULT_LIMIT
      core.notestore.findNotes(core.token, build_filter(options), offset, limit)
        .notes.map{|n| new(n) }
    end

    private

    def self.build_filter(options={})
      filter = Evernote::EDAM::NoteStore::NoteFilter.new
      if (notebook = options[:notebook])
        notebook_guid = notebook.is_a?(ENUtils::Notebook) ? notebook.guid : notebook
        filter.notebookGuid = notebook_guid
      end
      if (tags = options[:tags]) || (tag = options[:tag])
        tag_guids = (tags || [tag]).map{|t| t.is_a?(ENUtils::Tag) ? t.guid : t }
        filter.tagGuids = tag_guids
      end
      filter.words     = options[:words] if options[:words]
      filter.order     = OrderFields[options[:order].to_sym] if available_order?(options[:order])
      filter.ascending = options[:asc] if options[:asc]
      filter
    end

    def self.available_order?(value)
      return false if value.nil?
      OrderFields.keys.include?(value.to_sym)
    end

  end
end
