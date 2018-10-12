FROM jenkins/jnlp-slave:latest

USER root
WORKDIR /

RUN set -ex \
	&& apt-get update && apt-get install -y --no-install-recommends \
		build-essential \
		python-pip \
		python-setuptools \
		supervisor \
	&& curl -fsSL https://get.docker.com/ | sh \
	&& pip install docker-compose \
	&& usermod -a -G docker jenkins \
	&& rm -rf /var/lib/apt/lists/*

COPY supervisor/conf.d/docker.conf /etc/supervisor/conf.d/docker.conf
COPY supervisor/conf.d/jenkins-slave.conf /etc/supervisor/conf.d/jenkins-slave.conf

ENV JENKINS_TUNNEL=""
ENV JENKINS_URL=""
ENV JENKINS_SECRET=""
ENV JENKINS_AGENT_NAME=""
ENV JENKINS_AGENT_WORKDIR="/home/jenkins/agent"
ENV JNLP_PROTOCOL_OPTS=""

ENTRYPOINT ["/usr/bin/supervisord", "--nodaemon"]
