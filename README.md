This enviroment is meant for experiments and trials.
The enviroment mimics ROS2 structure with minimal overhead.


To get started run `init_docker.sh` to pull docker base image to match your own device.
If your device is does not have Nvidia gpu setting rename 

After pulling the docker image run `develop.sh` to get started.
Inside docker sh you can try runing two scripts util/video and util/display 
this should display the video from testData/DroneTest.mp4
tmux is recomended for runing multiple scripts.
`
tmux 
#ctrl+b -> c
util/video
#ctrl+b -> 0
util/display
`


The camera code has been previously been tesed with IMX-217
On jetson it can be configured by runing ´sudo python /opt/nvidia/jetson-io/jetson-io.py´
and sellecting the following options.
|                Configure Jetson 24pin CSI Connector                |
|                 Configure for compatible hardware                  |
|                          Camera IMX219-A                           |
|                          Save pin changes                          |
|                Save and reboot to reconfigure pins                 |

Correct configiration can be checked by runing ´ls -l /dev/video*´
it should containing video0.
This also can be used to check it works. ´nvgstcapture-1.0´
