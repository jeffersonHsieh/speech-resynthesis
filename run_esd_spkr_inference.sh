#!/bin/bash
# use the bash shell
set -x 
eval "$(conda shell.bash hook)"
# echo each command to standard out before running it

conda activate /ocean/projects/tra220029p/chsieh1/miniconda3/envs/hi5g

# for i in `ls checkpoints/TAT_resynth_1024_scale/g_*`
# do
conf=$1
ckpt=$2
BN=$(basename $ckpt)
python -u inference.py \
--checkpoint_file $ckpt \
-n 599 \
--vc \
--input_code_file manifests/${conf}/test.txt \
--output_dir generations_multispkr/${conf}/$BN
echo $ckpt
echo $BN
# done

