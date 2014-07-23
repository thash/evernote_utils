require 'active_support/core_ext/object'
require 'evernote_utils/notelist'

require 'active_model'

module ENUtils
  class Note < Evernote::EDAM::Type::Note
    include ActiveModel::Dirty

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

    attr_reader :guid, :title, :contentHash, :contentLength, :created, :updated, :active, :updateSequenceNum, :notebookGuid, :tagGuids, :attributes

    define_attribute_methods [:title, :content]

    def initialize(core, edam_note)
       @core              = core
       set_attributes(edam_note)
    end

    def set_attributes(edam_note)
       @edam_note         = edam_note

       @guid              = edam_note.guid
       @title             = edam_note.title
       @content           = edam_note.content # only getNote withContent: true
       @contentHash       = edam_note.contentHash
       @contentLength     = edam_note.contentLength
       @created           = Time.at(edam_note.created/1000)
       @updated           = Time.at(edam_note.updated/1000)
       @active            = edam_note.active
       @updateSequenceNum = edam_note.updateSequenceNum
       @notebookGuid      = edam_note.notebookGuid
       @tagGuids          = edam_note.tagGuids
       @attributes        = edam_note.attributes
    end

    def title=(val)
      title_will_change! unless val == @title
      @title = @edam_note.title = val
    end

    def content
      @content ||= remote_content
    end

    def remote_content
      @core.find_note(guid, with_content: true).content
    end

    def content=(val)
      @content ||= @edam_note.content = remote_content
      content_will_change! unless val == @content
      @content = @edam_note.content = val
    end

    def save
      return nil unless changed?
      save_to_remote
      set_attributes(@core.find_note(guid, with_content: content_changed?))
      changes_applied
      self
    end

    def save_to_remote
      @edam_note.updated = Time.now.to_i * 1000
      @core.notestore.updateNote(@core.token, @edam_note)
    end

    def self.where(core, options={})
      offset = options.delete(:offset) || 0
      limit  = options.delete(:limit)  || DEFAULT_LIMIT
      result = core.notestore.findNotes(core.token, NoteFilter.build(core, options), offset, limit).notes.map{|n| new(core, n) }
      NoteList.new(core, result, options)
    end

    def notebook
      @notebook ||= Notebook.find_by_guid(@core, notebookGuid)
    end

    def tags
      return nil unless tagGuids
      @tags ||= tagGuids.map{|guid| Tag.find_by_guid(@core, guid) }.compact
    end
  end
end
