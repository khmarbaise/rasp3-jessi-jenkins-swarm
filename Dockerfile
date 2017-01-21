FROM khmarbaise/rasp3-jessi-first-with-java-8:1.0.0

MAINTAINER Karl Heinz Marbaise <khmarbaise@apache.org>

ENV JENKINS_SWARM_VERSION 2.2
ENV HOME /home/pi

# install netstat to allow connection health check with
# # netstat -tan | grep ESTABLISHED
RUN apt-get update && apt-get install -y net-tools curl python-blinkt && rm -rf /var/lib/apt/lists/*

RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar \
  https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar \
  && chmod 755 /usr/share/jenkins

COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh

RUN useradd -c "Jenkins Slave user" -d $HOME -m pi
RUN mkdir $HOME/workspaces
RUN chown -R pi:pi $HOME/workspaces

RUN chmod +x /usr/local/bin/jenkins-slave.sh

USER pi
VOLUME /home/pi/workspaces

ENTRYPOINT ["/usr/local/bin/jenkins-slave.sh"]
