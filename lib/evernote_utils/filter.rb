module ENUtils
  class NoteFilter

    # created: 1, updated: 2, relevance: 3, update_sequence_number: 4, title: 5
    OrderFields = Evernote::EDAM::Type::NoteSortOrder::VALUE_MAP.reduce({}){|accum, pair|
      accum.merge(pair.last.downcase.to_sym => pair.first)
    }

    def self.build(core, o={})
      filter = Evernote::EDAM::NoteStore::NoteFilter.new
      filter.notebookGuid = notebook_guid(core, o[:notebook]) if o[:notebook]
      filter.tagGuids  = tag_guids(core, tag: o[:tag], tags: o[:tags]) if o[:tag] || o[:tags]
      filter.words     = o[:words] if o[:words]
      filter.order     = OrderFields[o[:order].to_sym] if available_order?(o[:order])
      filter.ascending = o[:asc] if o[:asc]
      filter
    end

    def self.available_order?(value)
      return false if value.nil?
      OrderFields.keys.include?(value.to_sym)
    end

    private

    def self.notebook_guid(core, notebook)
      if notebook.is_a?(ENUtils::Notebook)
        notebook.guid
      elsif ENUtils::GUID_REGEXP =~ notebook
        notebook
      else
        Notebook.find_by_name(core, notebook).try(:guid)
      end
    end

    def self.tag_guids(core, tag: nil, tags: nil)
      search_tags = (tags || []) + [tag]
      search_tags.compact.map do |t|
        if t.is_a?(ENUtils::Tag)
          t.guid
        elsif ENUtils::GUID_REGEXP =~ t
          t
        else
          Tag.find_by_name(core, t).try(:guid)
        end
      end.compact
    end

  end
end
