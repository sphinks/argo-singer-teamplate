# argo-singer-teamplate

A basic example of using Argo Workflows and Singer jobs to create ETL based on Singer taps and target and orchestrated by Argo.

Folder `singer` - configs for taps and target, Docker file to build an image of Singer job with all possible configs. `run.sh` - main entry point performing replacing placeholders with config values for a proper config, next starting it.

Folder `argo` - config for Argo jobs (one per every singer job) and result workflows that will be running both singer jobs daily one by one (Source_2 job depends on the successful finish of Source_1 job).

`install_argo_job_kube.sh` - this is the way you can replace all your argo jobs in case you host Argo using Kubernetes.
