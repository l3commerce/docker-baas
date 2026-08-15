# SSH Directory

This directory contains the private SSH keys required to authenticate and connect to the target servers.
---

## Security Notice

Private keys are sensitive credentials and must never be committed to version control.

* The ssh/ directory is ignored by Git, except for this README.md file.

* Ensure all private key files placed here maintain strict local permissions (chmod 600).