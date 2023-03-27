# alpine is a lightweight version of linux and it is ideal for Docker containers
FROM python:3.9-alpine3.13
LABEL maintainer="Sharrod Hines"

# Tells Python that you don't want to buffer the output
ENV PYTHONUNBUFFERED 1

# Copies the requirements file in our code into the container
COPY ./requirements.txt /tmp/requirements.txt
# Copies the app directory file in our code into the container
COPY ./app /app
# WORKDIR sets the working directory /default directory that our commands will run from
WORKDIR /app
# Exposes port 8000 from our container to our machine when we run the container 
EXPOSE 8000

# Runs a command on the alpine image with new lines from && \
RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user