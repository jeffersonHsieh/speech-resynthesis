#!/bin/bash
# use the bash shell
set -x 
eval "$(conda shell.bash hook)"
# echo each command to standard out before running it

conda activate hi5g

for i in `ls checkpoints/TAT_resynth_1024_scale/g_*`
do
	BN=$(basename $i)
	python -u inference.py \
	--checkpoint_file $i \
	-n 231 \
	--vc \
	--input_code_file manifests/TAT/hubert_code1024_samp1k_scale/test.txt \
	--output_dir generations_multispkr/tat_sample1k_1024_scale/$BN
	echo $i
	echo $BN
done

