/*
pnpm i -D modern-normalize postcss postcss-at-rules-variables postcss-csso postcss-preset-env postcss-variable-compress
*/

/* eslint-disable unicorn/prefer-module, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-var-requires, @typescript-eslint/no-unsafe-assignment */
module.exports = {
  plugins: [
    require('postcss-at-rules-variables'),
    require('postcss-preset-env')({ stage: 0 }),


    ...process.env.NODE_ENV === 'production'
      ? [
        require('postcss-csso')({
          comments: false,
          forceMediaMerge: true,
        }),
        require('postcss-variable-compress'),
      ]
      : [],
  ]
}
