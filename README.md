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

# If you want to work on sandbox, pass false to a 2nd argument.
enutils = ENUtils::Core.new('oauth-token-credential-identifier', false)
```

OAuth token credential identifier looks something like:

```
S=s4:U=a1:E=12bfzzzzzz6:C=12bf8426ab8:P=7:A=en_oauth_test:H=3df9cf6xxxxxxxxx824c802xxxxxdbe1
```

Then you can access Evernote resources.

```ruby
enutils.notes # => <ENUtils::NoteList ...>
```

It returns `ENUtils::NoteList` instance. `ENUtils::NoteList` is an enumerable collection of `ENUtils::Note`. `ENUtils::Note` is just a thin wrapper of `Evernote::EDAM::Type::Note`.

Here, `ENUtils#notes` accepts following options to search notes:

* notebook
* tag, tags
* words (fulltext search api)
* order (`:created, :updated, :relevance, :update_sequence_number, :title`)
* asc (true/false)
* offset (default 0)
* limit (default 10, max 50 (due to Evernote API restriction))


```ruby
# Search notes by free words.
enutils.notes(words: 'clojure install')

# Search notes by notebook and tag names.
result = enutils.notes(notebook: 'inbox', tag: 'mytag')

result.count       #=> 10  ... 'result' contains 10 notes for now.
result.total_count #=> 210 ... How many results EverNote has on your account.

# 10 is default search limit. You can overwrite limit by passing option 'limit'. 
enutils.notes(notebook: 'inbox', tag: 'mytag', limit: 50)

# Sorting result whould be nice.
enutils.notes(tag: 'mytag', order: :updated, asc: false)

# BTW 'tags' option also available to search by multiple tags. Pass an array of tags to it.
enutils.notes(tags: ['java', 'clojure'])
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
# You can also use instances of ENUtils::Notebook and ENUtils::Tag when searching notes.
notebook = enutils.notebooks(name: /Book/).first
tag      = enutils.tags(name: 'language').first
enutils.notes(notebook: notebook, tag: tag, words: 'beginners\' guide')
```

## Planning to do

* update notes
