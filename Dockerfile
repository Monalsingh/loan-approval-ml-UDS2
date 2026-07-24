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

EXPOSE 8501
# Document application port

# Start Streamlit (Must be on a single line)
CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0", "--server.port=8501"]