# shellcheck disable=SC2164
cd playground/

rm -rf *

cd ../

fvm flutter build web

cp -r build/web/* ./playground/