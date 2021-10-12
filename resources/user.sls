fcops user:
  user.present:
    - name: fcops
    - shell: /bin/bash
    - home: /home/fcops
    - uid: 64646
    - gid: 64646
    - groups:
      - fcops

/home/fcops/.ssh:
  file.directory:
    - user: fcops
    - group: fcops

key:
  file.managed:
    - name: /home/fcops/.ssh/authorized_keys
    - source: salt://fcops/authorized_keys
    - makedirs: True
    - user: fcops
    - group: fcops


fcops sudo:
  file.managed:
    - name: /etc/sudoers.d/fcops
    - source: salt://fcops/fcops
    - makedirs: True
