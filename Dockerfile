# --- Stage 1: Build the React Frontend ---
FROM node:20-alpine AS frontend-builder
WORKDIR /build/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build

# --- Stage 2: Set up the Python Backend & Serve ---
FROM python:3.11-slim
WORKDIR /app

# Install system dependencies required by MediaPipe and OpenCV
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libgles2 \
    && rm -rf /var/lib/apt/lists/*

# Install python dependencies
COPY backend/requirements.txt ./backend/
RUN pip install --no-cache-dir -r backend/requirements.txt

# Copy backend files and ML model artifacts keeping the original structure
COPY backend/ ./backend/
COPY modeling_result/ ./modeling_result/

# Copy the frontend build artifacts into the backend's static directory
COPY --from=frontend-builder /build/frontend/dist ./backend/static

# Expose Hugging Face's target port
EXPOSE 7860

# Run uvicorn pointing to main.py inside the backend folder
CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "7860"]