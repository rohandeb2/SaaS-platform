output "mesh_id" {
  description = "The ID of the App Mesh"
  value       = aws_appmesh_mesh.this.id
}

output "mesh_name" {
  description = "The name of the App Mesh"
  value       = aws_appmesh_mesh.this.name
}

output "api_virtual_node_arn" {
  description = "The ARN of the API virtual node"
  value       = aws_appmesh_virtual_node.api.arn
}

output "api_virtual_node_name" {
  description = "The name of the API virtual node"
  value       = aws_appmesh_virtual_node.api.name
}

output "virtual_node_arn" {
  # Change "api" to whatever you named the resource in modules/app-mesh/main.tf
  value       = aws_appmesh_virtual_node.api.arn
  description = "The ARN of the App Mesh Virtual Node"
}
