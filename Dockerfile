# ==================================
# STAGE 1: BUILD THE REACT FRONTEND (Build Layer)
# ==================================
FROM node:18-alpine as builder

# Set working directory
WORKDIR /app

# **FIXED SYNTAX:** Copy package files explicitly to the directory
COPY package.json ./
COPY package-lock.json ./

# Install dependencies
RUN npm install

# Copy all source code (Make sure your .dockerignore is in place!)
COPY . .

# Run the production build command
RUN npm run build

# ==================================
# STAGE 2: CREATE THE FINAL IMAGE (Serve Layer)
# ==================================
# Use the smallest official Nginx image (Alpine) to serve the static files
FROM nginx:alpine

# Vite build output
COPY --from=builder /app/dist /usr/share/nginx/html
# Expose the standard HTTP port
EXPOSE 80

# The default Nginx command will run, serving the content.
CMD ["nginx", "-g", "daemon off;"]
