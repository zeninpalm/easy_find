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
    end
  end
end

