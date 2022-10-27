/* eslint-disable unicorn/prefer-module */
const MAX_LEN = [
  'warn', {
    code: 100,
    ignoreComments: true,
    ignoreRegExpLiterals: true,
    ignoreStrings: true,
  }
]
const INDENT = 2
const QUOTE = ['warn', 'single', {avoidEscape: true}]
const ESLINT_PARSER = '@typescript-eslint/parser'


/** @type {import('eslint').Linter.Config} */
// eslint-disable-next-line no-unused-vars,@typescript-eslint/no-unused-vars
const vue = {
  extends: [
    'plugin:vue/base',
    'plugin:vue/vue3-recommended',
  ],
  parser: 'vue-eslint-parser', // must use for vue SFC
  parserOptions: {
    extraFileExtensions: ['.vue'],
    parser: ESLINT_PARSER,
  },
  plugins: ['vue'],
  rules: {
    'vue/component-api-style': 'error',
    'vue/html-button-has-type': 'error',
    'vue/html-closing-bracket-newline': [
      'error', {
        multiline: 'never',
        singleline: 'never'
      }
    ],
    'vue/html-indent': [
      'error', 2, {
        alignAttributesVertically: false,
        attribute: 1
      }
    ],
    'vue/html-quotes': QUOTE,
    'vue/html-self-closing': ['error', {html: {normal: 'never'}}],
    'vue/max-len': [MAX_LEN[0], {...MAX_LEN[1], ignoreHTMLAttributeValues: true}],
    'vue/next-tick-style': 'error',
    'vue/no-this-in-before-route-enter': 'error',
    'vue/no-useless-mustaches': 'error',
    'vue/no-useless-v-bind': 'error',
    'vue/prefer-prop-type-boolean-first': 'warn',
    'vue/v-on-function-call': ['error', 'never'],

    'vue/max-attributes-per-line': 'off',

    'max-len': 'off',
  }
}

/** @type {import('eslint').Linter.Config} */
// eslint-disable-next-line no-unused-vars,@typescript-eslint/no-unused-vars
const react = {
  extends: [
    'plugin:react/all',
    'plugin:react/jsx-runtime'
  ],
  parser: ESLINT_PARSER,
  plugins: ['react'],
  settings: {
    react: {
      version: 'detect',
    },
  },

  rules: {
    'react/jsx-filename-extension': ['error', {extensions: ['.jsx', '.tsx']}],
    'react/jsx-indent': ['error', INDENT],
    'react/jsx-indent-props': ['error', INDENT],

    'react/jsx-sort-props': 'off',
    'react/require-default-props': 'off',
  }
}

const framework = vue

const plugins = [
  ...framework.plugins,

  '@typescript-eslint',

  'json',
  'markdown',
  'n',
  'no-secrets',
  'promise',
  'sonarjs',
]
if (!plugins.includes('vue')) plugins.push('html')


/** @type {import('eslint').Linter.Config} */
module.exports = {
  env: {
    browser: true,
    es2022: true,
    node: true
  },
  extends: [
    ...framework.extends,

    'eslint:all',

    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    'plugin:@typescript-eslint/strict',

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
  parser: framework.parser ?? ESLINT_PARSER,
  parserOptions: {
    ecmaFeatures: {impliedStrict: true, jsx: true},
    ecmaVersion: 'latest',
    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
    extraFileExtensions: framework.parserOptions?.extraFileExtensions,
    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
    parser: framework.parserOptions?.parser,
    project: ['./tsconfig.json'],
    sourceType: 'module',
    tsconfigRootDir: __dirname,
  },
  plugins,
  root: true,
  settings: {
    'html/indent': INDENT,
  },

  rules: {
    // enabled
    '@typescript-eslint/consistent-type-assertions': 'error',
    '@typescript-eslint/consistent-type-definitions': ['error', 'type'],
    '@typescript-eslint/no-redundant-type-constituents': 'error',
    '@typescript-eslint/prefer-readonly': 'warn',
    '@typescript-eslint/switch-exhaustiveness-check': 'error',
    'array-element-newline': ['error', 'consistent'],
    'arrow-parens': ['error', 'as-needed'],
    'comma-dangle': ['error', 'only-multiline'],
    curly: ['error', 'multi'],
    'dot-location': ['error', 'property'],
    'func-style': ['error', 'declaration'],
    'function-paren-newline': ['error', 'consistent'],
    indent: ['warn', INDENT, {SwitchCase: 1}],
    // eslint-disable-next-line @typescript-eslint/no-base-to-string, @typescript-eslint/restrict-template-expressions
    'jsx-quotes': ['warn', `prefer-${QUOTE[1]}`],
    'linebreak-style': ['error', 'unix'],
    'max-len': MAX_LEN,
    'multiline-ternary': ['warn', 'always-multiline'],
    'no-console': ['warn', {allow: ['error']}],
    'no-extra-parens': [
      'warn', 'all', {
        enforceForArrowConditionals: false,
        ignoreJSX: 'all',
        nestedBinaryExpressions: false,
      }
    ],
    'no-multi-spaces': ['error', {ignoreEOLComments: true}],
    'no-secrets/no-secrets': 'error',
    'no-warning-comments': 'warn',
    'quote-props': ['warn', 'as-needed'],
    quotes: QUOTE,
    semi: ['warn', 'never'],
    'sort-imports': [
      'warn', {
        allowSeparatedGroups: true,
        memberSyntaxSortOrder: ['all', 'multiple', 'single', 'none']
      }
    ],
    'sort-keys': ['error', 'asc', {allowLineSeparatedGroups: true, natural: true}],
    'space-before-function-paren': ['error', 'never'],

    // enabled plugin
    'unicorn/filename-case': [
      'warn', {
        cases: {
          camelCase: true,
          pascalCase: true,
        }
      }
    ],

    // disabled
    'capitalized-comments': 'off',
    'consistent-return': 'off',
    'default-case': 'off',  // only typescript
    'function-call-argument-newline': 'off',
    'id-length': 'off',
    'line-comment-position': 'off',
    'lines-between-class-members': 'off',
    'max-classes-per-file': 'off',
    'max-lines': 'off',
    'max-lines-per-function': 'off',
    'max-params': 'off',
    'max-statements': 'off',
    'multiline-comment-style': 'off',
    'n/no-missing-import': 'off',  // only vite
    'n/no-unpublished-import': 'off',  // only vite
    'n/no-unsupported-features/es-syntax': 'off',
    'no-inline-comments': 'off',
    'no-magic-numbers': 'off',
    'no-shadow': 'off',  // only typescript
    'no-ternary': 'off',
    'object-property-newline': 'off',
    'one-var': 'off',
    'padded-blocks': 'off',
    'sonarjs/cognitive-complexity': 'off',
    'sort-vars': 'off',
    'unicorn/no-keyword-prefix': 'off',
    'unicorn/no-null': 'off',
    'unicorn/prefer-query-selector': 'off',
    'unicorn/prevent-abbreviations': 'off',
    'unicorn/switch-case-braces': 'off',
    'wrap-regex': 'off',

    ...framework.rules,
  }
}