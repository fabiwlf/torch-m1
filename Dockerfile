FROM python:3.8.9 AS build

# Allow statements and log messages to immediately appear in the logs
ENV PYTHONUNBUFFERED True

ENV VIRTUAL_ENV=/opt/venv

# If one wants to build
RUN apt-get update -y && apt-get install -y --no-install-recommends build-essential gcc libsndfile1-dev jq sox cmake libopenblas-dev cargo gfortran liblapack-dev libomp-dev libopenmpi-dev && rm -rf /var/lib/apt/lists/*

# Install production dependencies.
RUN python -m venv $VIRTUAL_ENV && \
    . $VIRTUAL_ENV/bin/activate && \ 
    echo "source /opt/venv/bin/activate" >> ~/.bashrc && \
    pip install --upgrade pip setuptools wheel && \
    /bin/bash -c "source /opt/venv/bin/activate && if [[ \"$(uname -a)\" =~ \"aarch64\" ]] ; then pip install \"torch<1.10.2\" torchvision torchaudio  \"h5py>=2.10.0\" \"numpy<1.22,>=1.18\" \"PyYAML>=5.1.2\" \"cffi>=1.0\" \"scikit-learn>=0.19.1\" -f https://torch.kmtea.eu/whl/stable.html -f https://ext.kmtea.eu/whl/stable.html ; else pip install \"torch==1.10.2+cpu\" \"torchvision==0.11.3+cpu\" \"torchaudio==0.10.2+cpu\" -f https://download.pytorch.org/whl/torch_stable.html ; fi"


FROM python:3.8.9

RUN apt-get update -y && apt-get install -y --no-install-recommends libsndfile1 libomp-dev && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED True

#COPY --from=build /app /app
COPY --from=build /opt /opt

WORKDIR /app
COPY *.py /app

CMD /bin/bash -c "source /opt/venv/bin/activate && python test.py"
LABEL org.opencontainers.image.source https://github.com/fabiwlf/torch-m1