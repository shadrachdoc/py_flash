# Use a small base image
FROM python:3.6-alpine

# Set non-root user
RUN addgroup -S app && adduser -S app -G app
USER app

# Install dependencies
RUN apk add --no-cache gcc libc-dev linux-headers

# Copy requirements and install
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy app source last for better caching
COPY . .

# Run app
ENTRYPOINT ["python"]
CMD ["app.py"]
