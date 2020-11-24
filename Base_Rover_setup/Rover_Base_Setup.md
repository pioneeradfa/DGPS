# Installation Steps for Base and Rover Sirius-F9P and RFD900 modem 
This manual provides information for setting up the following modules:
* Base - Sirius RTK GNSS (F9P)
* Rover - Sirius RTK GNSS (F9P)
* RFD900+ Long Range Radio modem

Configure **Rover and Base Sirius-F9P** devices using u-center software
Download [u-center software!](https://www.u-blox.com/en/product/u-center)

Configure **RFD900 modem** using RFD Modem tool
Download [RFD Modem tool!](https://files.rfdesign.com.au/tools/)

# BASE [Drotek F9P]: (Windows)
The main purpose of the base is to provide a known position to the RTK system in order for the RTKLib to compute the exact position of the rover module. 
It's then necessary to have a base whose position doesn't vary in time, and with the most accurate self-positioning ability, as the more accurate is the base positioning, the more accurate will be the rover module positioning.
![Image of Base](https://github.com/pioneeradfa/DGPS/blob/master/Base_Rover_setup/images/base.png)

Download RTKLIB (windows version)
[RTKLIB Github windows Download!](https://github.com/tomojitakasu/RTKLIB_bin.git)

### Open strsvr window:

![Image of strsvr](https://github.com/pioneeradfa/DGPS/blob/master/Base_Rover_setup/images/strsvr_open.png)

```
E:\RTKLIB_bin-master\RTKLIB_bin-master\bin\strsvr.exe
```
### Setting up strsvr Serial Options
![Image of strsvr_serial](https://github.com/pioneeradfa/DGPS/blob/master/Base_Rover_setup/images/strsvr_serial.png)

Setting value of serial baud rate

1. Stream: (0) Input  
- Type: Serial   
- Port: COMx
- Bitrate (bps): 115200

### Setting up NTRIP Server Option

![Image of strsvr_ntrip](https://github.com/pioneeradfa/DGPS/blob/master/Base_Rover_setup/images/strsvr_ntrip.png)
2. Stream: (1) Output 
- Type:NTRIP Server
- NTRIP Caster Host: rtk2go.com 
- TCP Port: 2101
- Mountpoint: unswadfa
- Password: dsto

# RTK ROVER [Drotek F9P]:

![Image of Rover](https://github.com/pioneeradfa/DGPS/blob/master/Base_Rover_setup/images/rover.png)

The rover module is meant to be mounted on the vehicle that's moving. 
Whereas the base is supposed to be immobile (even though it can be mobile, which implies a loss of accuracy), 
the rover is the module receiving the corrections, providing the information to the autopilot with its position, heading, height.

### Download RTKLIB: 

[RTKLIB Github Linux Download!](https://github.com/tomojitakasu/RTKLIB.git)

### Install RTKLIB: 
```
$cd RTKLIB/lib/iers/gcc
$make
$cd RTKLIB/app
$sudo chmod +x makeall.sh
$./makeall.sh
```
### Ntrip client:
```
$ cd RTKLIB/app/str2str/gcc
```
### Authorise port connection (Rover is connected to Jackal through USB port)

COM# is the port where Base Sirius F9P is inserted into Laptop.

```
$ sudo chmod 666 /dev/ttyACM0
```

### Base reference information (Ntrip server) to Rover RTK position correction using RTKLIB

Sirius F9P Rover has a in build RTK position calculation system, so the following command will perform RTK position correction.

```
$ ./str2str -in ntrip://:dsto@rtk2go.com:2101/unswadfa -out serial://ttyACM0:11520
```

### Send RTK calculation results with ROS Topic with ublox ROS package

Receive the RTK-GNSS Fix solution of Sirius Rover “sensor_msgs/NavSatFix” and publish it with ROS Topic

### ROS_LAUNCH

```
roslaunch ublox_gps rover_sirius.launch

```
### Generate parameter files for ublox ROS package

```
dgps_ws\src\ublox\ublox_gps\config\rover_sirius.yaml 
```
The .yaml file is shown below:

```
# Configuration Settings for Sirius-F9P Rover device

debug: 1  # Range 0-4 (0 means no debug statements will print)

config_on_startup: false # use chip config

device: /dev/ttyACM0
frame_id: gps

config_on_startup: false #use chip config

uart1:
  baudrate: 115200
  in: 32
  out: 3

# Enable u-blox message publishers
publish:
  all: false
  nav:
    all: true
    relposned: true
    posllh: true
    posecef: true

```


### RosTopic Log /ublox/fix (sensor_msgs/NavSatFix)

```
$ rostopic echo /ublox/fix 

-------------------------------------------------------------------------------
header: 
  seq: 250
  stamp: 
    secs: 1597544202
    nsecs:     13159
  frame_id: "gps"
status: 
  status: 2
  service: 1
latitude: XX.6383066
longitude: XXX.0486526
altitude: 46.18
position_covariance: [0.002209, 0.0, 0.0, 0.0, 0.002209, 0.0, 0.0, 0.0, 0.0047610000000000005]
position_covariance_type: 2
-------------------------------------------------------------------------------

```

#### Definition of sensor_msgs/NavSat Status

In the above rostopic msg, /ublox/fix status.status = 2, the analysis RTX Fix solution is obtained based on the Base reference.

-fix is valid when status >= STATUS_FIX.

Status.status	|	Definition
-----------------	|	---------------------------
STATUS_NO_FIX =  -1	|	Unable to fix position
STATUS_FIX = 0	|	Unaugmented fix
STATUS_SBAS_FIX = 1	|	with satellite-based augmentation
STATUS_GBAS_FIX = 2	|	with ground-based augmentation

# RFD900 Long range modem:
![Image of RFD900](https://github.com/pioneeradfa/DGPS/blob/master/Base_Rover_setup/images/RFD900.png)

### Config (Screen shot)  
Baud rate: 115200 

![Image of RFD900](https://github.com/pioneeradfa/DGPS/blob/master/Base_Rover_setup/images/RFD900_config_success.png)


## Reference
1. https://drotek.gitbook.io/rtk-f9p-positioning-solutions/
 
