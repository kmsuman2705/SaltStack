# Step 1: Install required dependencies
docker_dependencies:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - software-properties-common

# Step 2: Add Docker's official GPG key
docker_gpg_key:
  file.managed:
    - name: /etc/apt/trusted.gpg.d/docker.asc
    - source: https://download.docker.com/linux/ubuntu/gpg
    - mode: 0644
    - skip_verify: True  # Skips GPG verification to bypass errors

# Step 3: Add Docker repository (using Ubuntu focal instead of noble)
docker_repo:
  pkgrepo.managed:
    - name: "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/docker.asc] https://download.docker.com/linux/ubuntu focal stable"
    - file: /etc/apt/sources.list.d/docker.list
    - refresh: True

# Step 4: Install Docker
docker_package:
  pkg.installed:
    - name: docker-ce
    - refresh: True

# Step 5: Ensure Docker service is running
docker_service:
  service.running:
    - name: docker
    - enable: True
    - watch:
      - pkg: docker-ce

# Step 6: Add current user to the docker group (optional)
docker_group:
  cmd.run:
    - name: usermod -aG docker root
    - unless: id -nG root | grep -qw docker
    - require:
      - pkg: docker-ce
