#!/bin/bash

nohup nice R CMD BATCH --vanilla ../R/read_xml.r &
nohup nice R CMD BATCH --vanilla ../R/make_network.r &
nohup nice R CMD BATCH --vanilla ../R/network_analysis.r &
