FROM nginx:alpine
ARG BUILD_NUMBER
COPY index.html /usr/share/nginx/html
RUN sed "s#BUILD_NUMBER#$BUILD_NUMBER#g" -i /usr/share/nginx/html/index.html