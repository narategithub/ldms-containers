FROM grafana/grafana-oss:8.0.2-ubuntu
SHELL [ "/bin/bash", "-c" ]

COPY --chown=grafana:root dsosds /var/lib/grafana/plugins/dsosds
COPY --chown=grafana:root grafana.ini /etc/grafana/grafana.ini
