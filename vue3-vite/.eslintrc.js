/* eslint-disable unicorn/prefer-module, unicorn/prefer-module */
const MAX_LEN = [
  'error', {
    code: 100,
    ignoreComments: true,
    ignoreStrings: true,
    ignoreRegExpLiterals: true,
  }
]
const INDENT = 2


const vue = {
  extends: [
    'plugin:vue/base',
    'plugin:vue/vue3-recommended',
  ],
  parser: 'vue-eslint-parser', // must use for vue SFC
  parserOptions_extraFileExtensions: ['.vue'],
  plugins: ['vue'],
  rules: {
    'vue/component-api-style': 'error',
    'vue/first-attribute-linebreak': [
      'error', {
        'singleline': 'beside',
        'multiline': 'beside'
      }
    ],
    'vue/html-button-has-type': 'error',
    'vue/html-closing-bracket-newline': [
      'error', {
        'singleline': 'never',
        'multiline': 'never'
      }
    ],
    'vue/html-indent': [
      'error', 2, {
        'attribute': 1,
        'alignAttributesVertically': false
      }
    ],
    'vue/max-len': MAX_LEN,
    'vue/next-tick-style': 'error',
    'vue/no-this-in-before-route-enter': 'error',
    'vue/no-useless-mustaches': 'error',
    'vue/no-useless-v-bind': 'error',
    'vue/prefer-prop-type-boolean-first': 'warn',
    'vue/v-on-function-call': ['error', 'never'],


    'vue/max-attributes-per-line': 'off',
  }

}

const react = {
  extends: [
    "plugin:react/all",
    "plugin:react/jsx-runtime"
  ],
  parser: "@typescript-eslint/parser",
  plugins: ['react'],
  settings: {
    react: {
      version: "detect",
    },
  },
  rules: {
    'react/jsx-indent': ['error', INDENT],
    'react/jsx-filename-extension': ['error', { extensions: ['.js', '.jsx', '.ts', '.tsx'] }],
  }
}


/** @type {import('eslint').Linter.Config} */
module.exports = {
  root: true,
  env: {
    browser: true,
    es2022: true, // TODO: check new version
    node: true
  },
  extends: [
    ...vue.extends,

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
  parser: vue.parser,
  parserOptions: {
    ecmaVersion: 'latest',
    ecmaFeatures: {
      jsx: true
    },
    parser: '@typescript-eslint/parser',
    sourceType: 'module',
    tsconfigRootDir: __dirname,
    project: ['./tsconfig.json'],
    extraFileExtensions: [...vue.parserOptions_extraFileExtensions],
  },
  plugins: [
    ...vue.plugins,

    '@typescript-eslint',

    'html',
    'json',
    'markdown',
    'n',
    'no-secrets',
    'promise',
    'sonarjs',
  ],
  ignorePatterns: ['**/*.d.ts', 'node_modules/**', 'dist/**', '**/vite.config.*', '**/.eslintrc.js'],
  settings: {
    'html/indent': INDENT,
  },
  rules: {
    ...vue.rules,

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
    'max-len': MAX_LEN,
    'no-extra-parens': [
      'error', 'all', {
        enforceForArrowConditionals: false,
        ignoreJSX: 'all',
        nestedBinaryExpressions: false,
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
    'wrap-regex': 'off',
  },
}
