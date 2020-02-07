# To run this dockerfile
# docker build -t spconv -f build.dockerfile .

FROM continuumio/miniconda3

# Install building essentials
RUN apt-get update && apt-get install -y libboost-dev gcc-7 g++-7 make
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 50
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 50

# Install newer cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.6/cmake-3.15.6-Linux-x86_64.tar.gz -O cmake.tgz && \
    mkdir /opt/cmake && \
    tar xvzf cmake.tgz -C /opt && \
    ln -s /opt/cmake-3.15.6-Linux-x86_64/bin/cmake /usr/local/bin/cmake

# install pytorch and cuda
RUN conda create -n workspace python=3.6 && \
    conda install -n workspace -y pytorch=1.3 torchvision cudatoolkit=9.2 -c pytorch && \
    conda install -n workspace -y cudatoolkit-dev=9.2 cudnn -c conda-forge

# Use patched version of spconv from my github
# or you can do COPY . /spconv
RUN git clone --recursive https://github.com/cmpute/spconv.git

ENV PATH=$PATH:/opt/conda/envs/workspace/bin
ENV LD_LIBRARY_PATH=/opt/conda/envs/workspace/lib
ENV CUDA_HOME=/opt/conda/envs/workspace
RUN gcc -v
RUN cd spconv && /opt/conda/envs/workspace/bin/python setup.py bdist_wheel

# To extract the generated wheel
# docker create --name temp spconv
# docker cp temp:/spconv/dist <target-location>
