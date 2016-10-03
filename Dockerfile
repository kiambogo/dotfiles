from ubuntu:16.04

run apt-get update -y
run apt-get install -y git
run apt-get install -y python
run apt-get install -y curl
run apt-get install -y wget
run apt-get install -y vim
run apt-get install -y ghc cabal-install
run apt-get install -y nodejs npm
run apt-get install -y python-pip
run apt-get install -y tmux
run apt-get install -y build-essential
run apt-get install -y netcat
run apt-get install -y tcpdump

# Some config stuff
run pip install --user powerline-status
run ln -s /usr/bin/nodejs /usr/bin/node

# Install sbt
run wget http://apt.typesafe.com/repo-deb-build-0002.deb && dpkg -i repo-deb-build-0002.deb
run apt-get update
run apt-get install -y sbt

# Install elm
run npm install -g elm

# Install haskell
run wget http://apt.typesafe.com/repo-deb-build-0002.deb && dpkg -i repo-deb-build-0002.deb
run apt-get update
run apt-get install -y sbt

# Setup home environment
run useradd dev
run mkdir /home/dev && chown -R dev: /home/dev
run mkdir -p /home/dev/bin /home/dev/lib /home/dev/include
env PATH /home/dev/bin:$PATH
env LD_LIBRARY_PATH /home/dev/lib

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
run mkdir /var/shared/
run touch /var/shared/placeholder
run chown -R dev:dev /var/shared
volume /var/shared

workdir /home/dev
env HOME /home/dev
add .vimrc /home/dev/.vimrc
add .vim /home/dev/.vim
add .tmux.conf /home/dev/.tmux.conf
add .bash_profile /home/dev/.bash_profile
add .gitconfig /home/dev/.gitconfig

# Link in shared parts of the home directory
run ln -s /var/shared/.ssh
run ln -s /var/shared/.bash_history

run chown -R dev: /home/dev
user dev
