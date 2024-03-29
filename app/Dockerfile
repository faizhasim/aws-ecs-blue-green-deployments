FROM node:20-alpine

ADD package.json package.json
ADD yarn.lock yarn.lock
RUN yarn install
ADD index.js index.js

CMD node index.js
