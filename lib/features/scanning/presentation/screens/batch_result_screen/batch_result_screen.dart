import 'dart:io';
import 'package:flutter/material.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/services/interfaces/ipdf_service.dart';

class BatchResultScreen extends StatefulWidget {
  final List<String> imagePaths;
  const BatchResultScreen({super.key, required this.imagePaths});

  @override
  State<BatchResultScreen> createState() => _BatchResultScreenState();
}

class _BatchResultScreenState extends State<BatchResultScreen> {
  bool _isExporting = false;

  Future<void> _exportToPdf() async {
    setState(() => _isExporting = true);
    try {
      await locator<IPdfService>().exportToPdf(widget.imagePaths);
    } catch (e) {
      debugPrint('Export PDF Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to export PDF: $e')));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('${widget.imagePaths.length} Scanned Pages'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            onPressed: _isExporting ? null : _exportToPdf,
          ),
        ],
      ),
      body: _isExporting
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: widget.imagePaths.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(widget.imagePaths[index]),
                        fit: BoxFit.cover,
                        cacheHeight: 350,
                        cacheWidth: 250,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton.icon(
            onPressed: _isExporting ? null : _exportToPdf,
            icon: const Icon(Icons.share_rounded),
            label: const Text('Export & Share PDF'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
