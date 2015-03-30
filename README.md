# Info

This layman overlay for gentoo linux contains some packages I use myself and are missing/outdated in the portage tree.

[![Join the chat at https://gitter.im/matthid/Yaaf](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/matthid/Yaaf?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Examples / Highlights:
* seafile with apache and seahub support (!)
* Tine20 (!)
* gitflow (!)
* prosody with sasl support 

# Issues
If you have issues just open an issue here.

## Known Issues:

### seafile

For webdav support you have to copy some contents from the binary distribution file to your installation dir.
I use the following setup (only required for webdav support):

```bash
# Create symbolic links:
/var/lib/seafile/default/seafile-server/seahub/thirdpart/seafobj -> /var/lib/seafile/seafobj/seafobj
/var/lib/seafile/default/seafile-server/seahub/thirdpart/wsgidav -> /var/lib/seafile/seafobj/wsgidav
# And clone seafdav and seafobj
cd /var/lib/seafile
git clone https://github.com/haiwen/seafdav.git
git checkout v3.1.7-server # use the current version
cd /var/lib/seafile
git clone https://github.com/haiwen/seafobj.git #
git checkout v3.1.7-server # use the current version
```

You also have to edit the /var/lib/seafile/default/seafile-server/seafile.sh file (always required):

```diff
--- /var/lib/seafile/default/seafile-server/seafile.sh.orig     2014-01-16 20:11:07.373505170 +0100
+++ /var/lib/seafile/default/seafile-server/seafile.sh  2014-01-16 20:11:23.793504837 +0100
@@ -17,10 +17,10 @@
 TOPDIR=$(dirname "${INSTALLPATH}")
 default_ccnet_conf_dir=${TOPDIR}/ccnet
 ccnet_pidfile=${INSTALLPATH}/runtime/ccnet.pid
-seaf_controller="${INSTALLPATH}/seafile/bin/seafile-controller"
+seaf_controller="/usr/bin/seafile-controller"


-export PATH=${INSTALLPATH}/seafile/bin:$PATH
+#export PATH=${INSTALLPATH}/seafile/bin:$PATH
 export ORIG_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
 export SEAFILE_LD_LIBRARY_PATH=${INSTALLPATH}/seafile/lib/:${INSTALLPATH}/seafile/lib64:${LD_LIBRARY_PATH}
```

And you should edit the `/etc/init.d/seafile-server/config` file to your needs.
Note that those changes are gone after re-installation, so make sure to make copies!

# Installation

Follow http://www.gentoo-wiki.info/TIP_Sync_your_private_overlay.
Basically all you have to do is to add https://raw.github.com/matthid/gentoo-overlay/master/repositories.xml to your overlays in /etc/layman/layman.cfg:

/etc/layman/layman.cfg

    overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
                https://raw.github.com/matthid/gentoo-overlay/master/repositories.xml

Now just execute:

    layman -S
    layman -a dragon

You probably need to add other overlays if you get missing ebuild errors (like rion).

# Notes
Contact me: matthi.d@gmail.com (email); 
https://docs.yaaf.de/general/index.html (partly German).

This Overlay is used to build your own home-server with Gentoo: https://docs.yaaf.de/general/reference/Homeserver.html (German)

Some credits:

* The Prosody and Spectrum ebuilds are initially taken from the wonderful rion overlay (http://code.google.com/p/rion-overlay).
