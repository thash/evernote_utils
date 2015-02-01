require 'active_support/core_ext/object'
require 'evernote_utils/notelist'

module ENUtils
  class Note

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

    attr_reader :edam_note

    delegate :guid, :title, :contentHash, :contentLength, :deleted,
    :active, :updateSequenceNum, :notebookGuid, :tagGuids, :resources, :attributes, :tagNames,
    :active=, :contentLength=, :deleted=, :notebookGuid=, :tagGuids=, :title=, :updated=,
    :attributes=, :contentHash=, :created=, :guid=, :resources=, :tagNames=, :updateSequenceNum=,
    :to => :edam_note

    def self.where(core, options={})
      offset = options.delete(:offset) || 0
      limit  = options.delete(:limit)  || DEFAULT_LIMIT
      result = core.notestore.findNotes(core.token, NoteFilter.build(core, options), offset, limit).notes.map{|n| new(core, n) }
      NoteList.new(core, result, options)
    end

    def self.create(core, attrs)
      edam_note = Evernote::EDAM::Type::Note.new(parse_attrs(attrs))
      res = core.notestore.createNote(core.token, edam_note)
      new(core, res)
    end

    def initialize(core, edam_note)
      @core      = core
      @edam_note = edam_note
    end

    def inspect
      "<#{self.class} @edam_note=#{@edam_note.inspect}>"
    end

    # not delegated methods
    def created; Time.at(@edam_note.created/1000); end
    def updated; Time.at(@edam_note.updated/1000); end

    def content
      @content ||= remote_content
    end

    def content=(val)
      @content = @edam_note.content = val
    end

    def notebook
      @notebook ||= Notebook.find_by_guid(@core, notebookGuid)
    end

    def notebook=(val)
      case val
      when ENUtils::Notebook
        self.notebookGuid = val.guid
      when String
        self.notebookGuid = val
      end
    end

    def tags
      return nil unless tagGuids
      @tags ||= tagGuids.map{|guid| Tag.find_by_guid(@core, guid) }.compact
    end

    def tags=(val)
      return false unless val.is_a? Array
      if val.all?{|v| v.is_a? ENUtils::Tag }
        self.tagGuids = val.map(&:guid)
      elsif val.all?{|v| v.is_a? String }
        self.tagGuids = val
      end
    end

    def save
      @edam_note.updated = Time.now.to_i * 1000
      @core.notestore.updateNote(@core.token, @edam_note)
      true
    end

    private
    def remote_content
      @core.find_note(guid, with_content: true).content
    end

    def self.parse_attrs(attrs)
      if notebook = attrs.delete(:notebook)
        attrs[:notebookGuid] = notebook.guid if notebook.is_a? ENUtils::Notebook
        attrs[:notebookGuid] = notebook if notebook.is_a? String
      end
      attrs
    end
  end
end
