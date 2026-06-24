import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/onboarding/cubit/onboarding_cubit.dart';
import '../translation/option_translations.dart';
import '../theme/theme.dart';

class SubInterestSheet extends StatefulWidget {
  final String title;
  final String tamilTitle;
  final List<String> availableGenres;
  final List<String> selectedGenres;
  final void Function(List<String>) onSaved;

  const SubInterestSheet({
    Key? key,
    required this.title,
    required this.tamilTitle,
    required this.availableGenres,
    required this.selectedGenres,
    required this.onSaved,
  }) : super(key: key);

  @override
  State<SubInterestSheet> createState() => _SubInterestSheetState();
}

class _SubInterestSheetState extends State<SubInterestSheet> {
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedGenres);
  }

  @override
  Widget build(BuildContext context) {
    String lang = 'en';
    try {
      lang = context.read<OnboardingCubit>().state.langCode;
    } catch (_) {}

    final displayTitle = lang == 'ta' 
        ? 'விவரம்: ${widget.tamilTitle}' 
        : widget.title;

    return Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
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
            displayTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (lang != 'ta') ...[
            const SizedBox(width: 4),
            Text(
              '(${widget.tamilTitle})',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KalyaThiruTheme.mutedGray,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
          const SizedBox(height: 16),
          // Checkboxes list
          Expanded(
            child: ListView.builder(
              itemCount: widget.availableGenres.length,
              itemBuilder: (context, index) {
                final genre = widget.availableGenres[index];
                final isChecked = _tempSelected.contains(genre);

                return CheckboxListTile(
                  title: Text(
                    translateOption(genre, lang),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  activeColor: KalyaThiruTheme.primaryMaroon,
                  checkColor: Colors.white,
                  value: isChecked,
                  onChanged: (bool? checked) {
                    setState(() {
                      if (checked == true) {
                        _tempSelected.add(genre);
                      } else {
                        _tempSelected.remove(genre);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Save Button
          ElevatedButton(
            onPressed: () {
              widget.onSaved(_tempSelected);
              Navigator.pop(context);
            },
            child: Text(lang == 'ta' ? 'தேர்வை சேமிக்கவும்' : 'Save Selection'),
          ),
        ],
      ),
    );
  }
}
