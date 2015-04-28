require 'formula'

class PackerWindowsPlugins < Formula
  homepage "https://github.com/packer-community/packer-windows-plugins"
  version "1.0.0"

  if Hardware.is_64_bit?
    url "https://github.com/packer-community/packer-windows-plugins/releases/download/v1.0.0/darwin_amd64.zip"
    sha256 "e09e2ab6f7fc39237b5b41f53aa5b2a815428cfc"
  else
    url "https://github.com/packer-community/packer-windows-plugins/releases/download/v1.0.0/darwin_386.zip"
    sha256 '64535683e7f261091629c5a96236263dc0856c63'
  end

  depends_on :arch => :intel
  #depends_on "packer" => :recommended

  def install
    pluginpath = Pathname.new("#{ENV['HOME']}/.packer.d/plugins")
    cp_r Dir["*"], pluginpath
    bin.install Dir['*']
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<-EOS.undent
    {
    "builders": [
      {
        "type": "amazon-windows-ebs",
        "region": "ap-southeast-1",
        "source_ami": "ami-e01f3db2",
        "instance_type": "t2.medium",
        "ami_name": "packer-community-nossh-{{timestamp}}",
        "associate_public_ip_address":true,
        "winrm_username": "vagrant",
        "winrm_password": "vagrant",
        "winrm_wait_timeout": "5m",
        "winrm_port":5985,
        "vpc_id": "vpc-e141b084",
        "subnet_id":"subnet-c774bfa2",
        "security_group_id":"sg-a74d86c2"
      }
    ]
    }
    EOS
    system "packer", "validate", minimal
  end
end