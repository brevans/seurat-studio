FROM rocker/geospatial:3.6.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install autotools-dev \
                build-essential \
                cairo-5c \
                cdbs \
                git \
                libfftw3-dev \
                libauthen-sasl-perl \
                libencode-locale-perl \
                libfile-basedir-perl \
                libfile-desktopentry-perl \
                libfile-listing-perl \
                libfile-mimeinfo-perl \
                libfont-afm-perl \
                libgl1-mesa-glx \
                libgl1-mesa-dri \
                libhtml-form-perl \
                libhtml-format-perl \
                libhtml-parser-perl \
                libhtml-tagset-perl \
                libhtml-tree-perl \
                libhttp-cookies-perl \
                libhttp-daemon-perl \
                libhttp-date-perl \
                libhttp-message-perl \
                libhttp-negotiate-perl \
                libio-html-perl \
                libio-socket-ssl-perl \
                libipc-system-simple-perl \
                liblwp-mediatypes-perl \
                liblwp-protocol-https-perl \
                libmailtools-perl \
                libncurses5-dev \
                libnet-dbus-perl \
                libnet-http-perl \
                libnet-smtp-ssl-perl \
                libnet-ssleay-perl \
                libpaper-utils \
                libqt5x11extras5 \
                libreadline-dev \
                libtext-iconv-perl \
                libtie-ixhash-perl \
                libtimedate-perl \
                libtinfo-dev \
                liburi-perl \
                libwww-perl \
                libwww-robotrules-perl \
                libx11-protocol-perl \
                libxml-parser-perl \
                libxml-twig-perl \
                libxml-xpathengine-perl \
                mesa-utils \ 
                netbase \
                perl-openssl-defaults \
                x11-xserver-utils \
                xauth \
                xdg-utils 

RUN wget --quiet https://download1.rstudio.org/desktop/debian9/x86_64/rstudio-1.2.1335-amd64.deb -O /tmp/rstudio.deb && \
    dpkg -i /tmp/rstudio.deb

RUN R -e 'install.packages("Seurat")'

RUN R -e 'install.packages("WGCNA")'

RUN R -e 'install.packages("igraph")'

RUN cd /tmp && \
    wget --quiet https://github.com/KlugerLab/FIt-SNE/archive/v1.1.0.tar.gz -O FIt-SNE.tar.gz && \
    tar xf FIt-SNE.tar.gz && \
    cd FIt-SNE-1.1.0 && \
    g++ -std=c++11 -O3  src/sptree.cpp src/tsne.cpp src/nbodyfft.cpp  -o bin/fast_tsne -pthread -lfftw3 -lm && \
    cp bin/fast_tsne /usr/local/bin/

RUN apt-get -y install python-virtualenv python-pip &&\
    R -e "library('reticulate'); reticulate::py_install(packages = 'umap-learn')"

ENTRYPOINT ["/usr/bin/rstudio"]
