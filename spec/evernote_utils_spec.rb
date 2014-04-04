require 'spec_helper'

describe ENUtils::Core do
  before do
    allow(Thrift::HTTPClientTransport).to receive(:new) { nil }
    allow(Thrift::BinaryProtocol).to receive(:new) { nil }

    us = double('Evernote::EDAM::UserStore::UserStore::Client')
    allow(Evernote::EDAM::UserStore::UserStore::Client).to receive(:new) { us }
    allow(us).to receive_messages(checkVersion: true,
                                  getNoteStoreUrl: 'http://note_store_url/')
  end
  it {
    expect(ENUtils::Core.new('dummy_token')).to be_instance_of(ENUtils::Core)
  }
end
