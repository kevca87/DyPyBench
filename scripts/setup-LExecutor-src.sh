#!/usr/bin/bash

ROOT_DIR=/DyPyBench

cd $ROOT_DIR

#update the LExecutor source from the forked repo.
if [[ ! -d $ROOT_DIR/LExecutor ]]
then
    git clone https://github.com/michaelpradel/LExecutor.git $ROOT_DIR/LExecutor
    cd $ROOT_DIR/LExecutor

    #create virtual env name vm, pinned to the system interpreter and with a
    #clean environment so the base can never resolve to a project's .vm
    deactivate 2>/dev/null || true
    unset VIRTUAL_ENV PYTHONHOME
    hash -r
    #invoke via "python3 -m" so a contaminated /usr/local/bin/virtualenv
    #launcher shebang is bypassed entirely
    python3 -m virtualenv -p /usr/bin/python3 .vm
    if ! grep -qE '^home = /usr' .vm/pyvenv.cfg
    then
        echo "ERROR: LExecutor .vm was not created from the system python:"
        grep -E '^(home|base-executable)' .vm/pyvenv.cfg
        exit 1
    fi
else
    cd $ROOT_DIR/LExecutor
    git pull
fi

#activate virtual env
if [[ -d ".vm/local" ]]
then
    source .vm/local/bin/activate
elif [[ -d ".vm/bin" ]]
then
    source .vm/bin/activate
else
    echo "Unable to create virtual env"
    exit
fi

pip install -r ./requirements.txt
pip install -e .

#deactivate .vm
deactivate

