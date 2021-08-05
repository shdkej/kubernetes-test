FROM python:3.10.0rc1-alpine3.13

RUN apk add --no-cache --virtual=build-deps build-base && \
                                 apk add --no-cache g++ && \
                                 pip3 install locust pyzmq && \
                                 apk del --no-cache build-deps

WORKDIR /locust
COPY scenario.py /locust/

ENTRYPOINT [ "/usr/local/bin/locust" ]

EXPOSE 8089 5557 5558
