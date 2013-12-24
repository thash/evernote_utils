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
enutils.notes # => <ENUtils::NoteList ...>
```

It returns `ENUtils::NoteList` instance. `ENUtils::NoteList` is an enumerable collection of `ENUtils::Note`. `ENUtils::Note` is just a thin wrapper of `Evernote::EDAM::Type::Note`.

You can get total count of search result by calling `ENUtils::NoteList#total_count`

```ruby
enutils.notes.total_count #=> 15000
```

Here, `ENUtils#notes` accepts following options to search notes:

* notebook
* tag, tags
* words (fulltext search api)
* order (`:created, :updated, :relevance, :update_sequence_number, :title`)
* asc (true/false)
* offset (default 0)
* limit (default 10, max 50 (due to Evernote API restriction))


```ruby
enutils.notes(words: 'clojure install', limit: 5, order: :updated)

# Assume that 'inbox' is a ENUtils::Notebook, 'mytag' is a ENUtils::Tag. See below.
enutils.notes(notebook: inbox, tag: mytag, limit: 10).count #=> 10
enutils.notes(notebook: inbox, tag: mytag, limit: 10).total_count #=> 210
```

Actually, 'words' option is flexible enough to search notes by names of notebook and tag, same as official Evernote Desctop application.

```ruby
# Just passing notebook/tag(s) names to 'words' option would work.
enutils.notes(words: 'oauth notebook:Blog tag:ruby tag:tips')
```

`ENUtils#notebooks` and `ENUtils#tags` accept name filtering. You can use String or Regexp.

```ruby
enutils.notebooks(name: 'Twitter') #=> [<ENUtils::Notebook ...>, ...]
enutils.tags(name: /ruby/i)        #=> [<ENUtils::Tag ...>, ...]
```

These methods return an array of `ENUtils::Notebook` and `ENUtils::Tag`, respectively. By passing them `ENUtils::Core#notes` searches notes as described above.

```ruby
notebook = enutils.notebooks(name: /Book/).first
tag      = enutils.tags(name: 'language').first
enutils.notes(notebook: notebook, tag: tag, words: 'beginners\' guide')

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
