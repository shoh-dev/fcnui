cd playground/

rm -rf *

cd ../

fvm flutter build web

cp -r build/web/* ./playground/

cd ..

sh complay.sh