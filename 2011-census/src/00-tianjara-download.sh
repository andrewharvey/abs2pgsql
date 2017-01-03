#!/bin/sh

wget http://tianjara.net/data/abs/ABS.2011.Census.DataPacks.BCP_IP_TSP.R3.CSV-Minimal.tar.xz

mkdir -p DataPacks
tar -xvvJ -C DataPacks -f ABS.2011.Census.DataPacks.BCP_IP_TSP.R3.CSV-Minimal.tar.xz
