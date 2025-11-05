#!/bin/bash


# Start frontend and backend concurrently
echo "🚀 Starting frontend and backend..."

# Run frontend in background
npm run dev &

# Move to backend folder and run server
cd server
npm run start

# Wait for both to finish
wait
