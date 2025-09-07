FROM node:20-alpine
WORKDIR /app
COPY package.json ./
RUN npm install --omit=dev
COPY index.js ./
COPY run.mjs ./
ENV NODE_ENV=production
ENV port=3000
EXPOSE 3000
CMD ["node", "run.mjs"]
