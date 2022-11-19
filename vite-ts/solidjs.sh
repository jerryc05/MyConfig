npx degit solidjs/templates/ts ./

pnpm up -Lri
#        ||└ interactive
#        |└- recursive
#        └-- update to latest version

pnpm i @babel/core babel-preset-solid -D

cat <<eof > .babelrc
{
  "presets": ["solid"]
}
eof
