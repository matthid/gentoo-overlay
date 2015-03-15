# Info

This layman overlay for gentoo linux contains some packages I use myself and are missing/outdated in the portage tree.

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
You also have to edit the /var/lib/seafile/default/seafile-server/seafile.sh file:

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
Note that those changes are gone after reinstallation, so make sure to make copies!

# Installation

Follow http://www.gentoo-wiki.info/TIP_Sync_your_private_overlay.
Basically all you have to do is to add https://raw.github.com/matthid/gentoo-overlay/master/repositories.xml to your overlays in /etc/layman/layman.cfg:

/etc/layman/layman.cfg

    overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
		https://raw.github.com/matthid/gentoo-overlay/master/repositories.xml

Now just execute:

    layman -S
    layman -a dragon

# Notes
Contact me: matthi.d@gmail.com (email); 
http://redmine.yaaf.de/projects/matthias/wiki (German).

This Overlay is used to build your own homeserver with Gentoo: http://redmine.yaaf.de/projects/matthias/wiki/Homeserver (German)

Some credits:

* The Prosody and Spectrum ebuilds are initially taken from the wonderfull rion overlay (http://code.google.com/p/rion-overlay).
