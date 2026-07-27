# littlevillage_site

Static marketing/content website for The Hagedorn Little Village School, built with [Jaspr](https://jaspr.site). See [CLAUDE.md](CLAUDE.md) for the full project brief.

## Running the project

Run your project using `jaspr serve`.

The development server will be available on `http://localhost:8080`.

## Building the project

Build your project using:

```
jaspr build --sitemap-domain=www.littlevillage.org --sitemap-exclude='^/404\.html$'
```

The output will be located inside the `build/jaspr/` directory, including a
generated `sitemap.xml` covering every static and Sanity-sourced route (the
404 page is excluded since it isn't a real navigable page). `robots.txt`
lives as a static file at `web/robots.txt` and is copied over as-is,
pointing crawlers at the sitemap.

If the `--sitemap-domain` value ever diverges from `siteBaseUrl` in
`lib/constants/seo.dart`, update `web/robots.txt`'s `Sitemap:` line to match.
