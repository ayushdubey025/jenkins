# Build stage
FROM node:21.6.1-alpine AS build

WORKDIR /app

# Copy package.json and package-lock.json (if available) separately and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the app using Vite
RUN npm run build --verbose

# Verify if the build directory was created
RUN ls dist  # Vite creates the build in dist

# Serve stage
FROM nginx:alpine

# Copy the build files to nginx's default public directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
