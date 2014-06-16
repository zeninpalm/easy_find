module EasyFind

  class Finder
    BASE_FIND = "find"
    SEPARATOR = ' '

    def initialize
      @folder_clause = ''
      @where_clause = ''
    end

    def find(&block)
      command = instance_eval &block
      if command.nil?
        BASE_FIND
      else
        BASE_FIND + @folder_clause + @where_clause
      end
    end

    def in_folder(&block)
      make_folder_name(block)
    end

    def where(&block)
      make_where_str(block)
      BASE_FIND + @where_clause
    end

    def with_actions
      yield
    end

    private
    def make_folder_name(block)
      folder = block.call
      if folder.is_a?(Array)
        @folder_clause = SEPARATOR + folder.join(" ")
      else
        @folder_clause = folder.nil? ? "" : (SEPARATOR + folder)
      end
    end

    def name(n)
      @where_clause += SEPARATOR + "-name" + SEPARATOR + '"' + n.to_str() + '"'
    end

    def size(n)
      @where_clause += SEPARATOR + "-size" + SEPARATOR + n.to_s()
    end

    def make_where_str(block)
      where_parts = instance_eval &block
    end

  end
end

