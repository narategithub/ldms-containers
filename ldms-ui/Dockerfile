FROM ldms-agg

SHELL [ "/bin/bash", "-c" ]

COPY --chown=root:root scripts-ui/start-ui.sh /docker/

ENTRYPOINT [ "/docker/start-ui.sh" ]
