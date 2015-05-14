#!/bin/bash

# 'Surveillance System build using Raspberry pi - A small IOT application built by team Vnoon from KTH
# 'at Ericsson E-Hackathon,2015 Stockholm.
# 'over all system model
# ' |UI with VBA |<-------->|Server on Linux|<----------->|Raspberry pi sensor Node|
# '                                                             |
# '                                                             |
# '                                                             |
# '                               |Web server for Mobile Platform real time data Visualization|
# 'This library is distributed in the hope that it will be useful,
# 'but WITHOUT ANY WARRANTY; without even the implied warranty of
# 'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# 'Team Vnoob-
        # 'Balasubramanian Rajasekaran <roboticsbala@gmail.com>,
        # 'Manish Sonal <reply4manish@gmail.com>
        # 'Sharan Kumaar Ganesan <mew2sharan@gmail.com>
        # 'Deepa Krishnamurthy <krishnamurthy.deepa@gmail.com>,
        # 'Sunil kallur Ramegowda <kallur.sunil@gmail.com>,



PATH=/home/sunil/Applications/sbt/bin:/home/sunil/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/home/sunil/Desktop/Data/Data
ip_add_list_file=$1


tempdir=`mktemp -d /var/tmp/LAMOS.pingtest.result.XXX`
date=`date`

while read addr ; do ( ping -c 1 -w 1 $addr > /dev/null 2>&1 ; if [ $? == 0 ] ; then touch $tempdir/$addr ; fi ) &  done < $ip_add_list_file
wait
while read addr ; do if [ -e $tempdir/$addr ] ; then echo "$date;Pass;$addr" ;rsync -ac --remove-source-files --exclude '*.py' pi@$addr:/home/pi/Data /home/sunil/Desktop/Data;cd /home/sunil/Desktop/Data/Data;ls -ltr | awk '{ field = $NF }; END{ print field }' | xargs -I '{}' mv '{}' Latest.jpg; else echo "$date;Fail;$addr" ; fi done < $ip_add_list_file
rm -r $tempdir > /dev/null 2>&1
