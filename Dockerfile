FROM node:11
WORKDIR /usr/src/app
ENV NODE_ENV=production
ENV PORT=3000
COPY ./server/ ./
COPY ./package* ./
RUN npm ci --only=production

EXPOSE 3000

CMD ./bin/www
