# Offline-first PWA webapp

## Create a `.webmanifest` file
Follow the tutorials on the Internet. It's fairly simple.

## Service Worker code
- `cacheName` is primarily used for cache versioning.
    - E.g. when you update your caching strategy, change the `cacheName` to invalidate the older cache.
- Event listener `install`
  - This listener is called upon service worker registration.
  - `self.skipWaiting()` is generally very useful if you want your PWA app to always work with the latest version service worker.
    - Otherwise, the browser will wait for the older version service worker to unregister(?) before the new one takes over.
- Event listener `active`
  - This listener is called upon service worker starting, effectively on every page reload(?).
  - One typical thing to do in this phase is invalidate older caches.
    - This is implemented by removing all cache keys not equal to current `cacheName`.
- Event listener `fetch`
  - This listener is called upon every request the browser made.
  - Service worker intercepts the browser request before querying browser cache.
  - Personally I prefer the strategy I denote as `immutableAwareNetworkFirst`
    - First, it attempts to find out if the request is a immutable resource by attempting to query the service worker cache.
      - If so, return directly from the cache without even asking the browser cache.
    - Second, it attempts to fetch from the internet.
      - Only cache the response if `no-store` does not exist in its `Cache-Control` header.
    - Last, it attempts to return the version of copy in the cache if network fetch failed.
      
```ts
const cacheName = 'v1'

self.addEventListener('install', e => {
  // The waiting phase means you're only running one version of your site at once,
  // but if you don't need that feature,
  // you can make your new service worker activate sooner by calling self.skipWaiting().
  ;(self as any).skipWaiting()
})

self.addEventListener('activate', e => {
  // ;(e as any).waitUntil(
  caches.keys().then(keys => {
    return Promise.all(
      keys.map(key => (key !== cacheName ? caches.delete(key) : null)),
    )
  })
  // )
})

self.addEventListener('fetch', event => {
  ;(event as any).respondWith(immutableAwareNetworkFirst(event))
})

async function immutableAwareNetworkFirst(event) {
  if (!event.request.url.startsWith('http')) return await fetch(event.request)

  const cache = await caches.open(cacheName)

  //
  //
  // Intercept immutable requests
  const inCache = await caches.match(event.request)
  if (inCache && inCache.headers.get('cache-control').includes('immutable')) {
    return inCache
  }

  //
  //
  // Attempt network
  try {
    const resp = await fetch(event.request)
    const cacheControl = resp.headers.get('cache-control') || ''

    // Cache them if we can
    if (
      !cacheControl.includes(
        'no-store' /* IMPORTANT! Those requests are meant not to be cached */,
      )
    )
      cache.put(event.request, resp.clone())
    return resp
  } catch {
    return inCache
  }
}
```

## Browser code
- First, register the service worker by url.
- Then, trigger refresh on service worker update, and after the new service worker is activated.
  - The purpose is to make sure service workers captured all network requests. On its first install, some requests might have completed before it activates.
```ts
navigator.serviceWorker
  ?.register(SW_PATH)
  .then(reg => {
    // reg.update()
    reg.onupdatefound = () => {
      const newWorker = reg.installing
      if (newWorker)
        newWorker.onstatechange = () => {
          if (newWorker.state == 'activated') {
            location.replace(
              // Force all requests to be cached,
              // especially those send before sw is installed,
              // otherwise offline cache won't be complete
              location.href,
            )
          }
        }
    }
  })
  .catch(console.error)
```