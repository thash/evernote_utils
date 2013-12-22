module ENUtils
  class NoteFilter

    # created: 1, updated: 2, relevance: 3, update_sequence_number: 4, title: 5
    OrderFields = Evernote::EDAM::Type::NoteSortOrder::VALUE_MAP.reduce({}){|accum, pair|
      accum.merge(pair.last.downcase.to_sym => pair.first)
    }

    def self.build(options={})
      filter = Evernote::EDAM::NoteStore::NoteFilter.new
      if (notebook = options[:notebook])
        notebook_guid = notebook.is_a?(ENUtils::Notebook) ? notebook.guid : notebook
        filter.notebookGuid = notebook_guid
      end
      if (tags = options[:tags]) || (tag = options[:tag])
        tag_guids = (tags || [tag]).map{|t| t.is_a?(ENUtils::Tag) ? t.guid : t }
        filter.tagGuids = tag_guids
      end
      filter.words     = options[:words] if options[:words]
      filter.order     = OrderFields[options[:order].to_sym] if available_order?(options[:order])
      filter.ascending = options[:asc] if options[:asc]
      filter
    end

    def self.available_order?(value)
      return false if value.nil?
      OrderFields.keys.include?(value.to_sym)
    end

  end
end
