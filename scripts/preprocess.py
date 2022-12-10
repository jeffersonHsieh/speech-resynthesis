# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

import argparse
from functools import partial
from multiprocessing import Pool
from pathlib import Path

import numpy as np
import resampy
import soundfile as sf
import librosa
from tqdm import tqdm

import os

def find_all_files(path_dir, extension):
    # import pdb;pdb.set_trace()
    out = []
    for root, dirs, filenames in os.walk(path_dir,followlinks=True):
        for f in filenames:
            if f.endswith(extension):
                out.append(((str(Path(f).stem)), os.path.join(root, f)))
    return out


def pad_data(p, in_dir, out_dir, trim=False, pad=False):
    infile = os.path.join(in_dir,p)
    outpath = os.path.join(out_dir,os.path.splitext(p)[0]+".wav")
    data, sr = sf.read(infile)
    if sr != 16000:
        data = resampy.resample(data, sr, 16000)
        sr = 16000

    if trim:
        data, _ = librosa.effects.trim(data, 20)

    if pad:
        if data.shape[0] % 1280 != 0:
            data = np.pad(data, (0, 1280 - data.shape[0] % 1280), mode='constant',
                          constant_values=0)
        assert data.shape[0] % 1280 == 0

    # outpath = out_dir / p.name
    outpath = Path(outpath)
    outpath.parent.mkdir(exist_ok=True, parents=True)
    sf.write(outpath, data, sr)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--srcdir', type=Path, required=True)
    parser.add_argument('--outdir', type=Path, required=True)
    parser.add_argument('--trim', action='store_true')
    parser.add_argument('--pad', action='store_true')
    parser.add_argument('--postfix', type=str, default='wav')
    args = parser.parse_args()

    # files = list(Path(args.srcdir).glob(f'**/*{args.postfix}'))
    out_dir = Path(args.outdir)

    audio_files = find_all_files(args.srcdir,args.postfix)
    # import pdb;pdb.set_trace()

    audio_files = [os.path.relpath(file[-1], start=args.srcdir) for file in audio_files]

    # Create all the directories needed
    rel_dirs_set = set([os.path.dirname(file) for file in audio_files])
    for rel_dir in rel_dirs_set:
        Path(os.path.join(args.outdir, rel_dir)).mkdir(parents=True, exist_ok=True)


    pad_data_ = partial(pad_data, in_dir=args.srcdir,out_dir=out_dir, trim=args.trim, pad=args.pad)
    with Pool(40) as p:
        rets = list(tqdm(p.imap(pad_data_, audio_files), total=len(audio_files)))


if __name__ == '__main__':
    main()
