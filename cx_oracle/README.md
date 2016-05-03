The skeleton recipe was created using: `conda skeleton pypi cx_oracle`

But this require the oracle client for which I have a conda package so I added that in the requirements.

## Issues

1. It compiles C code and builds a shared object so I tried to give it the `preserve_egg_directory` flag but maybe that is not required. The flag gets ignored.

2. Env variable `ORACLE_HOME` needs to be set before this compiles. For now this is hard coded in build.sh and points to my local copy of the instantclient - not sure how to use the conda installed oracle-instantclient location; however, this is still ok since I only need it when building `cx_oracle` so maybe I can include it with the recipe.

3. Next the `cx_Oracle.so` is built but the rpath is not correctly set - I thought conda automatically handles this part. Do this manually as follows

  ```
  #!/bin/bash
  
  NAME=cx_oracle-5.2.1-py27_1
  TNAME=$NAME'.tar'
  BNAME=$NAME'.tar.bz2'
  ENAME=cx_Oracle-5.2.1-py2.7-macosx-10.5-x86_64.egg
  
  bunzip2 $BNAME
  mkdir tmp
  cp $TNAME tmp/
  cd tmp
  tar xvf $TNAME
  
  cd lib/python*/site-packages/
  mv $ENAME $ENAME'.z'
  mkdir $ENAME && mv cx_Oracle*.egg.z $ENAME 
  cd $ENAME && unzip *.egg
  rm *.egg
  
  install_name_tool -add_rpath @loader_path/../../../ cx_Oracle.so
  
  # also need to update info/files before creating package
  #cd ../../../../
  #rm $TNAME
  #tar cvf $TNAME info/ lib/
  #bzip2 -z $TNAME
  #mv $BNAME ../.
  ```

4. Finally, I'm not able to test with `conda install --use-local cx_oracle` since the md5 for the file that was created by conda-build is different from this modified file and it expects the file that was created by conda-build.

5. Doing a `anaconda upload cx_oracle*.bz2` pushes it to anaconda and now if I do a `conda install -c jsandhu cx_oracle=5.2.1`, it works fine. So I can't really test it till I push it anaconda.
