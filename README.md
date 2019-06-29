docker-eros-trusty
=========================

Build yourself
```
git clone https://github.com/anh0001/docker-eros-trusty.git
docker build --rm -t anhrisn/eros_trusty:desktop docker-eros-trusty
```

Run
Note: C Shared Drive must be enabled in the Docker GUI settings
```
docker run -it --rm -p 6080:80 -v C:\Users\anhar\Documents\codes\humanoid_op_ros:/home/ubuntu/codes anhrisn/eros_trusty:desktop
```

Browse http://127.0.0.1:6080/

<img src="https://raw.github.com/fcwu/docker-ubuntu-vnc-desktop/master/screenshots/lxde.png" width=400/>


Connect with VNC Viewer and protect by VNC Password
==================

Forward VNC service port 5900 to host by

```
docker run -it --rm -p 6080:80 -p 5900:5900 anhrisn/eros_trusty:desktop
```

Now, open the vnc viewer and connect to port 5900. If you would like to protect vnc service by password, set environment variable `VNC_PASSWORD`, for example

```
docker run -it --rm -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=mypassword anhrisn/eros_trusty:desktop
```

A prompt will ask password either in the browser or vnc viewer.


Troubleshooting
==================

1. boot2docker connection issue, https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/2


License
==================

See the LICENSE file for details.
