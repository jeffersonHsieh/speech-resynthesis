#!/usr/bin/env bash

#for evaluation

root_base=$1
outdir_base=$2
runtype=$(basename ${root_base})
for confdir in `ls ${root_base}/* -d`
do 
    conf=$(basename ${confdir})
    for stepdir in `ls ${confdir}/* -d`
    do 
        step=$(basename ${stepdir})
        outdir=${outdir_base}/${runtype}/${conf}/${step}
        gtscp=${outdir}/gt_wav.scp
        genscp=${outdir}/gen_wav.scp
        echo ${outdir}
        [ ! -e ${outdir} ] && mkdir -p ${outdir}
        [ -e ${gtscp} ] && rm ${gtscp}
        [ -e ${genscp} ] && rm ${genscp}

        find ${stepdir} -name "*gen.wav" | grep -v _[0-9]_gen | sort | while read -r filename;do
        id=$(basename ${filename} | sed -e "s/_gen\.wav//")
        fpath=$(realpath ${filename})
        echo ${id} ${fpath} >> ${genscp}
        done

        find ${stepdir} -name "*.wav" | grep -v "_gen" | sort | while read -r filename;do
        fpath=$(realpath ${filename})
        parent=$(dirname ${fpath})
        npath=${parent}/$(basename ${filename} | sed -e "s/_gt//")
        mv ${fpath} ${npath}
        # echo ${npath}
        id=$(basename ${filename} | sed -e "s/_gt\.wav//")
        echo ${id} ${npath} >> ${gtscp}
        done
        gtlen=$(cat ${gtscp} | wc -l)
        genlen=$(cat ${genscp} | wc -l)
        echo "written ${gtlen} to gtscp"
        echo "written ${genlen} to genscp"
    done
done


# find ${gt_root} -follow -name "*.wav" | sort | while read -r filename;do
#     id=$(basename ${filename} | sed -e "s/\.wav//")
#     fpath=$(realpath ${filename})
#     echo "${id} ${fpath}" >> ${gtscp}

#     root=${root_base}/${conf}
#     find ${gen_root} -follow -follow -regextype posix-extended -regex ".*/[MF][12]_[0-9A-Z_]+-[0-9]+_gen.wav" | sort | while read -r filename;do
#         id=$(basename ${filename} | sed -e "s/_gen\.wav//")
#         fpath=$(realpath ${filename})
#         echo "${id} ${fpath}" >> ${genscp}
# done
# genlen=$(cat ${genscp} | wc -l)
# # gtlen=$(cat ${gtscp} | wc -l)
# # echo "gt scp len ${gtlen}"
# echo "gen scp len ${genlen}"