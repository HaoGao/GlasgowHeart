export PATH=/xlwork4/2026068l/Lukasz/SOFTWARE/miniconda3/envs/py36/bin:/usr/local/cuda/bin:/xlwork4/2026068l/Lukasz/SOFTWARE/miniconda3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}
source activate py36
echo $PATH
echo $LD_LIBRARY_PATH
export CUDA_VISIBLE_DEVICES=1
