require 'easy_find/default_command_maker'

module EasyFind

  class Finder
    BASE_FIND = "find"
    SEPARATOR = ' '

    def initialize(command_maker = DefaultCommandMaker)
      @folder_clause = ''
      @where_clause = ''
      @action_clause = ''
      @command_maker = DefaultCommandMaker.new
    end

    def find(&block)
      command = instance_eval &block
      if command.nil?
        BASE_FIND
      else
        BASE_FIND + @folder_clause + @where_clause + @action_clause
      end
    end

    def in_folder(&block)
      @folder_clause += @command_maker.instance_eval { make_folder_name(&block) }
    end

    def where(&block)
      @where_clause += @command_maker.instance_eval { make_where_str(&block) }
    end

    def with_actions(&block)
      @action_clause += @command_maker.instance_eval { make_actions_str(&block) }
    end
  end
end

