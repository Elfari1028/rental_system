'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "f7d6c591171e7c5ce324b998c0773c0b",
"assets/FontManifest.json": "b9cdc74f607a740e6158e9e011cc4c74",
"assets/fonts/KaiGenGothicCN-Normal.ttf": "a8073fd2acf903183aa1910f3166f346",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/images/avatar_default.jpg": "89a682404afb42ddac754c37d89b4920",
"assets/images/background.png": "38484100d7bb31c07454ecb7f0ac5d48",
"assets/images/splash.png": "fd594f9114d72c1ed952f7f9b25b12dc",
"assets/images/title.png": "6f9ee30041688f5b0ccf638485f0bfb8",
"assets/images/title_white.png": "b919d847c16c8fe015108ab2657e336e",
"assets/LICENSE": "b27b9e2762b80f66afde9684e84bb750",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/packages/open_iconic_flutter/assets/open-iconic.woff": "3cf97837524dd7445e9d1462e3c4afe2",
"assets/packages/progress_dialog/assets/double_ring_loading_io.gif": "e5b006904226dc824fdb6b8027f7d930",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "538cf1c524deac07d75553fb3961abed",
"/": "538cf1c524deac07d75553fb3961abed",
"main.dart.js": "6ef81adbc30a516e7b28d8a93456e788",
"manifest.json": "08f875e244b63f81d519944b75c1c4cd"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
