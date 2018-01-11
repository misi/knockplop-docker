FROM node:9

RUN npm install -g bower \
    && npm install -g node-inspect

RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.14.0/confd-0.14.0-linux-amd64 -O /bin/confd \
    && chmod +x /bin/confd

ENV KNOCKPLOP_GIT_REPO=https://github.com/so010/knockplop.git
# it selects branch develop as of 15th Nov 2017
ENV KNOCKPLOP_GIT_REF=10fb311b628e9366d2aea7c68710e5639ad5a799

WORKDIR /opt/knockplop

RUN git clone $KNOCKPLOP_GIT_REPO . \
    && git checkout $KNOCKPLOP_GIT_REF

RUN npm install \
    && bower install --allow-root

RUN cp client-config.js.dist client-config.js

COPY self-signed-certs/cert.pem /etc/self-signed-certs/
COPY self-signed-certs/key.pem /etc/self-signed-certs/
COPY entrypoint.sh .
COPY confd /etc/confd

ENTRYPOINT ["./entrypoint.sh"]
CMD ["node", "server.js"]
