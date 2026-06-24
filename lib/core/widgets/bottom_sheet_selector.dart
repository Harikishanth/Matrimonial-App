import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/onboarding/cubit/onboarding_cubit.dart';
import '../translation/option_translations.dart';
import 'notched_text_field.dart';
import '../theme/theme.dart';

class BottomSheetSelector extends StatefulWidget {
  final String labelText;
  final String? selectedValue;
  final List<String> options;
  final void Function(String) onSelected;
  final String searchPlaceholder;
  final Widget? suffixIcon;

  const BottomSheetSelector({
    Key? key,
    required this.labelText,
    required this.selectedValue,
    required this.options,
    required this.onSelected,
    this.searchPlaceholder = 'Search...',
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<BottomSheetSelector> createState() => _BottomSheetSelectorState();
}

class _BottomSheetSelectorState extends State<BottomSheetSelector> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showSelector(BuildContext context, String lang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: KalyaThiruTheme.softIvory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _BottomSheetContent(
            title: widget.labelText,
            options: widget.options,
            selectedValue: widget.selectedValue,
            searchPlaceholder: widget.searchPlaceholder,
            lang: lang,
            onSelected: (val) {
              widget.onSelected(val);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String lang = 'en';
    try {
      lang = context.watch<OnboardingCubit>().state.langCode;
    } catch (_) {}

    final newText = translateOption(widget.selectedValue, lang);
    if (_textController.text != newText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _textController.text = newText;
        }
      });
    }

    return NotchedTextField(
      labelText: widget.labelText,
      controller: _textController,
      readOnly: true,
      onTap: () => _showSelector(context, lang),
      suffixIcon: widget.suffixIcon ?? const Icon(
        Icons.keyboard_arrow_down,
        color: KalyaThiruTheme.mutedGray,
      ),
    );
  }
}

class _BottomSheetContent extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final String searchPlaceholder;
  final String lang;
  final void Function(String) onSelected;

  const _BottomSheetContent({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.searchPlaceholder,
    required this.lang,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  String _searchQuery = '';
  late List<String> _filteredOptions;

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
  }

  void _filterOptions(String query) {
    setState(() {
      _searchQuery = query;
      _filteredOptions = widget.options
          .where((opt) {
            final translated = translateOption(opt, widget.lang);
            return opt.toLowerCase().contains(query.toLowerCase()) ||
                translated.toLowerCase().contains(query.toLowerCase());
          })
          .toList();  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: KalyaThiruTheme.outlineBorder.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          // Search Input
          TextField(
            onChanged: _filterOptions,
            style: Theme.of(context).textTheme.bodyLarge,
            cursorColor: KalyaThiruTheme.primaryMaroon,
            decoration: InputDecoration(
              hintText: widget.searchPlaceholder,
              hintStyle: const TextStyle(color: KalyaThiruTheme.mutedGray),
              prefixIcon: const Icon(Icons.search, color: KalyaThiruTheme.mutedGray),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: KalyaThiruTheme.outlineBorder, width: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: KalyaThiruTheme.primaryMaroon, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Scrollable List
          Expanded(
            child: ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: _filteredOptions.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: KalyaThiruTheme.outlineVariant,
              ),
              itemBuilder: (context, index) {
                final String item = _filteredOptions[index];
                final bool isSelected = item == widget.selectedValue;
                final String displayLabel = translateOption(item, widget.lang);

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  title: Text(
                    displayLabel,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isSelected ? KalyaThiruTheme.primaryMaroon : null,
                          fontWeight: isSelected ? FontWeight.bold : null,
                        ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: KalyaThiruTheme.primaryMaroon)
                      : null,
                  onTap: () => widget.onSelected(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
