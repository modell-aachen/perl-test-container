FROM perl:5.20.2

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
  libcarp-always-perl\
  netcat\
  watch\
  gettext

RUN cpanm Carton \
  Minion \
  Mojo::Pg

RUN mkdir -p /usr/install

WORKDIR /usr/install

COPY git-2.24.0-rc2.tar.gz /usr/install

# evil hack because github doesn't like outdated git versions because whysoever
RUN tar -zxf git-2.24.0-rc2.tar.gz &&\
  cd git-2.24.0-rc2 &&\
  make configure &&\
  ./configure --prefix=/usr &&\
  make install

COPY cpanfile /usr/install
RUN carton install

ENV PERL5LIB /usr/install/local/lib/perl5:/usr/share/perl5/5.20:/usr/share/perl5:/usr/working/lib:/usr/working/backend-tests:/usr/working/lib:/usr/working/integration-tests:/usr/lib/x86_64-linux-gnu/perl5/5.20
