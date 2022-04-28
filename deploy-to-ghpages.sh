rm -rf build
git push --delete origin gh-pages
flutter build web --base-href /quick-chat/
git add -f build/web
git commit -m "Deploying"
git subtree push --prefix build/web origin gh-pages
git reset HEAD^ --hard
