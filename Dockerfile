FROM node:15
WORKDIR /app
COPY package.json .

ARG NODE_ENV
# bash script for checking if environment is production or development.
RUN if [ "$NODE_ENV" = "development" ]; \
        then npm install; \
        else npm install --only=production; \
        fi
COPY . ./
EXPOSE $PORT
CMD ["npm", "index.js"]