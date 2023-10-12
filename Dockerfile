FROM ubuntu:22.04
LABEL authors="Anton Georgiev"

ENV LIBREOFFICE_VERSION=7.5.7

RUN apt-get update && apt-get install -y \  
  default-jre-headless \
  libcairo2 \ 
  libxinerama1 \ 
  libxt6 \
  wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://download.documentfoundation.org/libreoffice/stable/${LIBREOFFICE_VERSION}/deb/x86_64/LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz

ADD install-libreoffice.sh /
RUN chmod +x /install-libreoffice.sh
RUN /install-libreoffice.sh LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz
RUN rm LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz

RUN ["/bin/sh", "-c", "mv LibreOffice_* unarchivedLO"] # sometimes the unarchived directory contains additional characters
WORKDIR unarchivedLO/DEBS/

RUN dpkg -i *.deb
RUN rm -rf *.deb

RUN ["/bin/sh", "-c", "ln -s /usr/local/bin/libreoffice* /usr/bin/soffice"]

