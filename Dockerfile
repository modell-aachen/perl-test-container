FROM perl:5.20.2

RUN apt-get update && apt-get install -y \
  watch

RUN cpanm Carton && mkdir -p /usr/install

WORKDIR /usr/install

COPY cpanfile /usr/install
RUN carton install

ENV PERL5LIB /usr/install/local/lib/perl5:/usr/working/lib:/usr/working/backend-tests:/usr/working/lib:/usr/working/integration-tests
