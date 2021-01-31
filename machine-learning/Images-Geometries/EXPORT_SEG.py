import os


data_dir = 'SOFTWAREdataset' 
import argparse
ap = argparse.ArgumentParser()
ap.add_argument("mat", 
   help="MRI folder name")
ap.add_argument("-g", "--gpu", required=False, default=-1, type=int,
   help="gpu number to use (-1 CPU, 0 gpu)")
args = ap.parse_args()

filename = args.mat
if __name__ == '__main__':
    # The GPU device id
    CUDA_VISIBLE_DEVICES = str(args.gpu)

    net=0
    print('  Short-axis image analysis')
    os.system('CUDA_VISIBLE_DEVICES={0} python3 ukbb_cardiac/common/export_seg.py --seq_name sa --data_dir {3} '
                      '--net {1} --model_path ukbb_cardiac/common/models/v3_{1}/v3_{1}.ckpt-2000 --filename {2}'.format(CUDA_VISIBLE_DEVICES, net, filename, data_dir))

    print('  Long-axis image analysis  (1)')
    os.system('CUDA_VISIBLE_DEVICES={0} python3 ukbb_cardiac/common/export_seg.py --seq_name la1 --data_dir {3} '
                      '--net {1} --model_path ukbb_cardiac/common/models/la3_{1}/la3_{1}.ckpt-2000 --filename {2}'.format(CUDA_VISIBLE_DEVICES, net, filename, data_dir))

    print('  Long-axis image analysis (2)')
    os.system('CUDA_VISIBLE_DEVICES={0} python3 ukbb_cardiac/common/export_seg.py --seq_name la2 --data_dir {3} '
                      '--net {1} --model_path ukbb_cardiac/common/models/la5_{1}/la5_{1}.ckpt-2000 --filename {2}'.format(CUDA_VISIBLE_DEVICES, net, filename, data_dir))



    print('  Save in MRI coordinates')
    os.system('CUDA_VISIBLE_DEVICES={0} python3 exportSEGsoftware.py ' + filename)
