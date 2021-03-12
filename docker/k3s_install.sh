# curl -sfL https://get.k3s.io | sh -
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -
  # Check for Ready node, takes maybe 30 seconds
k3s kubectl get node

# docs: https://docs.rancher.cn/docs/k3s/quick-start/_index/
