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
end

