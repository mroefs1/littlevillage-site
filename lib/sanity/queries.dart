// GROQ queries, one per content type in the deployed schema
// (see `~/dev/hlvs-studio/hlvs/schemaTypes/`).
//
// Images are dereferenced straight to a CDN URL in the projection
// (`asset->url`) rather than returning the raw asset `_ref` — that avoids
// hand-parsing the `image-<hash>-<dims>-<ext>` ref format the Flutter app's
// `sanityImageUrl()` helper does, at the cost of one extra join per image.

const String siteSettingsQuery = '''
*[_type == "siteSettings"][0]{
  navigation[]{label, url, children[]{label, url}},
  footerLinks[]{label, url},
  socialLinks[]{platform, url},
  phone,
  email
}
''';

const String pageBySlugQuery = '''
*[_type == "page" && slug.current == \$slug][0]{
  title,
  "slug": slug.current,
  "heroImageUrl": heroImage.asset->url,
  body[]{
    ...,
    _type == "image" => {
      "imageUrl": asset->url
    }
  }
}
''';

const String newsListQuery = '''
*[_type == "news"] | order(published_date desc) [0...\$limit]{
  _id,
  title,
  "slug": slug.current,
  published_date,
  "heroImageUrl": hero_image.asset->url,
  body,
  link
}
''';

const String newsBySlugQuery = '''
*[_type == "news" && slug.current == \$slug][0]{
  _id,
  title,
  "slug": slug.current,
  published_date,
  "heroImageUrl": hero_image.asset->url,
  body,
  link
}
''';

const String eventListQuery = '''
*[_type == "event"] | order(event_date desc) [0...\$limit]{
  _id,
  title,
  "slug": slug.current,
  published_date,
  event_date,
  location,
  "flyerUrl": event_flyer.asset->url,
  "cardImageUrl": card_image.asset->url,
  description,
  ticket_link,
  "photoGalleryUrls": photo_gallery[].asset->url
}
''';

const String programListQuery = '''
*[_type == "program"]{
  _id,
  title,
  "slug": slug.current,
  category,
  ageRange,
  description,
  "relatedProgramSlugs": relatedPrograms[]->slug.current
}
''';

const String programBySlugQuery = '''
*[_type == "program" && slug.current == \$slug][0]{
  _id,
  title,
  "slug": slug.current,
  category,
  ageRange,
  description,
  "relatedProgramSlugs": relatedPrograms[]->slug.current
}
''';

const String staffMembersQuery = '''
*[_type == "staffMember"]{
  name,
  title,
  bio,
  "photoUrl": photo.asset->url
}
''';

const String boardMembersQuery = '''
*[_type == "boardMember"]{
  name,
  title,
  bio,
  "photoUrl": photo.asset->url
}
''';
