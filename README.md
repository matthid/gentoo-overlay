# Info

This layman overlay for gentoo linux contains some packages I use myself and are missing/outdated in the portage tree.

Examples / Highlights:
* seafile-2.1.3 with apache and seahub support (!)
* Tine20 (!)
* SOGo-2.0.7 (not used anymore, replaced with tine20)
* gitflow (!)
* prosody with sasl support 
* Eclipse with icedtea support (outdated)

# Issues
If you have issues just open an issue here.

## Known Issues:

### seafile
For webdav support you have to copy some contents from the binary distribution file to your installation dir.
You also have to edit the /var/lib/seafile/default/seafile-server/seafile.sh file:
```
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
And you should edit the /et /etc/init.d/seafile-se file to your needs.
Note that those changes are gone after  reinstallatio, so make sure to make copies!

# Installation

Follow http://www.gentoo-wiki.info/TIP_Sync_your_private_overlay.
Basically all you have to do is to add https://raw.github.com/matthid/gentoo-overlay/master/repositories.xml to your overlays in /etc/layman/layman.cfg:

/etc/layman/layman.cfg

    overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
		https://raw.github.com/matthid/gentoo-overlay/master/repositories.xml

Now just execute:

    layman -S
    layman -a dragon

Maybe you also have to add the lua, gnustep and sunrise Overlay because I depend on some packages of those overlays. (If you get some missing ebuild errors)

# Notes
Contact me: matthid@idoop.de (jabber); matthi.d@gmail.com (email); 
http://redmine.yaaf.de/projects/matthias/wiki (German).

This Overlay is used to build your own homeserver with Gentoo: http://redmine.yaaf.de/projects/matthias/wiki/Homeserver (German)

Some credits:

* The Sope and SOGo ebuild were originally taken from the gnustep-apps overlay and were updated to the latest sogo Version (http://overlays.gentoo.org/proj/gnustep). 
* The Prosody and Spectrum ebuilds are taken from the wonderfull rion overlay (http://code.google.com/p/rion-overlay).
* The Eclipse ebuild was taken from the seden overlay (http://gpo.zugaina.org/Overlays/seden)
