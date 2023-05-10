# docker-guppy
Docker container with CUDA and GPU support for guppy basecalling of ONT reads. Initially made for use on vast.ai for quick and easy deployment of a listening guppy_basecall_server, but can be used anywhere else if the docker entrypoint and/or cmd are adjusted accordingly. Make sure to publish port 5555 too or make an SSH tunnel if possible (more secure than just exposing a port to the entire network/internet).

## Client side
Send some fast5's to the container on a local or remote server with for example:
```
guppy_basecall_client \
  --input_path reads \
  --save_path output_folder/basecall \
  --config dna_r9.4.1_450bps_fast.cfg \
  --port 192.168.0.64:5555 \
  --use_tcp
```
