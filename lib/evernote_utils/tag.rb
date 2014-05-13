module ENUtils
  class Tag < Evernote::EDAM::Type::Tag

     # Evernote::EDAM::Type::Tag fields
     #   guid:"xxxxxxxx-xxxx-xxxx-xxxx-zzzzzzzzzzzz",
     #   name:"MyTag",
     #   updateSequenceNum:4378
    attr_reader :guid, :name, :updateSequenceNum

    def initialize(edam_tag)
      @guid              = edam_tag.guid
      @name              = edam_tag.name
      @updateSequenceNum = edam_tag.updateSequenceNum
    end

    def self.find_by_guid(core, guid)
      tag = core.notestore.listTags(core.token).find{|t| t.guid == guid }
      tag.present? ? new(tag) : nil
    end

    def self.find_by_name(core, name)
      tag = core.notestore.listTags(core.token).find{|t| t.name.downcase == name.downcase }
      tag.present? ? new(tag) : nil
    end

    def self.where(core, options={})
      tags = core.notestore.listTags(core.token).map{|t| new(t) }
      return tags if options.empty?
      case options[:name]
      when String
        tags.select{|t| options[:name] == t.name }
      when Regexp
        tags.select{|t| options[:name] =~ t.name }
      else
        tags
      end
    end

  end
end
