#!/bin/bash

# Create plugins folder if does not exist
if [ ! -d ./resources ]
then
    mkdir ./resources
fi

if [ ! -d ./resources/plugins ]
then
    mkdir ./resources/plugins
fi

GS_VERSION=2.18
GS_VERSION_MINOR=1

# Add in selected plugins.  Comment out or modify as required
plugins=(control-flow inspire monitor css ysld web-resource sldservice charts feature-pregeneralized gdal grib printing mbstyle importer pyramid querylayer vectortiles )
community_plugins=(imagemosaic-jdbc backup-restore geostyler gwc-s3 gwc-distributed s3-geotiff )

for p in "${plugins[@]}"
do 
	if [ ! -f resources/plugins/geoserver-${p}-plugin.zip ]
	then
		wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}.${GS_VERSION_MINOR}/extensions/geoserver-${GS_VERSION}.${GS_VERSION_MINOR}-${p}-plugin.zip -O resources/plugins/geoserver-${p}-plugin.zip
	fi
done

for p in "${community_plugins[@]}"
do 
	if [ ! -f resources/plugins/geoserver-${p}-plugin.zip ]
	then
		wget -c https://build.geoserver.org/geoserver/${GS_VERSION}.x/community-latest/geoserver-${GS_VERSION}-SNAPSHOT-${p}-plugin.zip -O resources/plugins/geoserver-${p}-plugin.zip
	fi
done

## build options include:
#    TOMCAT_EXTRAS  [true | false]
#    GDAL_NATIVE    [true | false]  - default false; build with GDAL support
#    GS_VERSION              - specifies which version of geoserver is to be built

docker build --build-arg GS_VERSION=${GS_VERSION}.${GS_VERSION_MINOR} --build-arg TOMCAT_EXTRAS=true --build-arg GDAL_NATIVE=true -t thinkwhere/geoserver:${GS_VERSION}.${GS_VERSION_MINOR} .
