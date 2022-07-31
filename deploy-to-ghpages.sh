git subtree add --prefix build/web origin gh-pages
flutter build web --base-href /quick-chat/
git add -f build/web
git commit -m "ci: Deploying"
git subtree push --prefix build/web origin gh-pages
git reset HEAD~2 --hard
