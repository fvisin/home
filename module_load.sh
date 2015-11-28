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
module load gnu/4.9.2
module load blas/3.5.0--gnu--4.9.2 boost/1.57.0--gnu--4.9.2 lapack/3.5.0--gnu--4.9.2 
# module load mkl/11.2--binary cuda/7.0.28 gnu/4.9.2 python/2.7.9 cmake/3.1.0 ipython/2.4.1
module load mkl/11.2--binary cuda/7.0.28 gnu/4.9.2 cmake/3.1.0 
# export what cineca "admins" forgot...
#export LD_LIBRARY_PATH=$CUDA_LIB:$LD_LIBRARY_PATH
#export CPATH=$CUDA_INC:$CPATH
##export PATH=$PATH:/cineca/prod/compilers/cuda/7.0.28/none/bin/

echo "Loading completed"
