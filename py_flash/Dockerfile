# Use slimmer python:3.6-alpine base image
FROM python:3.6-alpine
RUN apk add --no-cache expat=2.5.0-r0 openssl=1.1.1v-r0 zlib=1.2.12-r2
# Set non-root user
RUN addgroup -S app && adduser -S app -G app
USER app

# Copy requirements and install
COPY ./py_flash /app
WORKDIR /app
RUN pip install -r requirements.txt --upgrade

# Run app
ENTRYPOINT ["python"]
CMD ["app.py"]
