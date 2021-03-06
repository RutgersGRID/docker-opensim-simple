# FROM mono
FROM ubuntu:16.04

#to fix problem with /etc/localtime
ENV TZ America/New_York

#Add repository and update the container
#Installation of necessary package/software for this containers...
#nant was remove and added mono build dependence
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
   && echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | tee /etc/apt/sources.list.d/mono-official.list
RUN echo $TZ > /etc/timezone && apt-get update && apt-get install -y -q curl screen mono-complete ca-certificates-mono tzdata \
                    && rm /etc/localtime  \
                    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
                    && dpkg-reconfigure -f noninteractive tzdata \
                    && apt-get clean \
                    && rm -rf /tmp/* /var/tmp/*  \
                    && rm -rf /var/lib/apt/lists/*

RUN curl http://dist.opensimulator.org/opensim-0.9.0.0.tar.gz -s | tar xzf -
COPY Regions.ini /opensim-0.9.0.0/bin/Regions/Regions.ini
COPY OpenSim.ini /opensim-0.9.0.0/bin/OpenSim.ini
COPY SQLiteStandalone.ini /opensim-0.9.0.0/bin/config-include/storage/SQLiteStandalone.ini
RUN mkdir /var/opensim
EXPOSE 9000
WORKDIR /opensim-0.9.0.0/bin

CMD [ "mono",  "./OpenSim.exe" ]
