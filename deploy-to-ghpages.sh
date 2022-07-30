flutter build web --base-href /quick-chat/
git add -f build/web
git subtree pull --prefix build/web origin gh-pages
git commit -m "ci: Deploying"
git subtree push --prefix build/web origin gh-pages
