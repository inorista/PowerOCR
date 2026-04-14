import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:powerocr/features/generate_qr/presentation/bloc/generate_qr_bloc.dart';
import 'package:powerocr/features/generate_qr/presentation/bloc/generate_qr_event.dart';
import 'package:powerocr/features/generate_qr/presentation/bloc/generate_qr_state.dart';
import 'package:powerocr/features/generate_qr/presentation/screens/widgets/qr_preview_card.dart';
import 'package:powerocr/features/generate_qr/presentation/screens/widgets/qr_style_options.dart';

class GenerateQrScreen extends StatelessWidget {
  const GenerateQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenerateQrBloc(),
      child: const _GenerateQrScreenView(),
    );
  }
}

class _GenerateQrScreenView extends StatefulWidget {
  const _GenerateQrScreenView();

  @override
  State<_GenerateQrScreenView> createState() => _GenerateQrScreenViewState();
}

class _GenerateQrScreenViewState extends State<_GenerateQrScreenView> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _shareQrCode(GenerateQrState state) async {
    if (state.qrData.trim().isEmpty) return;

    final bloc = context.read<GenerateQrBloc>();
    bloc.add(const QrShareStatusChanged(true));

    try {
      final boundary =
          _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        final tempDir = await getApplicationDocumentsDirectory();
        final file = await File(
          '${tempDir.path}/custom_qr/qr_code_${DateTime.now().millisecondsSinceEpoch}.png',
        ).create(recursive: true);
        await file.writeAsBytes(pngBytes);

        if (mounted) {
          final box = context.findRenderObject() as RenderBox?;
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(file.path)],
              text: 'Mã QR của tôi',
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi chia sẻ QR: $e')));
      }
    } finally {
      if (mounted) {
        bloc.add(const QrShareStatusChanged(false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Tạo mã QR',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocBuilder<GenerateQrBloc, GenerateQrState>(
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 40),
                      child: Column(
                        children: [
                          Center(
                            child: QrPreviewCard(
                              boundaryKey: _qrKey,
                              data: state.qrData,
                              foregroundColor: state.selectedColor,
                              isDarkBackground: state.isDarkBackground,
                              eyeShape: state.eyeShape,
                              dataModuleShape: state.dataShape,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Input Field
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: _textController,
                              onChanged: (val) {
                                context.read<GenerateQrBloc>().add(
                                  QrDataChanged(val),
                                );
                              },
                              maxLines: 1,
                              minLines: 1,
                              decoration: InputDecoration(
                                hintText:
                                    'Nhập văn bản, link, số điện thoại...',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.3),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF1A1A26)
                                    : const Color(0xFFF5F6FA),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(14),
                                prefixIcon: Icon(
                                  Icons.text_fields_rounded,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          QrStyleOptions(
                            selectedColor: state.selectedColor,
                            onColorChanged: (c) => context
                                .read<GenerateQrBloc>()
                                .add(QrColorChanged(c)),
                            selectedEyeShape: state.eyeShape,
                            onEyeShapeChanged: (s) => context
                                .read<GenerateQrBloc>()
                                .add(QrEyeShapeChanged(s)),
                            selectedDataShape: state.dataShape,
                            onDataShapeChanged: (s) => context
                                .read<GenerateQrBloc>()
                                .add(QrDataShapeChanged(s)),
                            isDarkBackground: state.isDarkBackground,
                            onBackgroundChanged: (b) => context
                                .read<GenerateQrBloc>()
                                .add(QrBackgroundChanged(b)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: state.qrData.trim().isEmpty || state.isSharing
                          ? null
                          : () => _shareQrCode(state),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: state.isSharing
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              spacing: 8.0,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.share_rounded, size: 20),
                                Text(
                                  'Chia sẻ mã QR',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
