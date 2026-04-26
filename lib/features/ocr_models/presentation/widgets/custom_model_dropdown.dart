import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/features/ocr_models/domain/entities/ocr_model.dart';
import 'package:powerocr/features/ocr_models/presentation/bloc/ocr_model_cubit.dart';

class CustomModelDropdown extends StatefulWidget {
  const CustomModelDropdown({super.key});

  @override
  State<CustomModelDropdown> createState() => _CustomModelDropdownState();
}

class _CustomModelDropdownState extends State<CustomModelDropdown>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  AnimationController? _animController;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _animController?.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animController?.forward(from: 0);
    setState(() => _isOpen = true);
  }

  void _removeOverlay() {
    _animController?.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
    if (_overlayEntry != null && !(_animController?.isAnimating ?? false)) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    setState(() => _isOpen = false);
  }

  OverlayEntry _buildOverlayEntry() {
    const double itemHeight = 58;
    const int maxVisible = 4;
    final state = context.read<OcrModelCubit>().state;
    final models = state.ocrModels;
    final itemCount = models.length;
    final listHeight =
        itemHeight * (itemCount > maxVisible ? maxVisible : itemCount);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            // Backdrop — tap to dismiss
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _removeOverlay,
                child: const SizedBox.expand(),
              ),
            ),
            // Dropdown panel
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.topRight,
              followerAnchor: Alignment.bottomRight,
              offset: const Offset(0, -8),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _animController!,
                  curve: Curves.easeOutCubic,
                ),
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, 0.08),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _animController!,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                  child: _GlassDropdownPanel(
                    models: models,
                    selectedModel: state.selectedModel,
                    listHeight: listHeight,
                    isDark: isDark,
                    theme: theme,
                    onSelect: (model) {
                      context.read<OcrModelCubit>().selectModel(model);
                      _removeOverlay();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<OcrModelCubit, OcrModelState>(
      buildWhen: (previous, current) =>
          previous.ocrModels != current.ocrModels ||
          previous.selectedModel != current.selectedModel,
      builder: (context, state) {
        final selectedModel = state.selectedModel;

        final displayLabel = selectedModel != null
            ? 'OCRv4-${selectedModel.language}'
            : 'Model';

        return CompositedTransformTarget(
          link: _layerLink,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: state.ocrModels.isNotEmpty ? _toggleOverlay : null,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: selectedModel != null
                      ? Center(
                          child: Text(
                            selectedModel.language
                                .substring(0, 2)
                                .toUpperCase(),
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.translate_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                displayLabel,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Glass Dropdown Panel ─────────────────────────────────────────────
class _GlassDropdownPanel extends StatelessWidget {
  final List<OcrModel> models;
  final OcrModel? selectedModel;
  final double listHeight;
  final bool isDark;
  final ThemeData theme;
  final ValueChanged<OcrModel> onSelect;

  const _GlassDropdownPanel({
    required this.models,
    required this.selectedModel,
    required this.listHeight,
    required this.isDark,
    required this.theme,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: Container(
          width: 220,
          constraints: BoxConstraints(maxHeight: listHeight + 16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.55)
                : Colors.white.withOpacity(0.78),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.12)
                  : Colors.black.withOpacity(0.08),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ScrollConfiguration(
              behavior: const _NoGlowScrollBehavior(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: models.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final model = models[index];
                  final selected = _isSelected(model, selectedModel);
                  return _ModelItem(
                    model: model,
                    isSelected: selected,
                    isDark: isDark,
                    theme: theme,
                    onTap: () => onSelect(model),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isSelected(OcrModel model, OcrModel? selectedModel) {
    if (selectedModel == null) return false;
    return model.model == selectedModel.model &&
        model.language == selectedModel.language;
  }
}

// ── Single Model Item ────────────────────────────────────────────────
class _ModelItem extends StatelessWidget {
  final OcrModel model;
  final bool isSelected;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onTap;

  const _ModelItem({
    required this.model,
    required this.isSelected,
    required this.isDark,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: theme.colorScheme.primary.withOpacity(0.08),
        highlightColor: theme.colorScheme.primary.withOpacity(0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(isDark ? 0.12 : 0.06)
              : Colors.transparent,
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withOpacity(0.15)
                      : (isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.04)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    model.language.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model.languageName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      model.language,
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Remove overscroll glow ───────────────────────────────────────────
class _NoGlowScrollBehavior extends ScrollBehavior {
  const _NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
