FROM python:3.8.7
ARG version

# Update PIP
RUN pip install --upgrade pip \
    && pip install awscli \
    && pip install s3cmd

RUN apt-get update
RUN apt-get install -y gettext-base

# install pipelinewise
RUN mkdir /app/
RUN git clone https://github.com/transferwise/pipelinewise.git /app/pipelinewise/ --branch v0.35.2
RUN /bin/bash -c "/app/pipelinewise/install.sh --connectors=tap-postgres,target-snowflake,transform-field --acceptlicenses"

COPY ./jobs_config/*.yml.sample /app/
COPY ./target_config/target_snowflake.yml.sample /app/
COPY run.sh /app/
COPY logging.conf /app/

# In case you need you vault uncomment that example for banzai cloud
#ENV VAULT_CLIENT_TIMEOUT="30s"
#COPY --from=banzaicloud/vault-env:1.11.3 /usr/local/bin/vault-env /vault/vault-env

WORKDIR /app
CMD ["/bin/bash", "./run.sh"]