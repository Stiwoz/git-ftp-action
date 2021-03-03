FROM ubuntu:18.04

COPY LICENSE README.md /

# Set cURL compile flags
ENV CPPFLAGS=-I/usr/local/include
ENV LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"
ENV LIBS="-ldl"

# Install cURL libs
RUN apt-get update
RUN apt-get install build-essential debhelper libssh-dev -y

WORKDIR /opt/

# Fetch cURL source code
RUN apt-get source curl
RUN apt-get build-dep -y curl
RUN cd curl-*/debian/ && sed -i -e "s@CONFIGURE_ARGS += --without-libssh2@CONFIGURE_ARGS += --with-libssh2@g" rules
RUN cd curl-*/ && dpkg-buildpackage -uc -us -b
RUN dpkg -i curl_*.deb
RUN dpkg -i libcurl3-*.deb
RUN dpkg -i libcurl3-gnutls_*.deb
RUN dpkg -i libcurl4-gnutls-dev_7.58.0-2ubuntu3.8_amd64.deb libcurl4_7.58.0-2ubuntu3.8_amd64.deb

# ================================================

WORKDIR /

RUN apt-get install bash curl git -y
RUN curl https://raw.githubusercontent.com/git-ftp/git-ftp/1.6.0/git-ftp > /bin/git-ftp
RUN chmod 755 /bin/git-ftp

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
