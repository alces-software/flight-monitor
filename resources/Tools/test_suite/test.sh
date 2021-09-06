#!/bin/bash
xhpl=$(flight start ;flight env activate spack; spack load hpl; which xhpl)

echo $xhpl
