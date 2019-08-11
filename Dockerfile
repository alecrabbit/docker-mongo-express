FROM node:lts-alpine

ENV PATH /scripts:/scripts/aliases:$PATH
ENV MONGO_EXPRESS 0.53.0
# override some config defaults with values that will work better for docker
ENV ME_CONFIG_EDITORTHEME="default" \
    ME_CONFIG_MONGODB_SERVER="mongo" \
    ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    ME_CONFIG_BASICAUTH_USERNAME="" \
    ME_CONFIG_BASICAUTH_PASSWORD="" \
    VCAP_APP_HOST="0.0.0.0"

COPY ./aliases/* /scripts/aliases/
COPY docker-entrypoint.sh /

RUN apk add --no-cache bash tini \
    && npm install mongo-express@$MONGO_EXPRESS

WORKDIR /node_modules/mongo-express

RUN cp config.default.js config.js

EXPOSE 8081

ENTRYPOINT [ "tini", "--", "/docker-entrypoint.sh"]
CMD ["mongo-express"]

