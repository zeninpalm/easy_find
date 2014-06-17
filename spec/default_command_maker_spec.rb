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
end

