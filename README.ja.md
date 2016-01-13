#docker-bind
ActiveDirectoryの構築

##概要
SambaによるActiveDirectoryを構築します。

##Maintainer
minanon

##外部からアクセスするための情報
- 使用するポート番号は、53(UDPとTCP）です
- データの保存箇所は/etc/samba, /var/lib/samba となっています

##起動方法
### プロビジョニング
設定を行います。

     docker run --rm -it -v /opt/docker/data/samba/etc:/etc/samba -v /opt/docker/data/samba/data:/var/lib/samba -v /opt/docker/data/samba/data/private:/var/lib/samba/private --rm -it -h ad.local.ym adtest provision --use-rfc2307 --function-level=2008_R2 --domain=LOCAL --realm=LOCAL.YM --adminpass=test-1234 --dns-backend=BIND9_DLZ --server-role=dc

### ユーザー追加

     docker run -v /opt/docker/data/samba/etc:/etc/samba -v /opt/docker/data/samba/data:/var/lib/samba -v /opt/docker/data/samba/data/private:/var/lib/samba/private --rm -it -h ad.local.ym adtest useradd ymaeda

### smbd 起動

     docker run -v /opt/docker/data/samba/etc:/etc/samba -v /opt/docker/data/samba/data:/var/lib/samba -v /opt/docker/data/samba/data/private:/var/lib/samba/private -d -h ad.local.ym adtest samba
