require 'spec_helper'

describe ENUtils::Notebook do
  let(:edam) { build(:edam_notebook) }
  let(:core) { build(:core) }
  let(:notebook) { ENUtils::Notebook.new(core, edam) }

  before do
    allow_any_instance_of(Evernote::EDAM::UserStore::UserStore::Client)
      .to receive(:getNoteStoreUrl).and_return('notestoreurl')
    notebook
  end

  it { expect(edam).to be_instance_of Evernote::EDAM::Type::Notebook }
  it { expect(notebook.name).to be_instance_of String }

end
