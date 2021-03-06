require "evernote_utils/version"

require 'evernote-thrift'
require "evernote_utils/note"
require "evernote_utils/notebook"
require "evernote_utils/tag"

module ENUtils
  class InvalidVersion < StandardError; end

  GUID_REGEXP = /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/

  class Core
    attr_accessor :token, :notestore

    def initialize(token, production=true)

      userStoreUrl = "https://#{production ? 'www' : 'sandbox'}.evernote.com/edam/user"
      userStoreTransport = Thrift::HTTPClientTransport.new(userStoreUrl)
      userStoreProtocol = Thrift::BinaryProtocol.new(userStoreTransport)
      userStore = Evernote::EDAM::UserStore::UserStore::Client.new(userStoreProtocol)

      versionOK = userStore.checkVersion("Evernote EDAMTest (Ruby)",
                                         Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
                                         Evernote::EDAM::UserStore::EDAM_VERSION_MINOR)
      raise InvalidVersion unless versionOK

      noteStoreUrl = userStore.getNoteStoreUrl(token)

      noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
      noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
      @notestore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)

      @token = token
    end

    def find_notes(options={})
      Note.where(self, options.reverse_merge(order: :updated))
    end
    alias notes find_notes

    def find_note(guid, with_content: false,
                        with_resources_data: false,
                        with_resources_recognition: false,
                        with_resources_alternate_data: false)
      self.notestore.getNote(self.token, guid, with_content,
                                               with_resources_data,
                                               with_resources_recognition,
                                               with_resources_alternate_data)
    end
    alias note find_note

    def create_note(attrs)
      Note.create(self, attrs)
    end

    def delete_note(guid)
      Note.delete(self, guid)
    end

    def find_notebook(name=nil)
      return nil unless name
      Notebook.find_by_name(self, name)
    end
    alias notebook find_notebook

    def find_notebooks(options={})
      Notebook.where(self, options)
    end
    alias notebooks find_notebooks

    def create_tag(attrs)
      Tag.create(self, attrs)
    end

    def find_tag(name=nil)
      return nil unless name
      Tag.find_by_name(self, name)
    end
    alias tag find_tag

    def find_tags(options={})
      Tag.where(self, options)
    end
    alias tags find_tags

  end
end
