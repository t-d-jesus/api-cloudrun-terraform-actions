FROM node:20-slim

WORKDIR /app

COPY api-typescript/package*.json ./
COPY api-typescript/tsconfig.json ./

RUN npm install

COPY api-typescript/src/ ./src/

RUN npm run build

EXPOSE 8080

CMD ["node", "dist/index.js"]