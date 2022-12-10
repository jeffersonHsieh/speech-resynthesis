#!/bin/bash
# use the bash shell
# set -x 
# eval "$(conda shell.bash hook)"
# echo each command to standard out before running it
# currdir=$(pwd)
# cd /ocean/projects/tra220029p/chsieh1/espnet/egs2/tat/tts1
# . path.sh

scpbase=/ocean/projects/tra220029p/chsieh1/speech-resynthesis/wavscps
step=50000
for rundir in `find ${scpbase} -type d -name "*0${step}" | grep -v "emvESD/.*alpha0\.5"`
do
    echo "${rundir}"
    # ./eval_mcd_f0_esd.sh
    sbatch --export=ALL,run_dir=${rundir} -p RM-shared --ntasks-per-node=4 -t 00:50:00 eval_mcd_f0_esd.sh 
    # python -u pyscripts/utils/evaluate_f0.py ${rundir}/gen_wav.scp ${rundir}/gt_wav.scp
    # python -u pyscripts/utils/evaluate_mcd.py ${rundir}/gen_wav.scp ${rundir}/gt_wav.scp
done
# cd ${currdir}