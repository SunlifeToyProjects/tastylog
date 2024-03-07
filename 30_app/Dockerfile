FROM node:16-alpine

COPY . /home/node/webapp

RUN cd /home/node/webapp; \
    mv docker-entrypoint.sh /usr/local/bin; \
    chmod +x /usr/local/bin/docker-entrypoint.sh; \
    npm install;

ENV MYSQL_HOST="127.0.0.1"
ENV MYSQL_PORT="3306"
ENV MYSQL_USERNAME="YOUR-MYSQL-USERNAME"
ENV MYSQL_PASSWORD="YOUR-MYSQL-PASSWORD"
ENV MYSQL_DATABASE="tastylog"

EXPOSE 3000

WORKDIR /home/node/webapp
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "npm", "start" ]