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

  describe '#inspect' do
    it { expect(note.inspect).to match('@edam_note=') }
  end

  describe '#created, #updated' do
    it { expect(note.created).to be_instance_of Time }
    it { expect(note.updated).to be_instance_of Time }
  end

  describe '#notebook=' do
    before do
      note.notebook = val
    end
    [FactoryGirl.build(:notebook, guid: 'updated_guid'), 'updated_guid'].each do |val|
      context { let(:val) { val }
        it { expect(note.notebookGuid).to eq 'updated_guid' } }
    end
  end

  describe '#tags=' do
    before do
      note.tags = [val]
    end
    [FactoryGirl.build(:tag, guid: 'updated_guid'), 'updated_guid'].each do |val|
      context { let(:val) { val }
        it { expect(note.tagGuids).to eq ['updated_guid'] } }
    end
  end

  describe '#tags' do
    before do
      allow(note).to receive(:tagGuids).and_return(['weiwei'])
      allow(note).to receive_message_chain(:tagGuids, :map, :compact)
        .and_return([build(:tag)])
    end
    it { expect(note.tags.first).to be_instance_of ENUtils::Tag }
  end

  describe '#save' do
    before do
      allow(core).to receive_message_chain(:notestore, :updateNote).and_return(true)
    end
    it { expect(note.save).to eq true }
  end
end
