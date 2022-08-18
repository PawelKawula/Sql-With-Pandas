Just my own repo to play around with `sqlite3`, `numpy` and `pandas`

If you want to run it on your local machine, you will have to
make sqlite-uuid and load into your sqlite3 database, you can
do so automatically by appending `.load PATH/uuid` in your ~/.sqliterc
file  
To obtain uuid.so file you can just run `make` in 
the submodule and then run `make` in this directory, which will
automatically create it in lib/ folder in this project and place uuid.so there
