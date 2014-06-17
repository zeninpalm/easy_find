require "spec_helper"

describe "Finder" do
  let(:finder) { EasyFind::Finder.new }

  it "is callable with empty block" do
    finder.find do
    end
  end

  context "nested block" do

    context "trivial blocks" do
      it "recognizes 'in_folder' block" do
        finder.find do
          in_folder { }
        end
      end

      it "recognizes 'where' block" do
        finder.find do
          where {}
        end
      end

      it "recognizes 'with_actions' block" do
        finder.find do
          with_actions {}
        end
      end

      it "returns plain 'find' command line" do
        command = finder.find {}
        expect(command).to eql("find")
      end
    end
    
    context "blocks with parameters" do
      context "nested 'in_folder' block" do
        it "concatenates given folder name" do
          command = finder.find do
            in_folder { "." }
          end
          expect(command).to eql("find .")
        end

        it "concatenates given array of folder names" do
          command = finder.find do
            in_folder { [".", "~", "/home/yiwei"] }
          end
          expect(command).to eql("find . ~ /home/yiwei")
        end
      end

      context "nested 'where' block" do
        it "concatenates empty 'where' arguments" do
          command = finder.find do
            where { }
          end
          expect(command).to eql("find")
        end
        it "concatenates single 'where' argument" do
          command = finder.find do
            where { name "" }
          end
          expect(command).to eql('find -name ""')
        end

        it "concatenates multiple 'where' arguments" do
          command = finder.find do
            where do
              name "*.rb"
              size 10
            end
          end
          expect(command).to eql("find -name \"*.rb\" -size 10")
        end

        it "concatenates folder names and 'where' arguments" do
          command = finder.find do
            in_folder { "." }
            where do
              name "*.rb"
              size 10
            end
          end
          expect(command).to eql('find . -name "*.rb" -size 10')
        end
        
        it "concatenates folder names and 'where' arguments regardless of ordering" do
          command = finder.find do
            where do
              name "*.rb"
              size 10
            end
            in_folder { "." }
          end
          expect(command).to eql('find . -name "*.rb" -size 10')
        end

        it "supports name, size, atime and mtime matching criterias in 'where' arguments" do
          command = finder.find do
            where do
              name "*.rb"
              size 10
              atime 20
              mtime 10
            end
          end
          expect(command).to eql("find -name \"*.rb\" -size 10 -atime 20 -mtime 10")
        end
        
        it "supports type, fstype, user, group and perm matching criterias in 'where' arguments" do
          command = finder.find do
            where do
              type "f"
              fstype "nfs"
              user "yiwei"
              group "admins"
              perm 666
            end
          end
          expect(command).to eql("find -type \"f\" -fstype \"nfs\" -user \"yiwei\" -group \"admins\" -perm 666")
        end
      end

      context "modifiers in matching criterias" do
        it "supports '+' modifiers in 'mtime'" do
          command = finder.find do
            where do
              mtime :greater_than, 10
            end
          end
          expect(command).to eql("find -mtime +10")
        end
        
        it "supports '-' modifiers in 'mtime'" do
          command = finder.find do
            where do
              mtime :less_than, 10
            end
          end
          expect(command).to eql("find -mtime -10")
        end
      end

      context "action clause" do
        it "supports single action" do
          command = finder.find do
            with_actions do
              print
            end
          end
          expect(command).to eql("find -print") 
        end
        it "supports multiple actions" do
          command = finder.find do
            with_actions do
              print
              ok "rm -rf {}"
            end
          end
          expect(command).to eql("find -print -ok rm -rf {} \\;") 
        end
      end

      context "full examples" do
        it "generates 'find . -name \"*.c\" -print" do
          command = finder.find do
            in_folder { "." }
            where { name "*.c" }
            with_actions { print }
          end
          expect(command).to eql("find . -name \"*.c\" -print")
        end

        it "generates 'find /mydir1 /mydir2 -size +2000 -atime +30 -print" do
          command = finder.find do
            in_folder { ["/mydir1", "/mydir2"] }
            where do
              size :greater_than, 2000
              atime :greater_than, 30
            end
            with_actions { print }
          end
          expect(command).to eql("find /mydir1 /mydir2 -size +2000 -atime +30 -print")
        end

        it "generates 'find /mydir -atime +100 -ok rm {} \\;'" do
          command = finder.find do
            in_folder { "/mydir" }
            where do
              atime :greater_than, 100
            end
            with_actions do
              ok "rm {}"
            end
          end
          expect(command).to eql("find /mydir -atime +100 -ok rm {} \\;")
        end

        it "generates 'find /mydir \\(-mtime +20 -o -atime +40 \\) -exec ls -l {} \\;'" do
          command = finder.find do
            in_folder { "/mydir" }
            where do
              grouping do
                mtime :greater_than, 20
                or_else
                atime :greater_than, 40
              end
            end
            with_actions do
              exec "ls -l {}"
            end
          end
          expect(command).to eql("find /mydir \\( -mtime +20 -o -atime +40 \\) -exec ls -l {} \\;")
        end

        it "generates 'find /prog -type f -size +1000 -name core -print -exec rm {} \\;" do
          command = finder.find do
            in_folder { "/prog" }
            where do
              type "f"
              size :greater_than, 1000
              name "core"
            end
            with_actions do
              print
              exec "rm {}"
            end
          end
          expect(command).to eql("find /prog -type \"f\" -size +1000 -name \"core\" -print -exec rm {} \\;")
        end
      end
    end
  end
end

