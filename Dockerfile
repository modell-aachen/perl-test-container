FROM perl:5.20.2

RUN cpanm Carton

WORKDIR /usr

COPY cpanfile /usr
RUN carton install