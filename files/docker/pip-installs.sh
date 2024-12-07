



echo "------------------- Installation of python PIP packages required by pyhgtmap ---------------------"

# setup a virtual environment, because those packages are not standard python packages
mkdir -p /venv
python3 -m venv --system-site-packages /venv 

# Using $VENV allows to run python pip from the virtual environment
# it avoids the need of executing    source    /venv/bin/activate  
VENV="/venv/bin/python3 -m"

# installation of pip packages
$VENV  pip install pybind11-rdp 
$VENV pip install class-registry
$VENV pip install shapely
$VENV pip install nptyping
$VENV pip install npyosmium
$VENV pip install colorlog

