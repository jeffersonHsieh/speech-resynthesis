"""
creates a manifest file where wav_root is 1st line, 
2nd line onwards contains a tab separated line of file path relative to wav_root\tduration

# Or directly from an audio file
# librosa.get_duration(filename=librosa.ex('trumpet'))
# 5.333378684807256

"""
import librosa
import os
from pathlib import Path
import argparse
import pickle
from multiprocessing import Pool
from tqdm import tqdm
import random

def find_all_files(path_dir, extension):
    # import pdb;pdb.set_trace()
    out = []
    for root, dirs, filenames in os.walk(path_dir):
        for f in filenames:
            if f.endswith(extension):
                out.append(((str(Path(f).stem)), os.path.join(root, f)))
    return out

def get_duration(filepath):
    return librosa.get_duration(filename=filepath)



def split(args, samples):
    # split
    N = len(samples)
    random.shuffle(samples)
    tt = samples[: int(N * args.tt)]
    cv = samples[int(N * args.tt): int(N * args.tt + N * args.cv)]
    tr = samples[int(N * args.tt + N * args.cv):]

    return tr, cv, tt


def save(outdir, tr, cv, tt):
    # save
    outdir.mkdir(exist_ok=True, parents=True)
    with open(outdir / f'train.txt', 'w') as f:
        f.write('\n'.join([str(x) for x in tr]))
    with open(outdir / f'val.txt', 'w') as f:
        f.write('\n'.join([str(x) for x in cv]))
    with open(outdir / f'test.txt', 'w') as f:
        f.write('\n'.join([str(x) for x in tt]))


if __name__=="__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--srcdir',type=Path, required=True)
    parser.add_argument('--tag',type=str,choices = ['TAT', 'AISHELL'],required=True)
    parser.add_argument('--token_store_file', type=Path, required=True)
    parser.add_argument('--nworkers',type=int, default=4)
    parser.add_argument('--outdir',type=Path, required=True)
    parser.add_argument('--min_dur', type=float, default=None)
    parser.add_argument('--seed', type=int, default=42)
    parser.add_argument('--tt', type=float, default=0.05)
    parser.add_argument('--cv', type=float, default=0.05)
    args = parser.parse_args()
    
    random.seed(args.seed)
    args.outdir.mkdir(parents=True,exist_ok=True)
    configs = '_'.join(args.token_store_file.stem.split('_')[4:])


    with args.token_store_file.open('rb') as f:
        dics = pickle.load(f)

    uttid2code = {dic['utt_id']:dic['hubert_code'].tolist() for dic in dics if dic['tag'] == args.tag}


    audio_files = find_all_files(args.srcdir,'wav')
    audio_files = [os.path.relpath(file[-1], start=args.srcdir) for file in audio_files 
        if os.path.splitext(os.path.basename(file[-1]))[0] in uttid2code]
    abs_paths = [os.path.join(args.srcdir,file) for file in audio_files]
    with Pool(args.nworkers) as p:
        durations = list(tqdm(p.imap(get_duration, abs_paths), total=len(audio_files)))
    
    fname_durs = sorted(list(zip(audio_files,durations)),key=lambda x:x[0])

    # with (args.outdir/f"{args.tag}_manifest_pre_hubert_{configs}.txt").open('w') as f:
    #     f.write(str(args.srcdir)+'\n')
    samples = []
    for fname,dur in tqdm(fname_durs):

        sample = {}
        uttid = os.path.splitext(os.path.basename(fname))[0]
        code = uttid2code[uttid]

        sample['audio'] = str(args.srcdir/ f'{fname}')
        sample['hubert'] = ' '.join(list(map(str,code)))
        sample['duration'] = int(dur) #/ 16000

        if args.min_dur and sample['duration'] < args.min_dur:
            continue

        samples += [sample]

    tr, cv, tt = split(args, samples)
    save(args.outdir/args.tag/f'hubert_{configs}', tr, cv, tt)



