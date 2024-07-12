#!/bin/bash
# Script to deploy the backend and frontend to the EC2 instance

# Navigate to the backend directory and start the backend server
cd /home/ec2-user/backend
./start_backend.sh &

# Navigate to the frontend directory and serve the frontend
cd /home/ec2-user/frontend
npm install -g serve
serve -s build -l 80
