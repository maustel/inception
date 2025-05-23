FROM debian:latest
# RUN apt update -y && apt install make
WORKDIR /app
COPY ex00 /app
# RUN make

#for keeping running the container:
CMD ["tail", "-f"]

# in terminal: docker exec -it container_name /bin/bash
# -> runs the container in terminal mode and I can use this terminal

#docker build -t image-name .
# -t gives it a name, the . tells docker where to find the dockerfile
