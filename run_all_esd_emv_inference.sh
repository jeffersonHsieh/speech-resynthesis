#!/bin/bash
# use the bash shell
set -x 
eval "$(conda shell.bash hook)"
# echo each command to standard out before running it

# conf=$1 for test.txt
# ckpt=$2
./run_esd_spkr_inference.sh ESD_spkr/hubert_nclus_100_alpha1_down_sample_035_layer_12 checkpoints/spkrESD_resynth_n100a1L12_uonly_samp035/g_00060000
# done

# #13579335
./run_esd_spkr_inference.sh ESD_spkr/hubert_nclus_1024_alpha_1_down_sample_035_layer_2 checkpoints/spkrESD_resynth_n1024a1L2_uonly_samp035/g_00050000
# #13579339
./run_esd_spkr_inference.sh ESD_spkr/hubert_nclus_1024_alpha_1_down_sample_035_layer_6 checkpoints/spkrESD_resynth_n1024a1L6_uonly_samp035/g_00050000
# #13562923
./run_esd_spkr_inference.sh ESD_spkr/hubert_nclus_1024_alpha1_down_sample_035_layer_12 checkpoints/spkrESD_resynth_n1024a1L12_uonly_samp035/g_00050000
# #13579325
./run_esd_spkr_inference.sh ESD_spkr/hubert_nclus_1024_alpha_05_down_sample_035_layer_2 checkpoints/spkrESD_resynth_n1024a05L2_uonly_samp035/g_00050000
# #13579329
./run_esd_spkr_inference.sh ESD_spkr/hubert_nclus_1024_alpha_05_down_sample_035_layer_6 checkpoints/spkrESD_resynth_n1024a05L6_uonly_samp035/g_00050000
# #13562922
./run_esd_spkr_inference.sh ESD_spkr/hubert_nclus_1024_alpha0.5_down_sample_035_layer_12 checkpoints/spkrESD_resynth_n1024a05L12_uonly_samp035/g_00050000
# #13562924
./run_esd_spkr_inference.sh ESD_spkr/hubert_nclus_2048_alpha0.5_down_sample_035_layer_12 checkpoints/spkrESD_resynth_n2048a05L12_uonly_samp035/g_00050000
# #13562920
./run_esd_spkr_inference.sh ESD_spkr/hubert_nclus_100_alpha0.5_down_sample_035_layer_12 checkpoints/spkrESD_resynth_n100a05L12_uonly_samp035/g_00050000
# #13565748
./run_esd_spkr_inference.sh ESD_spkr/hubert_nclus_100_alpha1_down_sample_035_layer_12 checkpoints/spkrESD_resynth_n100a1L12_uonly_samp035/g_00050000
#13577733
./run_esd_emv_inference.sh hubert_nclus_1024_alpha1_down_sample_035_layer_12 checkpoints/emvESD_resynth_n1024a1L12_emovec1_samp035/g_00050000 ev1
#13577732
./run_esd_emv_inference.sh hubert_nclus_1024_alpha1_down_sample_035_layer_12 checkpoints/emvESD_resynth_n1024a1L12_emovec05_samp035/g_00050000 ev05
#13577730
./run_esd_emv_inference.sh hubert_nclus_1024_alpha0.5_down_sample_035_layer_12 checkpoints/emvESD_resynth_n1024a05L12_emovec05_samp035/g_00050000