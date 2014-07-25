FactoryGirl.define do

  factory :core, class: ENUtils::Core do
    token 'hogehoge'
    notestore 'hoge'
    initialize_with { new(token, false) }
  end

  factory :notestore, class: Evernote::EDAM::NoteStore::NoteStore::Client do
  end

  factory :edam_note, class: Evernote::EDAM::Type::Note do
    guid 'f1df2a4d-5852-4cb6-82f7-6240ee4e2b5c'
    title 'title'
    content nil
    contentHash 'eeeeeeee6bxxxxxxxxxxxxxxxa889ca7'
    contentLength 2246
    created 1266881336000
    updated 1266881347000
    active true
    updateSequenceNum 2653
    notebookGuid '4xxxxxda-xxxx-xxxx-xxxx-zzzzzzzzzzzz'
    attributes nil
  end

  factory :edam_notebook, class: Evernote::EDAM::Type::Notebook do
    guid 'afa4ba59-xxxx-42ed-xxxx-zzzzzzzzzzzz'
    name 'Books'
    updateSequenceNum 24108
    defaultNotebook false
    serviceCreated 1297607548000
    serviceUpdated 1387262389000
    restrictions nil
  end

  factory :notebook, class: ENUtils::Notebook do
    core 'core'
    edam_notebook { build(:edam_notebook) }
    initialize_with { new(core, edam_notebook) }
  end

  factory :edam_tag, class: Evernote::EDAM::Type::Tag do
    guid 'aaaaaaaaaaa'
    name 'tagName'
    updateSequenceNum 1234
  end

  factory :tag, class: ENUtils::Tag do
    core 'core'
    edam_tag { FactoryGirl.build(:edam_tag) }
    initialize_with { new(core, edam_tag) }
  end
end
