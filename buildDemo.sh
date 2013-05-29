#Script to build the demo of this app for deployment
rm -r demo/*
cp *.html demo/
cp -r js/ demo/
mkdir demo/cgi
cp   cgi/userData.pl demo/cgi/
cp -r data/ demo/
cp -r css/ demo/
cp -r pages/ demo/
cp -r img/ demo/
cp -r images/ demo/
cd demo
tar -kcf currentDemo.tar *
