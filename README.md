pohody.com.ua
=============

http://pohody.com.ua/ cайт, що допомагає спланувати/знайти туристичний похід.

## Розробка

Технології: rails, backbone.js, bootstrap, mysql


## Деплоймент

```bash
# install required packages
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install mysql-server imagemagick nginx git libmysqlclient-dev nodejs sendmail

# add signatures
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

# install rvm & ruby
\curl -sSL https://get.rvm.io | bash -s stable
source /home/rails/.rvm/scripts/rvm
rvm install ruby-2.1.5
rvm use ruby
gem install bundler

```

```bash
mina setup
mina deploy
```