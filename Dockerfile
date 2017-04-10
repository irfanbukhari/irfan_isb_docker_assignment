FROM jupyter/scipy-notebook

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Julia dependencies
RUN echo "deb http://ppa.launchpad.net/staticfloat/juliareleases/ubuntu trusty main" > /etc/apt/sources.list.d/julia.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3D3D3ACC && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    julia \
    libnettle4 && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER


# Install IJulia packages as jovyan and then move the kernelspec out
# to the system share location. Avoids problems with runtime UID change not
# taking effect properly on the .local folder in the jovyan home dir.
RUN julia -e 'Pkg.add("IJulia")' && \
    mv $HOME/.local/share/jupyter/kernels/julia* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local

# Show Julia where conda libraries are
# Add essential packages
RUN echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" > /home/$NB_USER/.juliarc.jl && \
    julia -e 'Pkg.add("Gadfly")' && julia -e 'Pkg.add("RDatasets")' && julia -F -e 'Pkg.add("HDF5")'

# Precompile Julia pakcages
RUN julia -e 'using IJulia' && julia -e 'using Gadfly' && julia -e 'using RDatasets'&& julia -e 'using HDF5'
