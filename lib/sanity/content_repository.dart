import 'client.dart';
import 'models/event_item.dart';
import 'models/news_post.dart';
import 'models/page_content.dart';
import 'models/person.dart';
import 'models/program.dart';
import 'models/site_settings.dart';
import 'queries.dart';

/// Interface between page components and Sanity. Pages depend only on this,
/// never on [SanityClient]/GROQ directly — that's what lets a future
/// Serverpod-backed implementation (or a per-page SSR swap) slot in later
/// without touching page code.
abstract class ContentRepository {
  Future<SiteSettings> getSiteSettings();
  Future<PageContent?> getPage(String slug);
  Future<List<NewsPost>> getNewsPosts({int limit = 10});
  Future<NewsPost?> getNewsPost(String slug);
  Future<List<EventItem>> getEvents({int limit = 10});
  Future<List<Program>> getPrograms();
  Future<Program?> getProgram(String slug);
  Future<List<StaffMember>> getStaffMembers();
  Future<List<BoardMember>> getBoardMembers();
}

class SanityContentRepository implements ContentRepository {
  final SanityClient _client;

  const SanityContentRepository([this._client = const SanityClient()]);

  @override
  Future<SiteSettings> getSiteSettings() async {
    final result = await _client.fetch(siteSettingsQuery);
    return SiteSettings.fromJson(result as Map<String, dynamic>? ?? const {});
  }

  @override
  Future<PageContent?> getPage(String slug) async {
    final result = await _client.fetch(pageBySlugQuery, {'slug': slug});
    if (result == null) return null;
    return PageContent.fromJson(result as Map<String, dynamic>);
  }

  @override
  Future<List<NewsPost>> getNewsPosts({int limit = 10}) async {
    final result = await _client.fetch(newsListQuery, {'limit': limit});
    return (result as List<dynamic>)
        .map((item) => NewsPost.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<NewsPost?> getNewsPost(String slug) async {
    final result = await _client.fetch(newsBySlugQuery, {'slug': slug});
    if (result == null) return null;
    return NewsPost.fromJson(result as Map<String, dynamic>);
  }

  @override
  Future<List<EventItem>> getEvents({int limit = 10}) async {
    final result = await _client.fetch(eventListQuery, {'limit': limit});
    return (result as List<dynamic>)
        .map((item) => EventItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Program>> getPrograms() async {
    final result = await _client.fetch(programListQuery);
    return (result as List<dynamic>)
        .map((item) => Program.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Program?> getProgram(String slug) async {
    final result = await _client.fetch(programBySlugQuery, {'slug': slug});
    if (result == null) return null;
    return Program.fromJson(result as Map<String, dynamic>);
  }

  @override
  Future<List<StaffMember>> getStaffMembers() async {
    final result = await _client.fetch(staffMembersQuery);
    return (result as List<dynamic>)
        .map((item) => StaffMember.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<BoardMember>> getBoardMembers() async {
    final result = await _client.fetch(boardMembersQuery);
    return (result as List<dynamic>)
        .map((item) => BoardMember.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

/// Shared instance for pages to import directly — no DI container needed
/// for a static site with a single implementation.
const ContentRepository contentRepository = SanityContentRepository();
