FROM node:11
WORKDIR /usr/src/app
ENV NODE_ENV=production
COPY ./server/public ./
COPY ./server/assets.json ./
RUN mkdir bin
COPY ./server/bin ./bin
COPY ./package.json ./
RUN npm install

EXPOSE 8000

CMD ./bin/www
