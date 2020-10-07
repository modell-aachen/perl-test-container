# The perl version we use is the lowest version we support, i.e. the version deployed on RHEL Systems
FROM perl:5.20.2

ARG GIT_VERSION=2.24.0-rc2

RUN mkdir -p /usr/install
WORKDIR /usr/install

COPY aptfile /usr/install
COPY cpanfile /usr/install
COPY git-${GIT_VERSION}.tar.gz /usr/install

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update && xargs -a aptfile apt-get install -y --force-yes

# install a newer version of git to work with action/checkout in github actions
RUN tar -zxf git-$GIT_VERSION.tar.gz &&\
  cd git-$GIT_VERSION &&\
  make configure &&\
  ./configure --prefix=/usr &&\
  make install

RUN cpanm Carton
RUN carton install

WORKDIR /usr/working
ENV PERL5LIB /usr/install/local/lib/perl5:/usr/share/perl5/5.20:/usr/share/perl5:/usr/working/lib:/usr/working/backend-tests:/usr/working/lib:/usr/working/integration-tests:/usr/lib/x86_64-linux-gnu/perl5/5.20
