import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/features/qr_library/presentation/bloc/qr_library_bloc.dart';
import 'package:powerocr/features/qr_library/presentation/bloc/qr_library_event.dart';
import 'package:powerocr/features/qr_library/presentation/bloc/qr_library_state.dart';
import 'package:powerocr/l10n/app_localizations.dart';

class QrLibraryScreen extends StatefulWidget {
  const QrLibraryScreen({super.key});

  @override
  State<QrLibraryScreen> createState() => _QrLibraryScreenState();
}

class _QrLibraryScreenState extends State<QrLibraryScreen> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _onScroll(BuildContext context) {
    if (scrollController.position.pixels ==
        scrollController.position.minScrollExtent) {
      context.read<QrLibraryBloc>().add(LoadUserQrsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return BlocProvider<QrLibraryBloc>(
      create: (context) => QrLibraryBloc()..add(LoadUserQrsEvent()),
      child: BlocListener<QrLibraryBloc, QrLibraryState>(
        listener: (context, state) {
          scrollController.addListener(() => _onScroll(context));
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.homeTabQr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: BlocBuilder<QrLibraryBloc, QrLibraryState>(
            builder: (context, state) {
              if (state is QrLibraryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is QrLibraryError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              } else if (state is QrLibraryLoaded) {
                if (state.userQrs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.qrLibraryNoQrCodesSavedYet,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return CustomScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(14.0),
                      sliver: SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              mainAxisExtent: 250,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: state.userQrs.length,
                        itemBuilder: (context, index) {
                          final qr = state.userQrs[index];
                          final title = qr.title?.isNotEmpty == true
                              ? qr.title!
                              : l10n.untitledQr;

                          return Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                        ),
                                        child: Image.file(
                                          File(qr.imagePath),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(12.0),
                                        color: theme.cardColor,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Delete Button overlay
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Material(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: () =>
                                          _showDeleteDialog(context, qr.id),
                                      child: const Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.delete_outline,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String qrId) {
    // Capture the bloc before showing the dialog to avoid context issues
    final bloc = context.read<QrLibraryBloc>();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteQrCode),
          content: Text(l10n.deleteQrCodeConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.deleteQrCodeCancel),
            ),
            TextButton(
              onPressed: () {
                bloc.add(DeleteUserQrEvent(qrId));
                Navigator.pop(dialogContext);
              },
              child: Text(
                l10n.deleteQrCodeDelete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
