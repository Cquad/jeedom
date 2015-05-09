FROM fedora
MAINTAINER cedric.olivier@free.fr

RUN yum -y update && yum clean all
RUN yum -y install npm && yum clean all

EXPOSE 8070

CMD ["node", "/usr/share/nginx/www/jeedom/core/nodeJS/server.js"]
