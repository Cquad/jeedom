# What is Jeedom ?

The Jeedom software is open source, you have full access to the software which manages your home automation system.

Jeedom supports many different protocols like Zwave, RFXCOM, Somfy RTS, EnOcean, xPL etc. The plugin system on Jeedom's Market guarantees compatibility with several actual protocols but also those coming.

Jeedom does not require access to external servers to work. Your entire installation runs locally. You are the only one to have an access on it, which guarantees a complete confidentiality and safely environment.

Jeedom proposes its own Market, just like on your smartphone with Appstore or Android Market. It allows not only adding automation features, as well as customizing your display or ensures the compatibility with several new automation modules. Developers, can also publish own creations on Jeedom's Market and be paid if they wish it!

Thanks to Jeedom's Market and the plugin system, Jeedom can be linked to any connected device. Jeedom get together all information of each device on only one interface. Thus you have an immediate overview of your devices.

Multilingual, Jeedom software is already in English language and can be translated easily. Through its customizable interface, widgets, views, plugins and user management, each user can create its own view on Jeedom to realize own wishes unique automation installation.

[![Jeedom Logo] (http://jeedom.fr/images/jeedom.jpg)] (http://jeedom.fr/index.php)

[Jeedom Software] (http://jeedom.fr/index.php)

#How to use this image

This image in all in one container with mysql, nginx, nodejs, ssh, php and cron :

```
docker run -d -p 80:80 -p 22:22 -p 8070:8070 -p 9001:9001 cquad/jeedom
```
# Best practices

If you want top apply docker best practices, it 's better to launch all theses service in distinct container. See [Jeedom distinct container] (https://registry.hub.docker.com/u/cquad/jeedom-web/)

