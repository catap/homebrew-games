require 'formula'

class Openttd < Formula
  homepage 'http://www.openttd.org/'
  url 'http://binaries.openttd.org/releases/1.4.1/openttd-1.4.1-source.tar.gz'
  sha1 '3e4c88cd68a878ffcd723813c809fc42f24935c2'

  head 'git://git.openttd.org/openttd/trunk.git'

  depends_on 'lzo'
  depends_on 'xz'
  depends_on 'pkg-config' => :build

  resource 'opengfx' do
    url 'http://bundles.openttdcoop.org/opengfx/releases/0.5.0/opengfx-0.5.0.zip'
    sha1 '963e5e8052a286af269b2837cf3741c3d6c746eb'
  end

  resource 'opensfx' do
    url 'http://bundles.openttdcoop.org/opensfx/releases/0.2.3/opensfx-0.2.3.zip'
    sha1 'bfbfeddb91ff32a58a68488382636f38125c48f4'
  end

  resource 'openmsx' do
    url 'http://bundles.openttdcoop.org/openmsx/releases/0.3.1/openmsx-0.3.1.zip'
    sha1 'e9c4203923bb9c974ac67886bd00b7090658b961'
  end

  def patches
    p = {
      :p0 => [
        # Ensures a deployment target is not set on 10.9;
        # TODO report this upstream
        'https://trac.macports.org/export/117147/trunk/dports/games/openttd/files/patch-config.lib-remove-deployment-target.diff'
      ]
    }
  end

  def install
    system "./configure", "--prefix-dir=#{prefix}"
    system "make bundle"

    (buildpath/'bundle/OpenTTD.app/Contents/Resources/data/opengfx').install resource('opengfx')
    (buildpath/'bundle/OpenTTD.app/Contents/Resources/data/opensfx').install resource('opensfx')
    (buildpath/'bundle/OpenTTD.app/Contents/Resources/gm/openmsx').install resource('openmsx')

    prefix.install 'bundle/OpenTTD.app'
  end

  def caveats; <<-EOS.undent
      OpenTTD.app installed to: #{prefix}
      If you have access to the sound and graphics files from the original
      Transport Tycoon Deluxe, you can install them by following the
      instructions in section 4.1 of #{prefix}/readme.txt
    EOS
  end
end
