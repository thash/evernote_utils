require "evernote_utils/version"

require 'evernote-thrift'

module EvernoteUtils
  class InvalidVersion < StandardError; end

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

  end
end
