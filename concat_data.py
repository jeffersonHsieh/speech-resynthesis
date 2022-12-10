from pathlib import Path
import os
import glob
import argparse
if __name__=="__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument('--data_dirs', required=True,nargs='+', type=Path)

    args = parser.parse_args()

    base = args.data_dirs[0].parent
    ns = '_'.join(map(lambda x:str(x.name),args.data_dirs))
    newd = base/f'COMBINED_{ns}'
    newd.mkdir(exist_ok=True,parents=True)

    concats = {}
    for split in ['train','val','test']:
        concats[split] = {}
        for p in glob.glob(str(base/f"**/{split}.txt"),recursive=True):
            k = Path(p).parent.name
            if k not in concats[split]:
                concats[split][k]=[]
            concats[split][k].append(p)
    
    for split,d in concats.items():
        for k,l in d.items():
            od = newd/k
            od.mkdir(exist_ok=True,parents=True)
            with (od/f"{split}.txt").open('w') as f:
                for inpath in l:
                    with open(inpath) as g:
                        for line in g:
                            f.write(line)

    