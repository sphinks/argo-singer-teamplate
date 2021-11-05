#!/bin/bash
echo `date`

BATCH_ID=$1

echo ${BATCH_ID}

cat ${BATCH_ID}_postgres.yml.sample | sed "s|\$DATASOURCE_USERNAME|$DATASOURCE_USERNAME|" | \
 sed "s|\$DATASOURCE_PASSWORD|$DATASOURCE_PASSWORD|" | \
 sed "s|\$DATABASE_NAME|$DATABASE_NAME|" | \
 sed "s|\$DATASOURCE_HOST|$DATASOURCE_HOST|" > ./tap_postgres.yml

cat target_snowflake.yml.sample | sed "s|\$AWS_ACCESS_KEY_ID|$AWS_ACCESS_KEY_ID|" | \
 sed "s|\$AWS_SECRET_ACCESS_KEY|$AWS_SECRET_ACCESS_KEY|" | \
 sed "s|\$SNOWFLAKE_USERNAME|$SNOWFLAKE_USERNAME|" | \
 sed "s|\$SNOWFLAKE_PASSWORD|$SNOWFLAKE_PASSWORD|" | \
 sed "s|\$SNOWFLAKE_HOST|$SNOWFLAKE_HOST|" | \
 sed "s|\$SNOWFLAKE_DATABASE|$SNOWFLAKE_DATABASE|" > ./target_snowflake.yml

cat tap_postgres.yml
cat target_snowflake.yml

. /.virtualenvs/pipelinewise/bin/activate
export PIPELINEWISE_HOME=/
echo $PIPELINEWISE_HOME

pipelinewise status

pipelinewise import --dir /app/


# You can uncomment next lines in case you want to use incremental mode and save state of your job to S3
s3cmd --access_key=$AWS_ACCESS_KEY_ID --secret_key=$AWS_SECRET_ACCESS_KEY -r get s3://path_to_s3/${BATCH_ID}_postgres/state.json ~/.pipelinewise/snowflake/${BATCH_ID}_postgres/state.json
pipelinewise run_tap --tap ${BATCH_ID}_postgres --target snowflake --debug
exit_status=$?
s3cmd --access_key=$AWS_ACCESS_KEY_ID --secret_key=$AWS_SECRET_ACCESS_KEY -r put ~/.pipelinewise/snowflake/${BATCH_ID}_postgres/state.json s3://path_to_s3/${BATCH_ID}_postgres/state.json

echo `date`

exit "$exit_status"

