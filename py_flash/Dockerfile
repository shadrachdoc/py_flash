FROM python:3.6
COPY ./py_flash /app
WORKDIR /app
RUN ls -la
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
