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

First We have to run a mysql container <= 5.6.21 (Actually there is a bug with PDO and mysql > 5.6.21 so we con't use mysql:latest)

```
docker run -d --name jeedom-mysql -e MYSQL_ROOT_PASSWORD=password mysql:5.6.21
```

Launch a data container. This data container will install jeedom on mysql DB :

```
docker run --name jeedom-data --link jeedom-mysql:mysql cquad/jeedom-data
```

A container with nodejs :

```
docker run -d --name jeedom-nodejs --volumes-from jeedom-data cquad/jeedom-nodejs
```

And finally the main container, web front :

```
docker run -d --name jeedom-web --volumes-from jeedom-data \
	--link jeedom-mysql:mysql \
	--link jeedom-nodejs:nodejs \
	cquad/jeedom-web
```

If you'd like to be able to access the instance from the host without the container's IP, standard port mappings can be used:

```
docker run -d --name jeedom-web  --volumes-from jeedom-data \
	--link jeedom-mysql:mysql \
	--link jeedom-nodejs:nodejs \
	-p 8080:8080 cquad/jeedom-web
```

Then, access it via http://localhost:8080 or http://host-ip:8080 in a browser.

If you'd like to use an usb device (such as Zwave Stick), device mappings can be used :

```
docker run -d --name jeedom-web --volumes-from jeedom-data \
	--link jeedom-mysql:mysql \
	--link jeedom-nodejs:nodejs \
	--device=/dev/ttyACM0:/dev/ttyACM0 \
	-p 8080:8080 -p 8083:8083 cquad/jeedom-web
```

if USB Key is used, you also have to map 8083 for OpenZwave service.

You can specify a specific host name for container with -h option :

```
docker run -d --name jeedom-web --volumes-from jeedom-data \
        --link jeedom-mysql:mysql \
        --link jeedom-nodejs:nodejs \
        --device=/dev/ttyACM0:/dev/ttyACM0 \
        -h name.domain \
	-p 8080:8080 -p 8083:8083 cquad/jeedom-web

```
