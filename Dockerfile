FROM python:3.11-slim
# Start with Linux + Python 3.11

WORKDIR /app
# Create working location /app

COPY requirements.txt .
# Copy dependencies

RUN pip install \
    --no-cache-dir \
    -r requirements.txt
# Install requiements

COPY . .
# app.py loan_model.py models/

# Make the startup script executable
RUN chmod +x start.sh

# Document both application ports
EXPOSE 8501 8000

# Start Streamlit (Must be on a single line)
# CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0", "--server.port=8501"]

# Start both applications using the shell script
CMD ["./start.sh"]

# you cannot use CMD twice in a Dockerfile. Docker only executes the very last CMD instruction. If you put two CMD lines, the first one is completely ignored.