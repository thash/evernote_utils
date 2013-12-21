require 'spec_helper'

describe EvernoteUtils::Core do
  before do
    Thrift::HTTPClientTransport.stubs(new: nil)
    Thrift::BinaryProtocol.stubs(new: nil)

    us = mock('Evernote::EDAM::UserStore::UserStore::Client')
    Evernote::EDAM::UserStore::UserStore::Client.stubs(new: us)
    us.stubs(checkVersion: true,
             getNoteStoreUrl: 'http://note_store_url/')
  end
  it {
    EvernoteUtils::Core.new('dummy_token').must_be_instance_of EvernoteUtils::Core
  }
end
