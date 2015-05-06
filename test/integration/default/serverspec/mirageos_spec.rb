require 'serverspec'

set :backend, :exec

['ocaml', 'opam', 'libxen-dev'].each do |package_name|
  describe package(package_name) do
    it { is_expected.to be_installed }
  end
end

describe ppa('avsm/ppa') do
  it { is_expected.to exist }
  it { is_expected.to be_enabled }
end

describe command('mirage --version') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /^2/ }
end

describe command('opam --version') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /^1/ }
end
