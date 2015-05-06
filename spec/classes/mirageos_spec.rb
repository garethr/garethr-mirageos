require 'spec_helper'

describe 'mirageos' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "mirage class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_package('opam').with_ensure('present') }
          it { is_expected.to contain_package('ocaml').with_ensure('present') }

          it { is_expected.to contain_exec('install mirage').with_user('root') }
          it { is_expected.to contain_exec('install depext').with_user('root') }
          it { is_expected.to contain_exec('initialize opam').with_user('root').with_creates('/usr/local/opam') }

          it { is_expected.to contain_file('/usr/local/bin/mirage').with_target('/usr/local/opam/system/bin/mirage') }
        end

        context "mirage class wth user and opam_root" do
          let(:params) {{ :user => 'vagrant', :opam_root => '/home/vagrant/.opam' }}

          it { is_expected.to contain_exec('install mirage').with_user('vagrant') }
          it { is_expected.to contain_exec('install depext').with_user('vagrant') }
          it { is_expected.to contain_exec('initialize opam').with_user('vagrant').with_creates('/home/vagrant/.opam') }

          it { is_expected.to contain_file('/usr/local/bin/mirage').with_target('/home/vagrant/.opam/system/bin/mirage') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'mirageos class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('mirage') }.to raise_error(Puppet::Error) }
    end
  end
end
