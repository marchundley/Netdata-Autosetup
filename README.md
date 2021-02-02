# Netdata-Autosetup
Auto setup for Netdata including Mac OS caching server monitoring
Caching monitoring based on code by GitStoph - adapted from Pawel Krupa (paulfantom), with help from l2isbad
Further Information found here (https://github.com/netdata/netdata/issues/2766)


Instructions
------------


1. Open Terminal, navigate to script folder
2. Run ./Installandconfig.sh
3. Run sudo ./config.sh


Uninstallation Instructions
-------------- ------------

1. Navigate to script folder
2. Run sudo ./Uninstall.sh


Notes/Assumptions
-----------------

Assumes netdata Children and Parent are on a 10.* network
To send data to a different parent edit the [stream] setings in Installandconfig.sh
