FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

RUN apt-get update \
    && apt-get install -y --fix-missing --no-install-recommends\
    libssl-dev build-essential \
    git libboost-all-dev curl wget\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://pyenv.run | bash
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN pyenv install 3.7.8
RUN pyenv global 3.7.8
RUN pyenv rehash

RUN pip install torch===1.1.0 -f https://download.pytorch.org/whl/cu90/torch_stable.html
RUN wget https://raw.githubusercontent.com/Jia-Research-Lab/PointGroup/master/requirements.txt

RUN pip install -r requirements.txt && pip install wheel

RUN git clone https://github.com/sparsehash/sparsehash.git && cd sparsehash && ./configure && make install

RUN git clone https://github.com/Jia-Research-Lab/PointGroup.git  --recursive 

WORKDIR PointGroup

RUN cd lib/spconv && python setup.py bdist_wheel && pip install dist/spconv-1.0-cp37-cp37m-linux_x86_64.whl 

RUN cd lib/pointgroup_ops && python setup.py develop