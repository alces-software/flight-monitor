base:
  '*':
    - fcops/group
    - fcops/user
    - fcops/install

  'node*':
    - apps/compute

  'login*':
    - apps/login
