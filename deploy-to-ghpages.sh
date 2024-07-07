flutter build web --base-href /quick-chat/
cd build/web
git init
git remote add gh-pages https://github.com/wilmarques/quick-chat.git
git fetch --all
git add -A
git commit -m "ci: Deploying"
git checkout -b gh-pages
git push gh-pages gh-pages
