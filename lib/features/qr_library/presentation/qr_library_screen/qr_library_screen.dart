import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/qr_library/domain/entities/user_qr.dart';
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
  final ScrollController _scrollController = ScrollController();
  late final QrLibraryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = QrLibraryBloc()..add(LoadUserQrsEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return BlocProvider<QrLibraryBloc>.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            BlocBuilder<QrLibraryBloc, QrLibraryState>(
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
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      // Spacer so content starts below the custom appbar
                      SliverToBoxAdapter(
                        child: SizedBox(height: topPadding + 64),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 100),
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

                            return GestureDetector(
                              onTap: () => _onTapQrItem(context, qr),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
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
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
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
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: theme
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Delete Button overlay
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Material(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
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

            // ── Custom Opacity AppBar ─────────────────────────────────
            QrLibraryAppBar(
              bloc: _bloc,
              scrollController: _scrollController,
              theme: theme,
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }

  void _onTapQrItem(BuildContext context, UserQr qr) async {
    final result = await context.push<bool>(AppRouter.qrDetail, extra: qr);
    // result == true means user deleted the QR from detail screen
    if (result == true) {
      _bloc.add(LoadUserQrsEvent());
    }
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

class QrLibraryAppBar extends StatefulWidget {
  const QrLibraryAppBar({
    super.key,
    required this.bloc,
    required this.scrollController,
    required this.theme,
    required this.l10n,
  });
  final QrLibraryBloc bloc;
  final ScrollController scrollController;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  State<QrLibraryAppBar> createState() => _QrLibraryAppBarState();
}

class _QrLibraryAppBarState extends State<QrLibraryAppBar> {
  bool isLoading = false;
  double _appBarOpacity = 0;
  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final double offset = widget.scrollController.offset;

    if (offset < -150 && !isLoading) {
      isLoading = true;
      widget.bloc.add(LoadUserQrsEvent());
    } else if (offset >= 0) {
      isLoading = false;
    }

    double newOpacity = 0.1 + (offset / 10);
    newOpacity = newOpacity.clamp(0.1, 1.0);
    if (newOpacity != _appBarOpacity) {
      setState(() {
        _appBarOpacity = newOpacity;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Stack(
        children: [
          // Blur + tinted background — opacity driven by scroll
          Positioned.fill(
            child: Opacity(
              opacity: _appBarOpacity,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    color: widget.theme.scaffoldBackgroundColor.withValues(
                      alpha: 0.65,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // AppBar content
          SafeArea(
            bottom: false,
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.l10n.homeTabQr,
                      style: widget.theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
