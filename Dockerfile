FROM ubuntu:22.04
LABEL authors="Anton Georgiev"

ENV LIBREOFFICE_VERSION=7.6.2

RUN apt-get update && apt-get install -y \
  default-jre-headless \
  libcairo2 \
  libxinerama1 \
  libxt6 \
  wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# downloading, extracting, installing and cleanup in one docker layer to minimize size
RUN wget https://download.documentfoundation.org/libreoffice/stable/${LIBREOFFICE_VERSION}/deb/x86_64/LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz && \
  mkdir LibreOffice && \
  tar xzf LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz -C LibreOffice --strip-components 1 && \
  rm LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz && \
  cd LibreOffice/DEBS && \
  dpkg -i *.deb && \
  rm -rf *.deb

RUN ["/bin/bash", "-c", "ln -s /usr/local/bin/libreoffice* /usr/bin/soffice"]
RUN /usr/bin/soffice --version
