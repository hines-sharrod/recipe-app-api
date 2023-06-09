# alpine is a lightweight version of linux and it is ideal for Docker containers
FROM python:3.9-alpine3.13
LABEL maintainer="Sharrod Hines"

# Tells Python that you don't want to buffer the output
ENV PYTHONUNBUFFERED 1

# Copies the requirements files in our code into the container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# Copies the app directory file in our code into the container
COPY ./app /app
# WORKDIR sets the working directory /default directory that our commands will run from
WORKDIR /app
# Exposes port 8000 from our container to our machine when we run the container 
EXPOSE 8000

ARG DEV=false
# Runs a command on the alpine image with new lines from && \
RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user