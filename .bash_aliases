
alias lsg='ls | grep '
alias untar='tar -xf'
alias pls='sudo'
alias genlic='mvn -Dplugin=com.google.code.maven-license-plugin:maven-license-plugin:2.0.0 license:aggregate-add-third-party'
alias testmail='date | mailx -s "test-email-subject" user@server.com'
alias python='python3'
alias clr='kcolorchooser'
alias rmdir='rm -r '
alias cdtmp='cd /tmp'
alias cdtmp='cd /tmp; ls'
alias cdde='cd ~/Desktop; ls'
alias cdapps='cd ~/apps; ls'
alias cdproj='cd ~/projects; ls'
alias cmd='/mnt/c/Windows/System32/cmd.exe /c start'
alias mvndep='mvn org.apache.maven.plugins:maven-dependency-plugin:2.8:tree > dependency-tree'
alias vsc='export DONT_PROMPT_WSL_INSTALL=1; code'
alias vp='vim pom.xml'
alias svim='sudo vim'
alias smc='sudo mc'
alias jj='java -jar'
alias cp='cp -r'
alias addalias='vim ~/.bash_aliases'
alias resource='. ~/.bash_aliases'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias x='exit'
alias q='exit'
alias dps='clear; docker ps -a'
alias dcu='docker-compose -f ./docker-compose.yml up'
alias dclean='docker image prune -a'
alias dls='docker container list'
alias dimages='docker image list'
alias dcontainers='docker container list'
alias cpwd='xc `pwd`'
alias backup='zip -r backup.zip ./*'
alias inst='sudo apt-get -y install'
alias bb='cd ..;ls'
alias mff='find . -name'
alias jv='java -version'
alias gtheirs='git checkout --theirs .'
alias gours='git checkout --ours .'
alias gbr='git branch'
alias gfe='git fetch --prune'
alias gbrr='git branch -r'
alias gbd='git branch -D'
alias gbn='git checkout -b'
alias gdo='git pull'
alias gst='git status'
alias gsm='git switch master; git branch'
alias gco='git commit -a -m'
alias gup='git push'
alias glo='git log -n 5'
alias sup='svn update'
alias sst='svn status'
alias sco='svn commit -m'
alias slo='svn log -l 5'
alias sst='svn status'
alias svnrelease1='mvn release:clean -Dusername=$SVN_USERNAME -Dpassword=$SVN_PASSWORD'
alias svnrelease2='mvn release:prepare -Dusername=$SVN_USERNAME -Dpassword=$SVN_PASSWORD'
alias svnrelease3='mvn release:perform -Dusername=$SVN_USERNAME -Dpassword=$SVN_PASSWORD'
alias gre='git reset --hard HEAD'
alias sql='psql -h localhost -U postgres'
alias listservices='systemctl list-units --type=service'
alias lg='ls -la | grep'
alias mvninstall='mvn clean; mvn install'

DOWNLOADS_DIR="/mnt/c/Users/j.horcicka/Downloads"
GITLAB_TOKEN=
SVN_USERNAME=
SVN_PASSWORD=

function gun {
  branch=`git branch | head -n 1 | sed s/*//`
  git push --set-upstream origin $branch
}

function gsw {
  if [ $# -lt 1 ]; then 
    echo "Usage: $0 <branch-substring>"
    exit 1
  fi

  branch=`git branch | grep "$1" | head -n 1`
  echo "git switch $branch"
  git switch $branch
  git branch
}

function gch { 
  if [ $# -lt 1 ]; then 
    echo "Usage: $0 <branch-substring>"
    exit 1
  fi
 
  git fetch --prune
  branch=`git branch -r | grep "$1" | head -n 1 | sed 's/\ *origin\///'`
  echo "git checkout -b $branch origin/$branch"
  git checkout -b $branch origin/$branch
  git branch
}

function bak {
  if [ $# -lt 1 ]; then 
    echo "Usage: $0 <file-path>" 
    exit 1 
  fi
  file="$1"
  cp $file $file.bak
}
 
function unbak {
  if [ $# -lt 1 ]; then 
    echo "Usage: $0 <file-path>" 
    exit 1 
  fi
  file="$1"
  cp $file "${file%.bak}"
}
 
function setJava {
  version="8" #8, 11, 17
  if [ $# -gt 0 ]; then 
    version="$1"
  fi
  export JAVA_HOME="/usr/lib/jvm/java-$version-openjdk-amd64"
  echo $JAVA_HOME
  mvn -v
  sudo ln -sf /etc/alternatives/java$version /etc/alternatives/java
  sudo ln -sf /etc/alternatives/javac$version /etc/alternatives/javac
  java -version
}

function mvnbuildskiptests {
  version=8
  if [ $# -gt 0 ]; then 
    version="$1"
  fi
  setJava $version

  mvn clean
  mvn -U verify -DskipTests # skip tests execution
  # mvn verify -Dmaven.test.skip=true # skip tests compilation
  echo "mvn clean; mvn verify -DskipTests"
  git branch
}

function mvnbuild {
  version=8
  if [ $# -gt 0 ]; then 
    version="$1"
  fi
  setJava $version

  mvn clean
  mvn -U verify
  fullJavaVersion=`java -version 2>&1 | head -n 1`
  echo "'mvn clean; mvn verify', java version: $fullJavaVersion"
  git branch
}

function mvnbuildcontinue {
  version=8
  if [ $# -gt 1 ]; then 
    version="$2"
  fi
  setJava $version

  module="$1"
  mvn verify -rf :$module
  git branch
}

function go {
  target="$1"
  cd $target
  ls
}

function killport {
  if [ $# -lt 1 ]; then
    echo "usage: killport <port>"
    exit 1
  fi

  port=$1
  processId=`netstat -tlpn | grep $1 | sed 's/\ \ */\ /g' | cut -d" " -f 7 | sed 's/\([0-9]*\).*/\1/'`

  if [ "$processId" != "" ]; then
    echo "Port: $port"
    echo "Killing process: $processId"
    sudo kill -9 $processId
  else
    echo "No process found for port: $port. "
  fi
}

function dbuild {
  name=$1
  docker build -t $name .
}

function drun {
  name=$1
  docker run -it $name
}

function dssh { 
  id="$1"
  containerId=`docker ps -a | grep $id | cut -d' ' -f 1 | head -n 1`
  echo "$id -> $containerId"
  docker exec -it $containerId bash
}

function drm {
  containerId="$1"
  echo "Stopping container: $containerId"
  docker stop $containerId
  echo "Removing container: $containerId"
  docker rm $containerId
}

function drmimg {
  imageId="$1"
  docker image rm $imageId
}

function dprune {
  for imageId in `docker image list | grep none | sed 's/\ \ */\ /g' | cut -d' ' -f 3`; do 
    docker image remove $imageId
  done
}

function drmall {
  for containerId in `dps | grep -v IMAGE | cut -d' ' -f 1`; do 
    drm $containerId
  done
}

function mft {
  find . -type f -not -path "*/.*/*" -not -name ".*" -exec grep "$1" {} +
}

function junit { 
  if [ $# -lt 1 ]; then 
    echo "Usage: $0 <TEST_CLASS>"
    exit 1
  fi
  testClass="$1"
  mvn -Dtest=$testClass surefire:test 
}

function listports {
  echo "listports: $#"
  if [ $# -gt 0 ]; then 
    netstat -tlpn | grep $1
  else 
    netstat -tlpn
  fi
}

function pingloc {
  port=$1
  paping -p $port localhost
}

function mtd {
  today=`date +%Y-%m-%d`
  mkdir $today
}
