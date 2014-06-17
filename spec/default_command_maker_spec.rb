require 'spec_helper'

describe EasyFind::DefaultCommandMaker do
  let(:command_maker) { EasyFind::DefaultCommandMaker.new }

  describe "#make_folder_name" do
    it "has method named make_folder_name which requires block argument" do
      folder_name = command_maker.make_folder_name { }
      expect(folder_name).to eql('')
    end
    it "concatenates folder names" do
      folder_name = command_maker.make_folder_name { "." }
      expect(folder_name).to eql(' .')
      folder_name = command_maker.make_folder_name { ["~", "/home/yiwei", "."] }
      expect(folder_name).to eql(' ~ /home/yiwei .')
    end
  end

  describe "#make_where_str" do
    it "has #make_where_str method" do
      where_clause = command_maker.make_where_str do
        name "*.rb"
        size 10
      end
      expect(where_clause).to eql(" -name \"*.rb\" -size 10")
    end

    it "supports name, size, atime and mtime matching criterias in 'where' arguments" do
      where_clause = command_maker.make_where_str do
        name "*.rb"
        size 10
        atime 20
        mtime 10
      end
      expect(where_clause).to eql(" -name \"*.rb\" -size 10 -atime 20 -mtime 10")
    end

    it "supports type, fstype, user, group and perm matching criterias in 'where' arguments" do
      where_clause = command_maker.make_where_str do
        type "f"
        fstype "nfs"
        user "yiwei"
        group "admins"
        perm 666
      end
      expect(where_clause).to eql(" -type \"f\" -fstype \"nfs\" -user \"yiwei\" -group \"admins\" -perm 666")
    end
  end

  describe "grouping options" do
    it "supports grouping" do
      where_clause = command_maker.make_where_str do
        grouping do
          mtime :greater_than, 7
          atime :greater_than, 30
        end
      end
      expect(where_clause).to eql(" \\( -mtime +7 -atime +30 \\)")
    end
    it "supports or_else" do
      where_clause = command_maker.make_where_str do
        grouping do
          mtime :greater_than, 7
          or_else
          atime :greater_than, 30
        end
      end
      expect(where_clause).to eql(" \\( -mtime +7 -o -atime +30 \\)")
    end
  end

  describe "#make_actions_str" do
    it "accepts empty block" do
      command_maker.make_actions_str {}
    end
    it "supports 'print'" do
      action_clause = command_maker.make_actions_str do
        print
      end
      expect(action_clause).to eql(" -print")
    end
    it "supports 'exec'" do
      action_clause = command_maker.make_actions_str do
        exec "ls -l {}"
      end
      expect(action_clause).to eql(" -exec ls -l {} \\;")
    end
    it "supports 'ok'" do
      action_clause = command_maker.make_actions_str do
        ok "rm {}"
      end
      expect(action_clause).to eql(" -ok rm {} \\;")
    end
    it "supports 'mount'" do
      action_clause = command_maker.make_actions_str do
        mount 
      end
      expect(action_clause).to eql(" -mount")
    end
    it "supports 'xdev'" do
      action_clause = command_maker.make_actions_str do
        xdev 
      end
      expect(action_clause).to eql(" -xdev")
    end
    it "supports 'prune'" do
      action_clause = command_maker.make_actions_str do
        prune 
      end
      expect(action_clause).to eql(" -prune")
    end
  end
end

