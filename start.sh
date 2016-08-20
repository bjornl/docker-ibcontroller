#!/bin/bash

conf=/etc/ibcontroller/conf.ini

# Force those values
export IB_ForceTwsApiPort=
export IB_IbBindAddress=127.0.0.1
export IB_IbDir=/etc/ibcontroller/

# thanks to kafka-docker for this wonderful snippet
for VAR in `env`; do
    if [[ $VAR =~ ^IB_ ]]; then
        name=`echo "$VAR" | sed -r "s/IB_(.*)=.*/\1/g"`
        env_var=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
        if egrep -q "(^|^#)$name=" $conf; then
            sed -r -i "s@(^|^#)($name)=(.*)@\2=${!env_var}@g" $conf #note that no config values may contain an '@' char
        else
            echo "$name=${!env_var}" >> $conf
        fi
    fi
done

socat TCP-LISTEN:4003,fork TCP:127.0.0.1:4001&

/usr/sbin/xvfb-run \
    --auto-servernum \
    -f \
    /var/run/xvfb/ \
    java \
    -cp \
    /usr/share/java/ib-tws/*:/usr/share/java/ibcontroller/* \
    -Dsun.java2d.noddraw=true \
    -Dswing.boldMetal=false \
    -Dsun.locale.formatasdefault=true -Xmx512M \
    ibcontroller.IBGatewayController \
    $conf
