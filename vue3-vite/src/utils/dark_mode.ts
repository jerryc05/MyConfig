const bodyClasses = document.body.classList

function setDark () {
  bodyClasses.add('dark')
}

function setLight () {
  bodyClasses.remove('dark')
}

function isSystemDark () {
  return window.matchMedia('(prefers-color-scheme:dark)').matches
}

export function detectAndSetDarkMode () {
  const userSettingIsDark = localStorage.getItem('dark')
  if (userSettingIsDark === '1' || (userSettingIsDark === null && isSystemDark())) {
    setDark()
    return true
  }
  setLight()
  return false
}

export function setDarkMode (isDark?: boolean) {
  if (isDark === null) {
    if (isSystemDark()) {
      setDark()
    } else {
      setLight()
    }
    localStorage.removeItem('dark')
  } else if (isDark) {
    setDark()
    localStorage.dark = 1
  } else {
    setLight()
    localStorage.dark = 0
  }
}
