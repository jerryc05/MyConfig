import {
  vue_extends, vue_parser,
  vue_parserOptions_extraFileExtensions, vue_plugins,
  vue_rules
} from './.eslintrc.vue.js'

/* eslint-disable unicorn/prefer-module, unicorn/prefer-module */
const MAX_LEN = 115
const INDENT = 2


/** @type {import('eslint').Linter.Config} */
module.exports = {
  root: true,
  env: {
    browser: true,
    es2022: true, // TODO: check new version
    node: true
  },
  extends: [
    ...vue_extends,

    'eslint:all',
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',

    'plugin:optimize-regex/all',
    'plugin:json/recommended',
    'plugin:markdown/recommended',
    'plugin:n/recommended',
    'plugin:no-unsanitized/DOM',
    'plugin:promise/recommended',
    'plugin:security/recommended',
    'plugin:sonarjs/recommended',
    'plugin:unicorn/all',
  ],
  parser: vue_parser,
  parserOptions: {
    ecmaVersion: 'latest',
    parser: '@typescript-eslint/parser',
    sourceType: 'module',
    tsconfigRootDir: __dirname,
    project: ['./tsconfig.json'],
    extraFileExtensions: [...vue_parserOptions_extraFileExtensions],
  },
  plugins: [
    ...vue_plugins,

    '@typescript-eslint',

    'html',
    'json',
    'markdown',
    'n',
    'no-secrets',
    'promise',
    'sonarjs',
  ],
  ignorePatterns: ['**/*.d.ts', 'node_modules/**', 'dist/**', '**/vite.config.*'],
  settings: {
    'html/indent': INDENT,
  },
  rules: {
    ...vue_rules,

    // enabled built-in
    'indent': ['error', INDENT],
    'jsx-quotes': ['error', 'prefer-single'],
    'linebreak-style': ['error', 'unix'],
    'quotes': ['error', 'single', { 'avoidEscape': true }],
    'semi': ['error', 'never'],

    // enabled plugin
    'array-element-newline': ['error', 'consistent'],
    'arrow-parens': ['error', 'as-needed'],
    'comma-dangle': ['error', 'only-multiline'],
    'curly': ['error', 'multi'],
    'dot-location': ['error', 'property'],
    'func-style': ['error', 'declaration'],
    'function-paren-newline': ['error', 'consistent'],
    'max-len': [
      'error', {
        'code': MAX_LEN,
        'ignoreComments': true
      }
    ],
    'no-extra-parens': [
      'error', 'all', {
        'nestedBinaryExpressions': false,
        'enforceForArrowConditionals': false
      }
    ],
    'no-multi-spaces': ['error', { ignoreEOLComments: true }],
    'no-multiple-empty-lines': ['error', { 'max': 6 }],
    'no-secrets/no-secrets': 'error',
    'no-warning-comments': 'warn',
    'nonblock-statement-body-position': ['warn', 'below'],
    'sort-imports': ['error', { 'ignoreCase': true }],
    'space-before-function-paren': ['error', 'never'],

    // disabled
    '@typescript-eslint/no-non-null-assertion': 'off',
    'capitalized-comments': 'off',
    'function-call-argument-newline': 'off',
    'id-length': 'off', 
    'lines-between-class-members': 'off',
    'line-comment-position': 'off',
    'max-classes-per-file': 'off',
    'max-lines': 'off',
    'max-params': 'off',
    'multiline-comment-style': 'off',
    'multiline-ternary': 'off',
    'n/no-missing-import': 'off',  // Only vite
    'n/no-unpublished-import': 'off',  // Only vite
    'n/no-unsupported-features/es-syntax': 'off',
    'no-console': 'off',
    'no-inline-comments': 'off',
    'no-ternary': 'off',
    'object-curly-spacing': 'off',
    'object-property-newline': 'off',
    'one-var': 'off',
    'padded-blocks': 'off',
    'quote-props': 'off',
    'sort-keys': 'off',
    'sort-vars': 'off',
    'unicorn/filename-case': [
      'error', {
        cases: {
          kebabCase: true,
          pascalCase: true,
        }
      }
    ],
    'unicorn/no-null': 'off',
    'unicorn/prevent-abbreviations': 'off',
  },
}
