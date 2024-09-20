# Base image
FROM registry.redhat.io/ansible-automation-platform-24/ee-minimal-rhel9:latest

# Set environment variables
ENV PATH="/usr/local/bin:$PATH"

# Download and install MinIO client
RUN curl -L https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc

# Download and install OpenShift client (oc)
RUN curl -L https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz -o /tmp/openshift-client-linux.tar.gz && \
    tar -xvf /tmp/openshift-client-linux.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/oc && \
    chmod +x /usr/local/bin/kubectl && \
    rm /tmp/openshift-client-linux.tar.gz

# Add HashiCorp repo and install Vault and setcap
RUN curl -fsSL https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo -o /etc/yum.repos.d/hashicorp.repo && \
    microdnf install -y vault && \
    microdnf clean all && \
    setcap -r /usr/bin/vault

# Update Python's pip
RUN python3 -m pip install --upgrade pip && \
    pip install awxkit

# Verify installations
RUN mc --version && \
    oc version && \
    vault --version && \
    awx --version && \
    whereis awx

# Set default command
CMD ["/bin/bash"]
