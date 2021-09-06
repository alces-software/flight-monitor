nvtool:
- runs fine on node
- needs a way to construct/read a config file

memtester:
- issues (maybe specifically with wae) due to diskless nonsense:
```
	node001: tar: memtester: Cannot mkdir: Read-only file system
	node001: memtester/run_memtester.sh
	node001: memtester/memtest_tool.sh
	node001: tar: memtester: Cannot mkdir: Read-only file system
	node001: tar: memtester/bequiet.sh: Cannot open: No such file or directory
	node001: tar: memtester: Cannot mkdir: Read-only file system
	node001: tar: memtester/memtester: Cannot open: No such file or directory
	node001: tar: memtester: Cannot mkdir: Read-only file system
	node001: tar: memtester/run_memtester.sh: Cannot open: No such file or directory
	node001: tar: memtester: Cannot mkdir: Read-only file system
	node001: tar: memtester/memtest_tool.sh: Cannot open: No such file or directory
	node001: tar: Exiting with failure status due to previous errors
```

hpltool:
- xhpl issues:
```
	node001: /tmp/1-node-scott/run_1node.sh: line 5: flight: command not found
	node001: /tmp/1-node-scott/run_1node.sh: line 6: spack: command not found
	node001: which: no xhpl in (/sbin:/bin:/usr/sbin:/usr/bin)
	node001: ldd: missing file arguments
	node001: Try `ldd --help' for more information.
	node001: /tmp/1-node-scott/run_1node.sh: line 14: mpirun -np 32 -ppn 32 /home/fcops/.local/share/flight/env/spack+default/opt/spack/linux-centos7-bulldozer/gcc-4.8.5/hpl-2.3-h7zz4smc2u6wfor6h7kcxcfwtrolvivx/bin/xhpl: No such file or directory
```
	
wrapper:
 - Needs to add multiple intensity functions
 - Needs output logging
