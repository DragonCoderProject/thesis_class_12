# coding=utf-8
import subprocess


def qt_instalator ():
    subprocess.Popen('sudo apt-get install qttools5-dev-tools', shell=True)

def gps_daemon ():
    subprocess.Popen('sudo apt-get install gpsd gpsd-clients', shell=True) #wir laden die gpsd pakete unter
    subprocess.Popen('sudo systemctl stop gpsd.socket', shell=True) # wir schalten die gpsd service aus, die bei der installaion angeschalten wurden
    subprocess.Popen('sudo systemctl disable gpsd.socket', shell=True) # wir blenden die service aus
    subprocess.Popen('sudo gpsd /dev/ttyUSB0 -F /var/run/gpsd.sock', shell=True) # wir schalte das gpsd manuell an
    subprocess.Popen('sudo killall gpsd', shell=True) #wir machen alle gpsd service aus
    subprocess.Popen('sudo gpsd /dev/ttyUSB0 -F /var/run/gpsd.sock', shell=True) # und schalten wir wieder an

    # das aus- und dann wieder anschalten von den gpsd servicen ist eine Sicherheitsannahme, wenn sie
    # bei dem ersten mal nicht angeschalten werden, wa manchmal vorkommmen kann

def install_pip_python (): # package manager für Python Pakete
    subprocess.Popen('sudo apt-get install python3-pip', shell=True)

def install_i2c_tools ():
    subprocess.Popen('sudo apt-get install python-smbus i2c-tools', shell=True)

def install_appjar ():
    subprocess.Popen('sudo pip3 install appjar', shell=True)
    subprocess.Popen('sudo apt-get install python3-tk', shell=True)

def give_read_write_right_for_usb ():
    subprocess.Popen('sudo chmod 666 /dev/ttyUSB0', shell=True)

def main ():
    qt_instalator ()
    gps_daemon ()
    give_read_write_right_for_usb ()

if __name__ == '__main__':
    subprocess.Popen('sudo apt-get update', shell=True).wait()
    main()
