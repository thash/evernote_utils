module ENUtils
  class Notebook < Evernote::EDAM::Type::Notebook

     # Evernote::EDAM::Type::Notebook fields
     #   guid:"afa4ba59-xxxx-42ed-xxxx-zzzzzzzzzzzz"
     #   name:"Books"
     #   updateSequenceNum:24108
     #   defaultNotebook:false
     #   serviceCreated:1297607548000
     #   serviceUpdated:1387262389000
     #   restrictions:<Evernote::EDAM::Type::NotebookRestrictions ...>

      attr_reader :guid, :name, :updateSequenceNum, :defaultNotebook, :serviceCreated, :serviceUpdated, :restrictions

    def initialize(core, edam_notebook)
      @core              = core
      @guid              = edam_notebook.guid
      @name              = edam_notebook.name
      @updateSequenceNum = edam_notebook.updateSequenceNum
      @defaultNotebook   = edam_notebook.defaultNotebook
      @serviceCreated    = Time.at(edam_notebook.serviceCreated/1000)
      @serviceUpdated    = Time.at(edam_notebook.serviceUpdated/1000)
      @restrictions      = edam_notebook.restrictions
    end

    def notes(options={})
      Note.where(@core, options.merge(notebook: self))
    end

    def self.find_by_guid(core, guid)
      notebook = core.notestore.listNotebooks(core.token).find{|nb| nb.guid == guid }
      notebook.present? ? new(core, notebook) : nil
    end

    def self.find_by_name(core, name)
      notebook = core.notestore.listNotebooks(core.token).find{|nb| nb.name.downcase == name.to_s.downcase }
      notebook.present? ? new(core, notebook) : nil
    end

    def self.where(core, options={})
      notebooks = core.notestore.listNotebooks(core.token).map{|nb| new(core, nb) }
      return notebooks if options.empty?
      case options[:name]
      when String
        notebooks.select{|nb| options[:name].downcase == nb.name.downcase }
      when Regexp
        notebooks.select{|nb| options[:name] =~ nb.name }
      else
        notebooks
      end
    end

  end
end
