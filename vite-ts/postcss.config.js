/*
pnpm i -D postcss postcss-at-rules-variables postcss-csso postcss-preset-env
*/

/* eslint-disable unicorn/prefer-module, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-var-requires, @typescript-eslint/no-unsafe-assignment */
module.exports = {
  plugins: [
    require('postcss-at-rules-variables'),
    ...process.env.NODE_ENV === 'production' ? [require('postcss-csso')] : [],
    require('postcss-preset-env')({ stage: 0 }),
  ]
}
