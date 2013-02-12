# Installation

Follow http://www.gentoo-wiki.info/TIP_Sync_your_private_overlay.
Basically all you have to do is to add https://raw.github.com/matthid/gentoo-overlay/master/repositories.xml to your overlays in /etc/layman/layman.cfg:

/etc/layman/layman.cfg

    overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
		https://raw.github.com/matthid/gentoo-overlay/master/repositories.xml

Now just execute:

    layman -S
    layman -a lua
    layman -a sunrise
    layman -a gnustep
    layman -a dragon

Add the lua, gnustep and sunrise Overlay because I depend on some packages of those overlays.

# Notes
Contact me: dragon@idoop.de (jabber); matthi.d@gmail.com (email); public@chat.idoop.de (jabber conference)
http://yaaf.no-ip.org:3000/projects/matthias/wiki (German).

This Overlay is used to build your own homeserver with Gentoo: http://yaaf.no-ip.org:3000/projects/matthias/wiki/Homeserver (German)

Some credits:

* The Sope and SOGo ebuild were originally taken from the gnustep-apps overlay and were updated to the latest sogo Version (http://overlays.gentoo.org/proj/gnustep).
* The Prosody and Spectrum ebuilds are taken from the wonderfull rion overlay (http://code.google.com/p/rion-overlay).
* The Eclipse ebuild was taken from the seden overlay (http://gpo.zugaina.org/Overlays/seden)
