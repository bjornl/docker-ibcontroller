Docker image for ib-controller
==============================

It uses the official base/archlinux and installs the ib-controller AUR package.

It exposes the `4003` port.

To customize the image, use environment variables named like the
corresponding options in the configuration .ini file with the `IB_`
prefix. For example, using docker compose yaml format:

```
services:
    ib:
        image: ibizaman/docker-ibcontroller
        environment:
            - IB_IbLoginId=username
            - IB_IbPassword=password
```

Build with

```
docker build -t {tag_name} .
```

Run with

```
docker run -d --env IB_IbLoginId={login_id} --env IB_IbPassword={password} --env IB_TradingMode=paper {tag_name};
```
