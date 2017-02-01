#!/bin/bash

################################################################################
# Author: Francesco Visin
#
# This script will create the file with the scheduler configuration and the code
# and will then call the scheduler to queue the job.
#
# Usage:
# ./run_job.sh        --> will run the default evaluate file
# or
# ./run_job.sh 20     --> will run the 20th evaluate file
################################################################################

################################ DATE AND NAMES ################################
DATE=`date +%F_%Hh%M%S`			# current date and time
HOUR=`date +%Hh%M%S`			# current hour
FILENAME="$(basename ${0%.*})"		# current's file name without extension
THEANO_FLAGS=\'compiledir=$HOME/.theano/$FILENAME-$DATE,floatX=float32,device=gpu0

# filenames
QSUB_SCRIPT="$FILENAME"-$DATE		# name of the script file
QSUB_SCRIPT="q_scripts/$QSUB_SCRIPT"
JOBNAME="${FILENAME:0:8}-$HOUR"		# name of the job in the scheduler
OUTNAME="q_logs/$FILENAME"-$DATE.out
ERRNAME="q_logs/$FILENAME"-$DATE.err

################################## PARAMETERS ##################################

PRECOMMAND="source $HOME/.bashrc; source $HOME/module_load.sh"
WORKDIR="$HOME/exp/workingdir"			# insert here the directory the your script is located
COMMAND="python eval_dataset"			# insert here the name of the script you want to run

# job parameters
# GALILEO max 128 nodes, max 24h, max 120Gb ram (see qstat -q -G)
# OLD --> debug(2, 00.30.00, always), p_devel(2, 1.00.00, 10-18), parallel(32, 4.00.00, always), np_longpar(9, 8.00.00, 18-10 and weekends)
WALLTIME="24:00:00"			        # max execution time (max depends on the selected queue)
NUM_NODES=1				        # number of nodes (max depends on the selected queue)
NUM_CPU_PER_NODE=1			        # number of cpus (max: 16)
NUM_GPU_PER_NODE=1			        # number of gpus (max: 2)
NUM_MPI_TASK_PER_NODE=1				# number of MPI inter-node parallel tasks per node (should be less than MAX_CPU_PER_NODE)
RAM_PER_NODE="14GB"			        # available ram (on Eurora should be either 1-14GB or 17-30 GB)
QUEUE="route"
MERGE_OUT_ERR=1				        # set to 1 to merge std-err and std-out
EMAIL_EVENT="bae"			        # specify email notification (a=aborted,b=begin,e=end,n=no_mail)
EMAIL_ADDR="fvisin@gmail.com"		    	# email address
ACC_NUM="pMI16_EleBrG"   	        	# account number

########################## SET PARAMETERS AND RUN JOB ##########################

# model
if [ $# -lt 1 ]; then
    echo "You need to specify which experiments to run"
    echo "Usage: ./run_job <experiment_number> [<job_id_to_chain_to>]"
    exit
elif [ $# -eq 2 ]; then
    COMMAND=$COMMAND$1".py -r"
    CHAINTO=$2
else
    COMMAND=$COMMAND$1".py -r"
fi


# parameters check
if [ $NUM_CPU_PER_NODE -lt $NUM_MPI_TASK_PER_NODE ]; then
    echo "NUM_MPI_TASK_PER_NODE cannot be higher than NUM_CPU_PER_NODE (hyperthreading is disabled)"
    echo "Please verify your parameters"
    echo "Exiting..."
    exit 1
fi

# set number of intra-node parallel tasks in theano
NUM_OPENMP_TASKS=$(expr $NUM_CPU_PER_NODE - $NUM_MPI_TASK_PER_NODE) 
if [ $NUM_OPENMP_TASKS -gt 1 ]; then
	THEANO_FLAGS="$THEANO_FLAGS,openmp=true'"	# Note: You should set env OMP_NUM_THREADS
else
	THEANO_FLAGS="$THEANO_FLAGS,openmp=false'"
fi

###################
mkdir -p q_logs
mkdir -p q_scripts

echo "#!/bin/bash" > "$QSUB_SCRIPT"

# write the scheduler configuration
echo "#PBS -N $JOBNAME" >> "$QSUB_SCRIPT"
echo "#PBS -l walltime=$WALLTIME" >> "$QSUB_SCRIPT"
#set num_nodes, num_cpus_per_nod, num_gpus_per_node, num_mpi_tasks_per_node and RAM_per_node (supposedly, 47Gb)
echo "#PBS -l select=$NUM_NODES:ncpus=$NUM_CPU_PER_NODE:ngpus=$NUM_GPU_PER_NODE:mpiprocs=$NUM_MPI_TASK_PER_NODE:mem=$RAM_PER_NODE" >> "$QSUB_SCRIPT"
echo "#PBS -o $OUTNAME" >> "$QSUB_SCRIPT"
echo "#PBS -e $ERRNAME" >> "$QSUB_SCRIPT"
if [ $MERGE_OUT_ERR -eq 1 ]; then
    echo "#PBS -j eo" >> "$QSUB_SCRIPT"
fi
echo "#PBS -q $QUEUE" >> "$QSUB_SCRIPT"
echo "#PBS -m $EMAIL_EVENT" >> "$QSUB_SCRIPT"
echo "#PBS -M $EMAIL_ADDR" >> "$QSUB_SCRIPT"
echo "#PBS -A $ACC_NUM" >> "$QSUB_SCRIPT"

# write the rest of the script
echo >> "$QSUB_SCRIPT"
echo "$PRECOMMAND" >> "$QSUB_SCRIPT"
echo "cd $WORKDIR" >> "$QSUB_SCRIPT"
echo "export OMP_NUM_THREADS=$NUM_CPU_PER_NODE" >> "$QSUB_SCRIPT"
echo "export PYTHONUNBUFFERED=1" >> "$QSUB_SCRIPT"
echo "export THEANO_FLAGS=$THEANO_FLAGS" >> "$QSUB_SCRIPT"
echo "$COMMAND 2>&1 > $HOME/q_logs/$FILENAME-$DATE.log" >> "$QSUB_SCRIPT"

# call the scheduler
mkdir -p q_jobs
if [ -z ${CHAINTO+x} ]; then
    echo Submitting single job ...
    JOB_ID="$(qsub "$QSUB_SCRIPT")"
else
    echo Chaining job to $CHAINTO ...
    JOB_ID="$(qsub "-W depend=afterany:"$CHAINTO "$QSUB_SCRIPT")"
fi
echo Done. 
echo Job id: "${JOB_ID}"
echo "${JOB_ID}" >> q_jobs/$FILENAME-$DATE.txt

# delete the script file
#rm "$QSUB_SCRIPT"
