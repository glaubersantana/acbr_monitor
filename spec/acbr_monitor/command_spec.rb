require_relative '../spec_helper'

RSpec.describe AcbrMonitor::Command do
  it "mounts command string without parameters" do
    expect(AcbrMonitor::Command.new('MyModule', 'MyCommand').command).
      to eql('MyModule.MyCommand')
  end

  it "mounts command string with parameters" do
    expect(AcbrMonitor::Command.new('MyModule', 'MyCommand', 'Param1', 'Param2').command).
      to eql('MyModule.MyCommand("Param1", "Param2")')
  end

  context "#send_command" do
  end
end
