# Grab the latest alpine image
FROM alpine:latest

# Install python, pip, bash, and any other dependencies
RUN apk add --no-cache --update python3 py3-pip bash

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Activate the virtual environment and upgrade pip
RUN /opt/venv/bin/pip install --upgrade pip

# Add requirements file
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies inside the virtual environment
RUN /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Ensure the virtual environment is used by default
ENV PATH="/opt/venv/bin:$PATH"

# Run the app. CMD is required to run on Heroku
CMD gunicorn --bind 0.0.0.0:$PORT wsgi