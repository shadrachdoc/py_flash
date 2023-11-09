FROM python:3.6
COPY . /app
WORKDIR /app
RUN ls -la
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
