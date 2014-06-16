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
      build_quoted_where_segment("-name", n)
    end

    def size(n)
      build_unquoted_where_segment("-size", n)
    end

    def atime(n)
      build_unquoted_where_segment("-atime", n)
    end

    def build_quoted_where_segment(criteria, value)
      quoted = '"' + value.to_s + '"'
      build_where_segment(criteria, quoted)
    end
    
    def build_unquoted_where_segment(criteria, value)
      build_where_segment(criteria, value)
    end

    def build_where_segment(criteria, value)
      @where_clause += SEPARATOR + criteria + SEPARATOR + value.to_s
    end

    def make_where_str(block)
      where_parts = instance_eval &block
    end

  end
end

