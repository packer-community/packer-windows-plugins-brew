require 'formula'

class PackerWindowsPlugins < Formula
  homepage "https://github.com/packer-community/packer-windows-plugins"
  version "1.0.0"

  if Hardware::CPU.is_64_bit?
    url "https://github.com/packer-community/packer-windows-plugins/releases/download/v1.0.0/darwin_amd64.zip"
    sha256 "5fec94f41cb04c5fa5e38bd115f98b0ae1902083d9f281dd880cb6449756f312"
  else
    url "https://github.com/packer-community/packer-windows-plugins/releases/download/v1.0.0/darwin_386.zip"
    sha256 'c5a3bd15020d3986769d46f8f2c9e9c0ab2c93b7a0b15d08097f6f69f0187781'
  end

  depends_on :arch => :intel
  #depends_on "packer" => :recommended

  def install
    pluginpath = Pathname.new("#{ENV['HOME']}/.packer.d/plugins")

    unless File.directory?(pluginpath)
      mkdir_p(pluginpath)
    end

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
