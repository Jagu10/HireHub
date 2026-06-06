import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/job_model.dart';

class JobDetailScreen extends StatelessWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

  Future<void> _launchUrl(BuildContext context) async {
    final uri = Uri.parse(job.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the job link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          // Custom AppBar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFF6C63FF),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 16),
              ),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF43A896)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            job.companyName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          job.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location chip
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      _infoChip(
                        Icons.location_on_outlined,
                        job.location.isNotEmpty ? job.location : 'Remote',
                        const Color(0xFF6C63FF),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Description card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: Color(0xFF6C63FF),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Job Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _HtmlText(html: job.description.isNotEmpty
                          ? job.description
                          : '<p>No description available.</p>'),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      // Apply Now FAB
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () => _launchUrl(context),
          icon: const Icon(Icons.open_in_new_rounded, size: 18),
          label: const Text(
            'Apply Now',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            elevation: 6,
            shadowColor: const Color(0xFF6C63FF).withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _HtmlText extends StatelessWidget {
  final String html;
  const _HtmlText({required this.html});

  @override
  Widget build(BuildContext context) {
    final blocks = _parseBlocks(html);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map(_buildBlock).toList(),
    );
  }

  Widget _buildBlock(_Block block) {
    switch (block.type) {
      case _Type.heading:
        final sizes = [24.0, 20.0, 18.0, 16.0, 15.0, 14.0];
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Text(
            block.text,
            style: TextStyle(
              fontSize: sizes[(block.level - 1).clamp(0, 5)],
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        );
      case _Type.listItem:
        return Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 7, right: 8),
                child: CircleAvatar(
                  radius: 3,
                  backgroundColor: Color(0xFF6C63FF),
                ),
              ),
              Expanded(child: _inlineText(block.text)),
            ],
          ),
        );
      default:
        if (block.text.trim().isEmpty) return const SizedBox(height: 4);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _inlineText(block.text),
        );
    }
  }

  Widget _inlineText(String text) {
    return Text.rich(
      _parseInline(text),
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF444466),
        height: 1.6,
      ),
    );
  }

  TextSpan _parseInline(String text) {
    final spans = <TextSpan>[];
    final re = RegExp(r'<(strong|b|em|i)>(.*?)<\/\1>',
        caseSensitive: false, dotAll: true);
    int cursor = 0;
    for (final m in re.allMatches(text)) {
      if (m.start > cursor) {
        spans.add(TextSpan(text: _strip(text.substring(cursor, m.start))));
      }
      final tag = m.group(1)!.toLowerCase();
      spans.add(TextSpan(
        text: _strip(m.group(2) ?? ''),
        style: TextStyle(
          fontWeight:
          (tag == 'strong' || tag == 'b') ? FontWeight.w700 : null,
          fontStyle:
          (tag == 'em' || tag == 'i') ? FontStyle.italic : null,
          color: (tag == 'strong' || tag == 'b')
              ? const Color(0xFF1A1A2E)
              : null,
        ),
      ));
      cursor = m.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: _strip(text.substring(cursor))));
    }
    return TextSpan(children: spans);
  }

  List<_Block> _parseBlocks(String raw) {
    var h = raw
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    final blocks = <_Block>[];

    // headings
    h = h.replaceAllMapped(
      RegExp(r'<h([1-6])[^>]*>(.*?)<\/h[1-6]>',
          caseSensitive: false, dotAll: true),
          (m) {
        blocks.add(_Block(
            type: _Type.heading,
            level: int.parse(m.group(1)!),
            text: _strip(m.group(2)!)));
        return '\x00B${blocks.length - 1}\x00';
      },
    );

    // list items
    h = h.replaceAllMapped(
      RegExp(r'<li[^>]*>(.*?)<\/li>', caseSensitive: false, dotAll: true),
          (m) {
        blocks.add(
            _Block(type: _Type.listItem, text: _strip(m.group(1)!)));
        return '\x00B${blocks.length - 1}\x00';
      },
    );

    // strip ul/ol tags
    h = h.replaceAll(
        RegExp(r'<\/?(ul|ol)[^>]*>', caseSensitive: false), '');

    // paragraphs
    h = h.replaceAllMapped(
      RegExp(r'<p[^>]*>(.*?)<\/p>', caseSensitive: false, dotAll: true),
          (m) {
        blocks.add(_Block(type: _Type.paragraph, text: m.group(1)!));
        return '\x00B${blocks.length - 1}\x00';
      },
    );

    final result = <_Block>[];
    for (final part in h.split('\x00')) {
      final bm = RegExp(r'^B(\d+)$').firstMatch(part.trim());
      if (bm != null) {
        result.add(blocks[int.parse(bm.group(1)!)]);
      } else {
        for (final para in part.split(RegExp(r'\n{2,}'))) {
          final clean = _strip(para).trim();
          if (clean.isNotEmpty) {
            result.add(_Block(type: _Type.paragraph, text: clean));
          }
        }
      }
    }

    return result.isEmpty
        ? [_Block(type: _Type.paragraph, text: _strip(raw))]
        : result;
  }

  String _strip(String s) => s
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .trim();
}

enum _Type { paragraph, heading, listItem }

class _Block {
  final _Type type;
  final String text;
  final int level;
  _Block({required this.type, required this.text, this.level = 1});
}