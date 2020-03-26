# Workstation build

This terraform setup creates a workstation on DigitalOcean with my personal
setup and ready to use mosh setup.

## Install


1. Create workstation instance (requires AWS credentials alredy set)

```
$ terraform plan
$ terraform apply -auto-approve
```
2. SSH via mosh:

```
$ mosh --no-init --ssh="ssh -o StrictHostKeyChecking=no -i ~/.ssh/github_rsa -p 22" root@<Instance_IP> -- tmux new-session -ADs main
$ cd /mnt/dev/secrets && ./pull-secrets.sh
```

## Todo

* Encrypt /mnt/secrets
* Resync back some dynamic files (such as `.zsh_history`) back to 1password occasionally
