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
      end
    end
  end
end

