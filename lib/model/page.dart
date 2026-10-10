import 'payload/payload.dart';
import 'payload/sample.dart';

/// Equivalent of [Page]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One page of read samples, `{"items": [...], "nextPageToken": "..."}`.
///
/// Supports [map] representation.
///
/// Has a [Page.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class Page with Payload {
  const Page({
    required this.items,
    this.nextPageToken,
  });

  /// The samples of this page
  final List<Sample> items;

  /// Pass to the next read to get the next page; null on the last page
  final String? nextPageToken;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'items': items.map((e) => e.map).toList(),
        'nextPageToken': nextPageToken,
      };

  /// General constructor from JSON payload.
  /// Throws an [InvalidValueException] for an item of an unknown type.
  ///
  Page.fromJson(Map<String, dynamic> json)
      : items = Sample.collect(json['items'] ?? const []),
        nextPageToken = json['nextPageToken'];
}
