#!/usr/bin/env python3

'''
configure rtsp servers for each webcam
in each watcher device from a locally
created json file
'''

import sys
import os
import json

CAMS_JSON_FILE = os.environ['ELISE_ROOT_DIR'] + '/watcher/cams.json'

try:
    OPTION = sys.argv[1]

except:
    print("[!] Missing a required argument!")
    sys.exit(1)

def import_cams_json(cams_json_file):
    """import a required json file that has 
    all the elements defined for the webcams"""

    with open(cams_json_file) as cams_json:
        data = json.load(cams_json)

    return data

def install_packages(host):
    """clone v4l2rtspserver and build from source"""

    install_steps = "\
        sudo apt update -y && \
        sudo apt install -y git cmake && \
        git clone https://github.com/mpromonet/v4l2rtspserver.git && \
        cd v4l2rtspserver && \
        cmake . && \
        make && \
        make install && \
        sudo apt-get install -y \
            v4l-utils \
            uvcdynctrl \
    "
    
    os.system(
        "ssh " + host + \
        " 'if [ -z $(which v4l2rtspserver) ]; then " + install_steps + "; fi'"
    )

def start_stream(host, device, port, username, password, name):
    """start an rtsp server using provided parameters"""

    # configure webcams
    os.system(
        "ssh " + host + \
        " 'sudo v4l2-ctl -d " + device + " --set-ctrl=led1_mode=0 && \
           sudo v4l2-ctl -d " + device + " --set-ctrl=sharpness=255 && \
           sudo v4l2-ctl -d " + device + " --set-ctrl=focus_auto=0 && \
           sudo v4l2-ctl -d " + device + " --set-ctrl=focus_absolute=0'"
    )

    # start streams
    os.system(
        "ssh " + host + \
        " 'sudo v4l2rtspserver" + \
              " -P " + port + \
              " -p " + port + \
              " -U " + username + ":" + password + \
              " -W " + "640" + \
              " -H " + "480" + \
              " -u " + name + \
              " " + device + " 1> /dev/null &'"
    )

def stop_stream(host):
    """kill each pid for each streaming device"""

    os.system(
        "ssh " + host + \
        " 'for pid in $(/bin/pidof v4l2rtspserver); do sudo kill -9 $pid; done'"

    )

if OPTION == "install":
    for item in import_cams_json(CAMS_JSON_FILE):
        install_packages(
            item['host']
        )

elif OPTION == "start":
    for item in import_cams_json(CAMS_JSON_FILE):
        for source in item['sources']:

            if source['enabled']:
                start_stream(
                    item['host'],
                    source['device'],
                    source['port'],
                    source['username'],
                    source['password'],
                    source['name']
                )

elif OPTION == "stop":
    for item in import_cams_json(CAMS_JSON_FILE):
        stop_stream(
            item['host']
        )
