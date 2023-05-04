resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = format("%s/%s/%s", abspath(path.root), ".ssh", "bitops-ssh-key.pem")
  file_permission = "0600"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl", {
    ip                       = aws_instance.server.public_ip,
    ssh_keyfile              = local_sensitive_file.private_key.filename
    app_repo_name            = var.app_repo_name
    app_install_root         = var.app_install_root
    mount_efs                = local.mount_efs
    efs_url                  = local.efs_url
    resource_identifier      = var.aws_resource_identifier
    application_mount_target = var.application_mount_target
    efs_mount_target         = var.efs_mount_target != null ? var.efs_mount_target : ""
    data_mount_target        = var.data_mount_target
    ecr_url                  = var.ecr_url
    aws_access_key_id        = var.aws_access_key_id
    aws_secret_access_key    = var.aws_secret_access_key
  })
  filename = format("%s/%s", abspath(path.root), "inventory.yaml")
}