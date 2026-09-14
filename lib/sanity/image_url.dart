// Sanity's image pipeline, applied to the CDN URLs the GROQ projections
// already dereference (`asset->url`).
//
// Those URLs point at the *original* upload, which for a photo straight off
// a camera can be several thousand pixels wide and several megabytes - the
// Facilities gallery's OT/PT photo is 4608x3072. Requesting a display width
// instead lets Sanity resize, re-encode and cache it at the edge, and
// `auto=format` serves WebP/AVIF to browsers that accept it.
//
// `fit=max` never upscales and never crops: an image already smaller than
// the requested width is returned untouched. That matters because these
// are editor-uploaded photos of unknown size, and cropping would silently
// cut the subject out of a portrait-orientation shot.
//
// Same convention already used inline by `pressItemListQuery`; this is the
// shared version so every call site gets it the same way.
String sanityImageUrl(String url, {required int width}) {
  // Leave anything that isn't a Sanity CDN asset alone rather than
  // appending parameters a different host would ignore or choke on.
  if (!url.startsWith('https://cdn.sanity.io/')) return url;
  final separator = url.contains('?') ? '&' : '?';
  return '$url${separator}w=$width&fit=max&auto=format';
}
