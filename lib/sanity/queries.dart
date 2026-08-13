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
  email,
  heroGallery[]{
    "url": asset->url,
    alt
  }
}
''';

const String pageBySlugQuery = '''
*[_type == "page" && slug.current == \$slug][0]{
  title,
  "slug": slug.current,
  "heroImageUrl": heroImage.asset->url,
  images[]{
    "url": asset->url,
    alt
  },
  body[]{
    ...,
    _type == "image" => {
      "imageUrl": asset->url
    },
    _type == "fileDownload" => {
      "fileUrl": file.asset->url
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

const String newsletterListQuery = '''
*[_type == "newsletter"] | order(published_date desc) [0...\$limit]{
  _id,
  title,
  published_date,
  "fileUrl": file.asset->url
}
''';

const String documentListQuery = '''
*[_type == "doc"] | order(title asc){
  _id,
  title,
  "fileUrl": file.asset->url
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
  "imageUrl": image.asset->url,
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
  "imageUrl": image.asset->url,
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

const String parentAssociationQuery = '''
*[_type == "parentAssociation"][0]{
  intro,
  duesAnnual,
  duesLifetime,
  signupUrl,
  boardMembers[]{role, name},
  contacts[]{name, email}
}
''';

// `event_date` is a plain `date` field, not `datetime`. Verified against the
// live dataset: `dateTime(event_date)` returns null for a bare date string
// (so a `dateTime(event_date) >= now()` filter always matches nothing),
// while GROQ's plain string comparison between `date` and `now()` (a
// datetime) works correctly — do not add a `dateTime()` cast here.
const String paEventListQuery = '''
*[_type == "pa_event" && event_date >= now()] | order(event_date asc){
  _id,
  title,
  published_date,
  event_date,
  location,
  description,
  google_meet
}
''';
