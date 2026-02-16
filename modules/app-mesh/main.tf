resource "aws_appmesh_mesh" "this" {
  name = "${var.name_prefix}-mesh"

  spec {
    egress_filter {
      type = "ALLOW_ALL"
    }
  }

  tags = var.tags
}

resource "aws_appmesh_virtual_node" "api" {
  name      = "${var.name_prefix}-api-node"
  mesh_name = aws_appmesh_mesh.this.name

  spec {
    listener {
      port_mapping {
        port     = 8080
        protocol = "http"
      }
    }

    service_discovery {
      aws_cloud_map {
        service_name   = "api-service"
        namespace_name = var.cloud_map_namespace
      }
    }
  }
}
