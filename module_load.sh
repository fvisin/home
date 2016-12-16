#!/bin/bash

echo `pwd`
if [ $0 == "-bash" ]; then
  BASENAME="-bash"
else
  BASENAME="$(basename $0)"
fi

if [ "$BASENAME" == "module_load.sh" ]; then
  echo "*** ERROR *** Usage: source module_load.sh"
  echo "*** ERROR *** Exiting ..."
  exit 1
fi

################## MODULES #####################
module load profile/advanced
# module load mkl/2017--binary intel/pe-xe-2017--binary
module load gnu/4.9.2 cmake/3.3.2--bin386
# module load python/2.7.9 cython/0.22 numpy/1.9.1--python--2.7.9 scipy/0.15.1--python--2.7.9 -> linked against blas/3.5.0--gnu--4.9.2
module load cuda/7.5.18 cudnn/5.1--cuda--7.5.18

# module load cuda
# export what cineca "admins" forgot...
#export LD_LIBRARY_PATH=$CUDA_LIB:$LD_LIBRARY_PATH
#export CPATH=$CUDA_INC:$CPATH
##export PATH=$PATH:/cineca/prod/compilers/cuda/7.0.28/none/bin/

echo "Loading completed"
