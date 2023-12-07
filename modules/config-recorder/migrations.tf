# INFO: 2023-12-07 - module-defined IAM Role is optional
moved {
  from = module.role__recorder
  to   = module.role__recorder[0]

}
# 2023-02-01
moved {
  from = aws_resourcegroups_group.this[0]
  to   = module.resource_group[0].aws_resourcegroups_group.this
}
