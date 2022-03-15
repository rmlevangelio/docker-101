# installs node image - specify node version
FROM node:13-alpine

# Configure env variables
ENV MONGO_DB_USERNAME=admin\
    MONGO_DB_PWD=password

# Execute any linux command. Will create /home/app/folder
RUN mkdir -p /home/app

# Copy current folder files to /home/app
COPY . /home/app

# Executes entrypoint linux command - start app with script
# One CMD only
CMD ["node", "server.js"]