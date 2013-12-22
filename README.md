# EvernoteUtils

A thin OOP-friendly wrapper of Evernote Ruby SDK.


## Installation

Add this line to your application's Gemfile:

    gem 'evernote_utils'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install evernote_utils


## Requirement

If you don't have your Evernote API Key yet, get it from [Evernote Developers Page](http://dev.evernote.com/doc/).

Note that you should send "Activation Request" to access production data. Please check [Frequently Ask Questions - Evernote Developers](http://dev.evernote.com/support/faq.php#activatekey).

Then authenticate user's Evernote account via OAuth. Instruction is here: [Getting Started with the Evernote API - Evernote Developers](http://dev.evernote.com/doc/start/ruby.php)


EvenoteUtils don't support authentication feature, because dominant other options are available. For instance:

* [evernote_oauth](https://github.com/fourfour/evernote_oauth)
* [omniauth-evernote](https://github.com/szimek/omniauth-evernote)


## Usage

First, initialize ENUtils with an OAuth token credential identifier.

```ruby
enutils = ENUtils::Core.new('oauth-token-credential-identifier')

# If you use sandbox token, pass 2nd argument false.
enutils = ENUtils::Core.new('oauth-token-credential-identifier', false)
```

OAuth token credential identifier looks something like:

    S=s4:U=a1:E=12bfd68c6b6:C=12bf8426ab8:P=7:A=en_oauth_test:H=3df9cf6c0d7bc410824c80231e64dbe1

Then you can access Evernote resources.

```ruby
enutils.notes(words: 'Clojure', limit: 5, order: :updated)
```

It returns `ENUtils::NoteList` instances. You can know total count of search result by calling `ENUtils::NoteList#total_count`

```ruby
enutils.notes(words: 'Clojure', limit: 5, order: :updated).total_count #=> 150
```

`ENUtils::NoteList` is a collection of `ENUtils::Note`. `ENUtils::Note` is a thin wrapper of `Evernote::EDAM::Type::Note`.


And here, `ENUtils#notes` accepts following options:

* notebook
* tag, tags
* words (fulltext search api)
* order (`:created, :updated, :relevance, :update_sequence_number, :title`)
* asc (true/false)
* offset (default is 0)
* limit (default is 10)

`ENUtils#notebooks` and `ENUtils#tags` accept name filtering. You can use String or Regexp.

```ruby
enutils.notebooks(name: 'Twitter')
enutils.tags(name: /ruby/i)
```

These methods return array of `ENUtils::Notebook` and `ENUtils::Tag` respectively, which available to filter notes.

```ruby
notebook = enutils.notebooks(name: /Book/).first
tag      = enutils.tags(name: 'language').first
enutils.notes(notebook: notebook, tag: tag)

# or, you can use multiple tags
enutils.notes(notebook: notebook, tags: [tagA, tagB, tagC])
```

## Planning to do

* relationships: notebook.notes, note.tags, tag.notes


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
