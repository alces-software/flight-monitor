fcops:
  user.present:
    - fullname: fcops
    - shell: /bin/bash
    - home: /home/fcops
    - uid: 64646
    - gid: 64646
    - groups:
      - fcops
key:
  file.managed:
    - name: /home/fcops/.ssh/authorized_keys
    - source: salt://fcops/authorized_keys
    - makedirs: True
