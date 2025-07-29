# Use a lightweight base image with Python 3.11
FROM python:3.11-slim

# Set working directory inside the container
WORKDIR /app

# Install system-level dependencies for Python packages (e.g., duckdb, pandas, boto3, etc.)
RUN apt-get update && \
    apt-get install -y gcc libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Install required Python libraries
RUN pip install --no-cache-dir \
    boto3 \
    pandas \
    openpyxl \
    duckdb \
    xlsxwriter

# Optional: Copy a placeholder script or test file if needed (commented out)
# COPY script.py .

# Set default command for testing (can be overridden by Kestra task)
CMD ["python3"]



# # p10/Dockerfile
# FROM python:3.11-slim

# # Install system deps for pandas, openpyxl, etc.
# RUN apt-get update && \
#     apt-get install -y gcc libpq-dev && \
#     rm -rf /var/lib/apt/lists/*

# # Install all required Python libraries up front
# RUN pip install \
#       boto3 \
#       pandas \
#       openpyxl \
#       duckdb \
#       xlsxwriter

# WORKDIR /app
