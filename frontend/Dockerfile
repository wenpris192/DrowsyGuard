FROM node:22-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy frontend source code
COPY . .

# Accept the production API URL as a build argument
ARG VITE_API_BASE
ENV VITE_API_BASE=$VITE_API_BASE

# Build the optimized production static files
RUN npm run build

EXPOSE 3000

# Serve the production build
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "3000"]