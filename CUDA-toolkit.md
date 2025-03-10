# Steps to download the cuda toolkit. (v xx.y ....)

1. Google search for CUDA toolkit and download the runfile

2. Run the following:
```bash
chmod +x cuda_xx.y.<YOUR DOWNLOADED VERSION>.run
mkdir -p ./tmp
./cuda_xx.y.<YOUR DOWNLOADED VERSION>.run --tmpdir=./tmp --toolkit --toolkitpath=<YOUR LOCAL DIR>/cuda-xx.y
```
3. After the toolkit is installed, don't forget to  `rm tmp/cuda-installer.log`
