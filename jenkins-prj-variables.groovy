
def get_variables_for_env(current_env){
    def prj_name = 'bee-temporal'
    def eks_cluster = ""
    def replica_count = 1
    def subnets = []
    def nlb_name = ""
    def frontend_dns_domain = ""
    def web_dns_domain = ""


    if ( current_env == "pre" ) {
        eks_cluster = "pre-bee-temporal"
        profile = "pre-inc_super_provisioning"
        subnets = ["subnet-04ab65750c4461660", "subnet-06572f16ee4eddb44"]
        nlb_name = "pre-bee-temporal-frontend"
        frontend_dns_domain = "pre-bee-temporal.getbee.info"
        web_dns_domain = "pre-bee-temporal-web.getbee.info"
        prometheus_dns_domain = "pre-bee-temporal-prometheus.getbee.info"


    } else if ( current_env == "qa" ) {
        eks_cluster = "qa-bee-temporal"
        profile = "mailupinc_super_provisioning"
        subnets = ["subnet-059dd5aaf9852af7a", "subnet-060f9c92a69a41142"]
        nlb_name = "qa-bee-temporal-frontend"
        frontend_dns_domain = "qa-bee-temporal.getbee.io"
        web_dns_domain = "qa-bee-temporal-web.getbee.io"
        pro

    } else if ( current_env == "pro" ) {
        eks_cluster = "bee-temporal"
        profile = "mailupinc_super_provisioning"
        replica_count = 2
        subnets =["subnet-03391f66", "subnet-37266840"]
        nlb_name = "pro-bee-temporal-frontend"
        frontend_dns_domain = "bee-temporal.getbee.io"
        web_dns_domain = "bee-temporal-web.getbee.io"
        prometheus_dns_domain = "bee-temporal-prometheus.getbee.io"
    } else {
        error("Invalid env (${current_env})")
    }

    return [
        current_env: current_env,
        s3_env_secrets: true,
        prj_name: prj_name,
        service_name: "${current_env}-${prj_name}",
        region: 'eu-west-1',
        profile: profile,
        eks_cluster: eks_cluster,
        launch_type: "FARGATE",
        replica_count: replica_count,
        subnets: subnets,
        nlb_name: nlb_name,
        frontend_dns_domain: frontend_dns_domain,
        web_dns_domain: web_dns_domain,
        prometheus_dns_domain: prometheus_dns_domain,
        slack_enabled: true,
        slack_prj_emoji: ':temporalio:'
    ]

}

// DONT MISS THIS LINE. return this is the key for loading script from jenkins-unified-ci.groovy
return this
