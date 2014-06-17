module EasyFind
  class DefaultCommandMaker
    SEPARATOR = ' '
    def initialize
      @folder_clause = ''
    end

    def make_folder_name(&block)
      folder = block.call
      if folder.is_a?(Array)
        @folder_clause = SEPARATOR + folder.join(" ")
      else
        @folder_clause = folder.nil? ? "" : (SEPARATOR + folder)
      end
    end
  end
end

