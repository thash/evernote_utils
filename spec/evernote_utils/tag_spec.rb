require 'spec_helper'

describe ENUtils::Tag do
  let(:edam) { build(:edam_tag) }
  let(:core) { build(:core) }
  let(:tag) { ENUtils::Tag.new(core, edam) }

  before do
    allow_any_instance_of(Evernote::EDAM::UserStore::UserStore::Client)
      .to receive(:getNoteStoreUrl).and_return('notestoreurl')
    tag
  end

  it { expect(edam).to be_instance_of Evernote::EDAM::Type::Tag }
  it { expect(tag.name).to be_instance_of String }

  describe '#notes' do
    before do
      allow(core).to receive_message_chain(:notestore, :findNotes, :notes, :map)
        .and_return([])
    end
    it { expect(tag.notes).to be_instance_of ENUtils::NoteList }
  end

  describe '.find_by_guid' do
    before do
      allow(core).to receive_message_chain(:notestore, :listTags, :find)
        .and_return(build(:edam_tag))
    end
    it { expect(ENUtils::Tag.find_by_guid(core, 'guidddd')).to be_instance_of ENUtils::Tag }
  end

  describe '.find_by_name' do
    before do
      allow(core).to receive_message_chain(:notestore, :listTags)
        .and_return([build(:edam_tag, name: 'book')])
    end
    it { expect(ENUtils::Tag.find_by_name(core, 'book')).to be_instance_of ENUtils::Tag }
  end

  describe '.where' do
    before do
      allow(core).to receive_message_chain(:notestore, :listTags)
        .and_return([build(:edam_tag, name: 'book')])
    end
    subject { ENUtils::Tag.where(core, options) }
    [/oo/, 'book'].each do |name|
      let(:options) { {name: name} }
      it { expect(subject).to be_instance_of Array }
      it { expect(subject.first).to be_instance_of ENUtils::Tag }
    end
  end

end
