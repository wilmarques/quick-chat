flutter build web --base-href /quick-chat/
cd build/web
git init
git remote add origin https://github.com/wilmarques/quick-chat.git
git fetch
git checkout -b gh-pages
git add -A
git commit -m "ci: Deploying"
git push origin gh-pages --force
