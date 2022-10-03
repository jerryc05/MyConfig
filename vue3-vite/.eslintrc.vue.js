export const vue_extends = [
  'plugin:vue/base',
  'plugin:vue/vue3-recommended',
]

export const vue_parser='vue-eslint-parser' // must use for vue SFC
export const vue_parserOptions_extraFileExtensions=['.vue']
export const vue_plugins=['vue']

export const vue_rules = {
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
  'vue/max-len': [
    'error', {
      'code': MAX_LEN,
      'ignoreStrings': true,
      'ignoreComments': true,
    }
  ],
  'vue/next-tick-style': 'error',
  'vue/no-this-in-before-route-enter': 'error',
  'vue/no-useless-mustaches': 'error',
  'vue/no-useless-v-bind': 'error',
  'vue/prefer-prop-type-boolean-first': 'warn',
  'vue/v-on-function-call': ['error', 'never'],


  'vue/max-attributes-per-line': 'off',
}
