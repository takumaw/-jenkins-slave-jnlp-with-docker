FROM jenkins/jnlp-slave:latest

USER root

RUN set -ex \
	&& apt-get update && apt-get install -y --no-install-recommends \
		build-essential \
		supervisor \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /var/log/supervisor \
	&& curl -fsSL https://get.docker.com/ | sh \
	&& compose_version=$(git ls-remote --tags https://github.com/docker/compose.git | \
		grep -o -E "refs/tags/[0-9]+.[0-9]+.[0-9]+" | cut -d / -f 3 | sort | tail -n 1) \
	&& curl -L https://github.com/docker/compose/releases/download/$compose_version/docker-compose-`uname -s`-`uname -m` \
		-o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose \
	&& usermod -a -G docker jenkins

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "--nodaemon"]
