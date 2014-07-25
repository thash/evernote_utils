require 'spec_helper'

describe ENUtils::Note do
  let(:edam) { build(:edam_note) }
  let(:core) { build(:core) }
  let(:note) { ENUtils::Note.new(core, edam) }

  before do
    allow_any_instance_of(Evernote::EDAM::UserStore::UserStore::Client)
      .to receive(:getNoteStoreUrl).and_return('notestoreurl')
    note
  end

  it { expect(edam).to be_instance_of Evernote::EDAM::Type::Note }
  it { expect(note.title).to be_instance_of String }

  describe '.where' do
    before do
      allow(core).to receive_message_chain(:notestore, :findNotes, :notes, :map)
        .and_return(result)
    end
    let(:result) { [] }
    it { expect(ENUtils::Note.where(core)).to be_instance_of ENUtils::NoteList }
  end
end
