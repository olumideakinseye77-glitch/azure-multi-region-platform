# Azure Highly Available Multi-Region Platform

An Azure Cloud Engineering portfolio lab built to challenge myself with regional resilience. Building on my networking and identity projects, I deployed an application across two regions, routed requests through Azure Front Door and tested its behaviour during an application outage.

## Project Status

**Status:** Core portfolio lab complete, with documented limitations. Regional routing, access logging, CI, read-only Azure OIDC, alert firing and automatic resolution are verified. A final Terraform plan reported no changes on 17 October 2026.

**Live demo:** Offline. The platform was deployed and tested on Azure, then intentionally decommissioned on 18 October 2026 to avoid ongoing demo infrastructure charges. Terraform reported 14 resources destroyed, and Azure confirmed that `rg-olu-multi-region-platform` no longer existed. Application code, Terraform configuration and recorded validation evidence remain in this repository for review and future redeployment.

The architecture below shows the tested deployment, rather than currently running resources. Redeployment requires provisioning the infrastructure and deploying the application code.

## Architecture

```mermaid
flowchart TD
    USER["Users"] --> AFD["Azure Front Door Standard"]
    AFD --> SOUTH["App Service: UK South"]
    AFD --> WEST["App Service: UK West"]
    AFD --> LOG["Log Analytics: access and probe logs configured"]
    AFD --> ALERT["Origin health metric alert"]
```

Both origins have equal priority and weight. Primary/secondary names identify resource roles; Front Door is configured for active-active routing.

Terraform manages the platform using remote state in Azure Storage. GitHub Actions validates the application and Terraform configuration. A separate OIDC workflow has Reader access to the project resource group; it does not deploy infrastructure or access Terraform state.

## Skills practised

- Two application deployments in separate Azure regions
- Azure Front Door Standard global routing
- Active-active traffic distribution
- Health probes and automatic regional failover
- Deliberate regional failure testing
- Azure Monitor and operational evidence
- Terraform remote state in Azure Storage
- GitHub Actions Terraform validation
- Azure OIDC authentication without stored client secrets

## Roadmap

- [x] Create GitHub repository
- [x] Create Terraform project foundation
- [x] Deploy resource group through Terraform
- [x] Deploy UK South App Service
- [x] Deploy UK West App Service
- [x] Deploy a region-aware test application
- [x] Configure Azure Front Door Standard
- [x] Configure health probes and load balancing
- [x] Validate active-active routing
- [x] Perform an initial regional outage and recovery test (one HTTP 403 recorded; uninterrupted availability not established)
- [x] Add monitoring and operational evidence
- [x] Add GitHub Actions CI
- [x] Add Azure OIDC authentication
- [x] Document current architecture, troubleshooting and limitations
- [x] Validate alert firing and automatic resolution

Optional improvements: timed outage testing, investigation of the recorded HTTP 403, and an action group with verified notification delivery.

## Regions

- Primary region: UK South
- Secondary region: UK West

## Engineering Goal

The platform should continue serving user traffic when one application region becomes unavailable. Azure Front Door will evaluate origin health and route requests to healthy application origins.

## Validation so far

- Both regional application health endpoints returned HTTP 200.
- The Front Door health endpoint returned HTTP 200 with a healthy response.
- Ten requests through Front Door reached both regions: three UK South and seven UK West. This small sample demonstrates both origins serving requests, not a guaranteed traffic ratio.
- During a UK South app-stop test, four requests succeeded through UK West and one returned HTTP 403. This is partial failover evidence; it does not demonstrate uninterrupted availability. After restarting UK South, its health endpoint recovered and a further ten Front Door requests all succeeded across both regions (three UK South, seven UK West). A timed repeat outage test remains outstanding.
- New Front Door requests initially returned an HTML 404 configuration page. Requests later succeeded after propagation time and a resubmission of the existing route settings; the exact cause was not isolated.

## Monitoring and alert evidence

- Front Door access and health-probe diagnostic categories are enabled and directed to a 30-day Log Analytics workspace.
- A KQL query returned 23 access-log records; all 23 had HTTP status 200. Health-probe log ingestion has not yet been verified.
- The enabled origin-health alert evaluates each origin/origin-group series every minute and checks whether average health is below 90% over five minutes.
- During the 17 October 2026 UK South outage test, the alert fired at 16:47:27 UTC. After the app restarted and origin health recovered, the alert condition changed to Resolved. The API response did not provide a resolution timestamp. See [alert validation evidence](docs/alert-validation.md).
- A final Terraform plan reported no changes, and both workflows passed for evidence commit `944d4a0`.
- Notification delivery has not been configured or tested; no action group is connected.
- Logging began after the first outage test, so those logs cannot establish the cause of the earlier HTTP 403.

## GitHub Actions evidence

- [Successful app and Terraform validation run](https://github.com/olumideakinseye77-glitch/azure-multi-region-platform/actions/runs/39049879860): Flask health-response assertions, Terraform formatting, backend-free initialization and validation.
- [Successful Azure OIDC verification run](https://github.com/olumideakinseye77-glitch/azure-multi-region-platform/actions/runs/39049879898): Azure login without a client secret, followed by a resource-group read.
- The dedicated service principal has Reader access scoped to this project's resource group. Its federated credential trusts this repository's main branch.
- These workflows demonstrate CI and authentication verification, not automated deployment.
- The OIDC run linked above is historical deployment evidence. Its resource-group read will fail while the demo resource group is absent; backend-free app and Terraform validation can still run.

## Troubleshooting lessons

- A UK South B1 quota of zero blocked deployment; the approved increase to one allowed the plan to be created.
- Cloud Shell token timeouts required renewed tenant-specific authentication. Remote state and pushed Git commits allowed recovery after temporary session files were cleared.
- UK South resources created through Azure CLI were imported into Terraform. Configuration was aligned with the deployed application, including region settings and Gunicorn startup.
- Basic FTP/Web Deploy authentication was explicitly disabled instead of accepting provider defaults.
- Log queries initially returned no records; later queries confirmed ingestion. A successful query connection alone did not prove logs had arrived.
- An initial Front Door 404 cleared later, despite API deployment fields still reporting NotStarted. The exact reason was not isolated; working HTTP responses were verified separately.

## Cost and operational limits

The live lab resources, including the earlier Traffic Manager experiment in the project resource group, were removed on 18 October 2026. The separate Terraform state storage was not part of this destruction and may still incur storage charges; its cleanup review is separate. Previously incurred charges remain payable.

While deployed, two B1 plans, Front Door Standard, log ingestion and metric alerts can incur charges. Stopping a web app alone does not stop its App Service plan charges. The workspace's 0.1 GB daily cap is an ingestion control, not a guaranteed spending limit.

## What I want to learn next

I want to strengthen this lab with timed outage evidence and an end-to-end alert notification test. The next challenge is turning collected logs into useful operational decisions. My next planned project is an AI-Assisted Azure Operations & Incident Lab, where I intend to challenge myself with log analysis, incident investigation and carefully reviewed automation.

## Scope and limitations

This is a portfolio lab, not a production service. It currently demonstrates application routing across regions, without a database, replicated data or a validated production recovery objective. The earlier Traffic Manager priority-routing experiment is separate from the Front Door active-active design. UK South was created through Azure CLI and imported into Terraform; both regional applications are now tracked in remote Terraform state.
