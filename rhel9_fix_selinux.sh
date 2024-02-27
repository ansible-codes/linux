sudo dnf list installed | grep selinux
sudo dnf install selinux-policy selinux-policy-targeted
sudo dnf install setroubleshoot-server setools setools-console policycoreutils
sudo nano /etc/selinux/config
SELINUX=enforcing
sudo reboot
sestatus
