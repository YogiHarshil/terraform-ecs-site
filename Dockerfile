FROM node:18-alpine
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
ENV NODE_ENV production
RUN npm run build
COPY .next/standalone .
COPY .next/static ./.next/static
COPY public ./public
EXPOSE 3000
CMD ["node", "server.js"] 