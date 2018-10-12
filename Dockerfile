FROM jenkins/jnlp-slave:latest

USER root

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

ENTRYPOINT ["/usr/bin/supervisord", "--nodaemon"]
