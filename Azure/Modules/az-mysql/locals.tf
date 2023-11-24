locals {
	firewall_rules = {for item in flatten([
		for key,value in var.mysql_servers:[
			for rule_name, rule_value in try(value.firewall,{}):[
				merge(
					{
						name = rule_name
						resource_group_name = value.resource_group_name
						server_name = value.name
					},
					rule_value
				)
			]
		]
	]): "${item.server_name}-${item.name}" => item}
}
