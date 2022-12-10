#!/bin/bash
# use the bash shell
set -x 
eval "$(conda shell.bash hook)"
# echo each command to standard out before running it
currdir=$(pwd)
# rundir=$(cat temp)
# echo ${rundir}
rundir=${run_dir}
cd /ocean/projects/tra220029p/chsieh1/espnet/egs2/tat/tts1
. path.sh
ls ${rundir}/gt_wav.scp
ls ${rundir}/gen_wav.scp
python -u pyscripts/utils/evaluate_f0.py ${rundir}/gen_wav.scp ${rundir}/gt_wav.scp
python -u pyscripts/utils/evaluate_mcd.py ${rundir}/gen_wav.scp ${rundir}/gt_wav.scp
cd ${currdir}