# By Martin Siegbahn 2015-05-06
# A simple SW to log temperature with a Raspberry Pi, with DS18b20 connected.
# It generates two text-files, one with accumulated time-stamp plus temperature for every minute
# and a second file with just the latest time and the temperature value.
# The following needs to be done in order to run the script on a RPi B+
# sudo nano /etc/modules
#	>add "w1-gpio"
#	>add "w1-therm"
# sudo nano /boot/config.txt
#	>add "dtoverlay=w1-gpio,gpiopin=4"

import os
import glob
import time
import datetime

#os.system('sudo modprobe w1-gpio')  #Needed for RPi model B
#os.system('sudo modprobe w1-therm') #Needed for RPi model B

base_dir = '/sys/bus/w1/devices/'
device_folder = glob.glob(base_dir + '28*')[0]
device_file = device_folder + '/w1_slave'

def read_temp_raw():
	f= open(device_file, 'r')
	lines= f.readlines()
	f.close()
	return lines

def read_temp():
	lines = read_temp_raw()
	while lines[0].strip()[-3:] != 'YES':
	 time.sleep(0.2)
	 lines = read_temp_raw()
	equals_pos = lines[1].find('t=')
	if equals_pos != -1:
	 temp_string = lines[1][equals_pos+2:]
	 temp_c = float(temp_string) / 1000.0
	ts = time.time()
	st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
	log_entry=str(st)+' '+str(temp_c)+'\n'
	return log_entry

while True:
 ts1=time.time()
 temp_log_entry=read_temp()
 f = open('TempLog.txt','a')
 g = open('TempLastValue.txt','w')
 f.write(temp_log_entry)
 g.write(temp_log_entry)
 g.close()
 f.close()
 ts2=time.time()
 delay=59.91-(ts2-ts1)
 time.sleep(delay)

