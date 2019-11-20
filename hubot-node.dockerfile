FROM node:latest

LABEL maintainer="yuchen-liu<steny138@gmail.com>"

ENV HUBOT_GRAFANA_HOST='http://play.grafana.org'
ENV HUBOT_GRAFANA_API_KEY=''
ENV HUBOT_GRAFANA_PER_ROOM=''
ENV HUBOT_GRAFANA_QUERY_TIME_RANGE='6h'
ENV HUBOT_GRAFANA_DEFAULT_WIDTH='1000'
ENV HUBOT_GRAFANA_DEFAULT_HEIGHT='500'
ENV HUBOT_GRAFANA_S3_ENDPOINT='s3.amazonaws.com'
ENV HUBOT_GRAFANA_S3_BUCKET=''
ENV HUBOT_GRAFANA_S3_ACCESS_KEY_ID=''
ENV HUBOT_GRAFANA_S3_SECRET_ACCESS_KEY=''
ENV HUBOT_GRAFANA_S3_PREFIX=''
ENV HUBOT_GRAFANA_S3_REGION=''
ENV HUBOT_SLACK_TOKEN=''
ENV HUBOT_NAME=lychubot
ENV HUBOT_OWNER=yuchenliu
ENV HUBOT_DESCRIPTION=Hubot

ENV EXTERNAL_SCRIPTS "hubot-help,hubot-pugme,hubot-grafana"
ENV DEBIAN_FRONTEND noninteractive

RUN useradd hubot -m

RUN npm install -g hubot coffeescript yo generator-hubot

USER hubot

WORKDIR /home/hubot

RUN yo hubot --owner="${HUBOT_OWNER}" \
--name="${HUBOT_NAME}" \
--description="${HUBOT_DESCRIPTION}" \
--defaults && \
npm install hubot-slack --save

VOLUME ["/home/hubot/scripts"]

CMD node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
	npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))") && \
	bin/hubot -n $HUBOT_NAME --adapter slack