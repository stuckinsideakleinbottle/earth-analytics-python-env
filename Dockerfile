FROM jupyter/minimal-notebook:python-3.10

USER jovyan

RUN apt-get update && \
    apt install -y \
    libfmt-dev

RUN conda update conda 
RUN conda config --remove channels conda-forge
RUN conda config --add channels conda-forge
RUN conda config --set channel_priority strict

COPY environment.yml /home/jovyan/ 
RUN conda env update -n base -f /home/jovyan/environment.yml
# using ~/.bash_profile instead of ~/.bashrc for non-interactive tty (-it) containers
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/jovyan/.bash_profile && \
    echo "conda deactivate" >> /home/jovyan/.bash_profile && \
    echo "conda activate base" >> /home/jovyan/.bash_profile
RUN . /opt/conda/etc/profile.d/conda.sh && conda activate base && python -m ipykernel install --user --name base     
RUN source /home/jovyan/.bash_profile

# Install dev version of Earthpy
RUN pip install git+https://github.com/earthlab/earthpy@apppears
