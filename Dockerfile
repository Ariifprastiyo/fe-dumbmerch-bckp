FROM node:16-alpine as staging
WORKDIR /app

COPY . .

RUN yarn install

EXPOSE 3000
CMD [ "yarn", "start"]
