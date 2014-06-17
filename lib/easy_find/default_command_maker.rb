module EasyFind
  class DefaultCommandMaker
    SEPARATOR = ' '

    def initialize
      @folder_clause = ''
      @where_clause = ''
      @action_clause = ''
    end

    def make_folder_name(&block)
      folder = block.call
      if folder.is_a?(Array)
        @folder_clause = SEPARATOR + folder.join(" ")
      else
        @folder_clause = folder.nil? ? "" : (SEPARATOR + folder)
      end
    end

    def make_where_str(&block)
      instance_eval &block
      @where_clause
    end

    def make_actions_str(&block)
      instance_eval &block
      @action_clause
    end

    private

      def name(n)
        build_quoted_where_segment("-name", n)
      end

      def size(*xs)
        build_modified_action_str("-size", *xs)
      end
    
      def atime(*xs)
        build_modified_action_str("-atime", *xs)
      end

      def mtime(*xs)
        build_modified_action_str("-mtime", *xs)
      end
        
        def build_modified_action_str(action_str, *xs)
          modified_param = modify(xs)
          build_unquoted_where_segment(action_str, modified_param)
        end

          def modify(xs)
            if xs.length == 1
              xs[0]
            elsif xs.length == 2
              if xs[0] == :greater_than
                "+#{xs[1]}"
              elsif xs[0] == :less_than
                "-#{xs[1]}"
              end
            end
          end

      def type(n)
        build_quoted_where_segment("-type", n)
      end

      def fstype(n)
        build_quoted_where_segment("-fstype", n)
      end

      def user(n)
        build_quoted_where_segment("-user", n)
      end

      def group(n)
        build_quoted_where_segment("-group", n)
      end

      def perm(n)
        build_unquoted_where_segment("-perm", n)
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

      def print
        build_action_str "-print"
      end

      def exec(cmd)
        build_action_str "-exec #{cmd} \\;"
      end

      def ok(cmd)
        build_action_str "-ok #{cmd} \\;"
      end

      def mount
        build_action_str "-mount"
      end

      def xdev
        build_action_str "-xdev"
      end

      def prune
        build_action_str "-prune"
      end
      
        def build_action_str(cmd)
          @action_clause += SEPARATOR + cmd.to_s
        end
  end
end

