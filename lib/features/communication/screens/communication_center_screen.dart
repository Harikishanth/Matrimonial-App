import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/translations.dart';
import '../../../core/translation/option_translations.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import 'chat_screen.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────

class MessageItem {
  final String name;
  final String photoUrl;
  final String lastMessage;     // preview text shown in the list
  final String time;
  final int unreadCount;
  final bool isViewed;           // true once the chat has been opened
  final bool isOnline;
  final bool hasReplied;         // true = you replied to this person
  final String lastSeen;         // shown inside the chat header

  const MessageItem({
    required this.name,
    required this.photoUrl,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isViewed = false,
    this.isOnline = false,
    this.hasReplied = false,
    this.lastSeen = 'Last seen a few hours ago',
  });

  /// Returns a copy with the chat marked as opened / read
  MessageItem markRead() => MessageItem(
        name: name,
        photoUrl: photoUrl,
        lastMessage: lastMessage,
        time: time,
        unreadCount: 0,
        isViewed: true,
        isOnline: isOnline,
        hasReplied: hasReplied,
        lastSeen: lastSeen,
      );
}

class CallItem {
  final String name;
  final String photoUrl;
  final String time;
  final bool isOutgoing;
  final bool isMissed;
  final bool isIncoming;

  const CallItem({
    required this.name,
    required this.photoUrl,
    required this.time,
    this.isOutgoing = false,
    this.isMissed = false,
    this.isIncoming = false,
  });
}

// ─── Sample Data ─────────────────────────────────────────────────────────────

class _SampleData {
  static List<MessageItem> receivedMessages = [
    MessageItem(
      name: 'Ananya Iyer',
      photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      lastMessage: 'Namaste, I read your profile and found it very appealing!',
      time: '10:45 AM',
      unreadCount: 3,
      isViewed: false,
      isOnline: true,
      hasReplied: false,
      lastSeen: 'Online now',
    ),
    MessageItem(
      name: 'Priyanka Rao',
      photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      lastMessage: "Thank you for accepting my interest. Let's connect soon!",
      time: 'Yesterday',
      unreadCount: 0,
      isViewed: true,
      hasReplied: true,
      lastSeen: 'Last seen yesterday',
    ),
    MessageItem(
      name: 'Deepika Sundar',
      photoUrl: 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=200',
      lastMessage: 'Are you planning to visit Chennai anytime soon?',
      time: '23 Oct',
      unreadCount: 0,
      isViewed: true,
      hasReplied: false,
      lastSeen: 'Last seen 2 days ago',
    ),
  ];

  static const List<MessageItem> awaitingResponse = [];

  static const List<CallItem> contactedByYou = [
    CallItem(
      name: 'Ananya Iyer',
      photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      time: 'Today, 11:30 AM',
      isOutgoing: true,
    ),
    CallItem(
      name: 'Sruthi Lakshmi',
      photoUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200',
      time: 'Yesterday, 6:15 PM',
      isMissed: true,
    ),
    CallItem(
      name: 'Priyanka Rao',
      photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      time: '24 Oct, 2:00 PM',
      isIncoming: true,
    ),
  ];

  static const List<CallItem> contactedYou = [
    CallItem(
      name: 'Kavitha Menon',
      photoUrl: 'https://images.unsplash.com/photo-1532170579297-281918c8ae72?w=200',
      time: 'Today, 9:15 AM',
      isIncoming: true,
    ),
    CallItem(
      name: 'Divya Krishnan',
      photoUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
      time: 'Yesterday, 3:30 PM',
      isMissed: true,
    ),
  ];
}

// ─── Main Screen ─────────────────────────────────────────────────────────────

class CommunicationCenterScreen extends StatefulWidget {
  final bool isPaidMember;

  const CommunicationCenterScreen({super.key, this.isPaidMember = false});

  @override
  State<CommunicationCenterScreen> createState() =>
      _CommunicationCenterScreenState();
}

class _CommunicationCenterScreenState extends State<CommunicationCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mutable copy of messages so mark-as-read works reactively
  late List<MessageItem> _messages;

  String get _lang => context.read<OnboardingCubit>().state.langCode;
  String _t(String key) => AppTranslations.translate(key, _lang);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _messages = List<MessageItem>.from(_SampleData.receivedMessages);
  }

  /// Called by _MessageCard after the user opens a chat
  void _markAsRead(int index) {
    if (!_messages[index].isViewed || _messages[index].unreadCount > 0) {
      setState(() {
        _messages[index] = _messages[index].markRead();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showUpgradeDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF9E6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone,
                  color: KalyaThiruTheme.primaryMaroon,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _t('comm_upgrade_title'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.primaryMaroon,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _t('comm_upgrade_desc'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: KalyaThiruTheme.mutedGray,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalyaThiruTheme.primaryMaroon,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _t('comm_upgrade_btn'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  _t('comm_maybe_later'),
                  style: TextStyle(color: KalyaThiruTheme.mutedGray),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<OnboardingCubit>().state.langCode;
    String t(String key) => AppTranslations.translate(key, lang);
    return Scaffold(
      backgroundColor: KalyaThiruTheme.softIvory,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: KalyaThiruTheme.darkCharcoal,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t('comm_title'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: KalyaThiruTheme.darkCharcoal,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: KalyaThiruTheme.darkCharcoal),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t('comm_search_coming'))),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: KalyaThiruTheme.darkCharcoal,
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: KalyaThiruTheme.primaryMaroon,
          indicatorWeight: 2.5,
          labelColor: KalyaThiruTheme.primaryMaroon,
          unselectedLabelColor: KalyaThiruTheme.mutedGray,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          tabs: [
            Tab(
              child: Text(
                t('comm_tab_messages'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                t('comm_tab_awaiting'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                t('comm_tab_calls'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MessagesReceivedTab(
            messages: _messages,
            isPaidMember: widget.isPaidMember,
            onUpgrade: _showUpgradeDialog,
            onMarkRead: _markAsRead,
            lang: lang,
          ),
          _AwaitingResponseTab(
            messages: _SampleData.awaitingResponse,
            lang: lang,
          ),
          _CallsTab(
            contactedByYou: _SampleData.contactedByYou,
            contactedYou: _SampleData.contactedYou,
            isPaidMember: widget.isPaidMember,
            onUpgrade: _showUpgradeDialog,
            lang: lang,
          ),
        ],
      ),
    );
  }
}

// ─── Assisted Service Banner ──────────────────────────────────────────────────

class _AssistedServiceBanner extends StatelessWidget {
  final String lang;
  const _AssistedServiceBanner({required this.lang});

  String _t(String key) => AppTranslations.translate(key, lang);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        border: Border.all(color: const Color(0xFFFFD54F)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFBF360C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_search,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t('comm_assisted_service'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: KalyaThiruTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _t('comm_assisted_desc'),
                  style: const TextStyle(
                    fontSize: 11,
                    color: KalyaThiruTheme.mutedGray,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFBA1A1A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              '2',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: KalyaThiruTheme.mutedGray),
        ],
      ),
    );
  }
}

// ─── Messages Received Tab ────────────────────────────────────────────────────

/// Filter enum for the Messages Received tab
enum _MsgFilter { none, unread, pending, replied }

class _MessagesReceivedTab extends StatefulWidget {
  final List<MessageItem> messages;
  final bool isPaidMember;
  final VoidCallback onUpgrade;
  final void Function(int index) onMarkRead;
  final String lang;

  const _MessagesReceivedTab({
    required this.messages,
    required this.isPaidMember,
    required this.onUpgrade,
    required this.onMarkRead,
    required this.lang,
  });

  @override
  State<_MessagesReceivedTab> createState() => _MessagesReceivedTabState();
}

class _MessagesReceivedTabState extends State<_MessagesReceivedTab> {
  _MsgFilter _activeFilter = _MsgFilter.none;
  bool _isSearchVisible = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _t(String key) => AppTranslations.translate(key, widget.lang);

  List<MessageItem> get _filtered {
    List<MessageItem> list;
    switch (_activeFilter) {
      case _MsgFilter.unread:
        list = widget.messages.where((m) => m.unreadCount > 0).toList();
        break;
      case _MsgFilter.pending:
        // pending = message received but you have NOT replied yet
        list = widget.messages.where((m) => !m.hasReplied).toList();
        break;
      case _MsgFilter.replied:
        list = widget.messages.where((m) => m.hasReplied).toList();
        break;
      case _MsgFilter.none:
        list = widget.messages;
        break;
    }
    if (_searchQuery.isNotEmpty) {
      list = list.where((m) {
        final nameEn = m.name.toLowerCase();
        final nameTa = translateOption(m.name, widget.lang).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return nameEn.contains(query) || nameTa.contains(query);
      }).toList();
    }
    return list;
  }

  void _showFilterSheet() {
    // capture current filter before opening the sheet
    _MsgFilter tempFilter = _activeFilter;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: KalyaThiruTheme.darkCharcoal,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // ── Unread ──────────────────────────────────────────
                  _FilterTile(
                    label: 'Unread',
                    subtitle: "Messages you haven't read yet",
                    isSelected: tempFilter == _MsgFilter.unread,
                    onTap: () => setSheetState(() {
                      tempFilter = tempFilter == _MsgFilter.unread
                          ? _MsgFilter.none
                          : _MsgFilter.unread;
                    }),
                  ),
                  // ── Pending ─────────────────────────────────────────
                  _FilterTile(
                    label: 'Pending',
                    subtitle: "Messages you haven't responded to yet",
                    isSelected: tempFilter == _MsgFilter.pending,
                    onTap: () => setSheetState(() {
                      tempFilter = tempFilter == _MsgFilter.pending
                          ? _MsgFilter.none
                          : _MsgFilter.pending;
                    }),
                  ),
                  // ── Replied ─────────────────────────────────────────
                  _FilterTile(
                    label: 'Replied',
                    subtitle: 'Messages you replied to / who replied in your message',
                    isSelected: tempFilter == _MsgFilter.replied,
                    onTap: () => setSheetState(() {
                      tempFilter = tempFilter == _MsgFilter.replied
                          ? _MsgFilter.none
                          : _MsgFilter.replied;
                    }),
                  ),
                  const SizedBox(height: 20),
                  // ── Action buttons ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setSheetState(() => tempFilter = _MsgFilter.none);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: KalyaThiruTheme.primaryMaroon,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: KalyaThiruTheme.primaryMaroon,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => _activeFilter = tempFilter);
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KalyaThiruTheme.primaryMaroon,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AssistedServiceBanner(lang: widget.lang),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_t('comm_incoming_messages')} (${filtered.length})',
                style: const TextStyle(
                  fontSize: 13,
                  color: KalyaThiruTheme.mutedGray,
                  height: 1.4,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _showFilterSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _activeFilter != _MsgFilter.none
                            ? KalyaThiruTheme.primaryMaroon.withValues(alpha: 0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: _activeFilter != _MsgFilter.none
                              ? KalyaThiruTheme.primaryMaroon
                              : KalyaThiruTheme.outlineBorder,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            size: 14,
                            color: _activeFilter != _MsgFilter.none
                                ? KalyaThiruTheme.primaryMaroon
                                : KalyaThiruTheme.mutedGray,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _activeFilter != _MsgFilter.none
                                ? _filterLabel(_activeFilter)
                                : _t('comm_filter'),
                            style: TextStyle(
                              fontSize: 12,
                              color: _activeFilter != _MsgFilter.none
                                  ? KalyaThiruTheme.primaryMaroon
                                  : KalyaThiruTheme.mutedGray,
                              fontWeight: _activeFilter != _MsgFilter.none
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearchVisible = !_isSearchVisible;
                        if (!_isSearchVisible) {
                          _searchQuery = '';
                          _searchController.clear();
                        }
                      });
                    },
                    child: Icon(
                      Icons.search,
                      size: 20,
                      color: _isSearchVisible
                          ? KalyaThiruTheme.primaryMaroon
                          : KalyaThiruTheme.mutedGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_isSearchVisible)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search chats by name...',
                prefixIcon: const Icon(Icons.search, size: 20, color: KalyaThiruTheme.mutedGray),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20, color: KalyaThiruTheme.mutedGray),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: KalyaThiruTheme.primaryMaroon, width: 1),
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mark_email_read_outlined,
                        size: 56,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _activeFilter == _MsgFilter.unread
                            ? 'No unread messages'
                            : _activeFilter == _MsgFilter.pending
                                ? 'No pending messages'
                                : 'No replied messages',
                        style: const TextStyle(
                          fontSize: 15,
                          color: KalyaThiruTheme.mutedGray,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 74),
                  itemBuilder: (context, i) {
                    final msg = filtered[i];
                    // find the original index in the full list for markAsRead
                    final origIndex = widget.messages.indexOf(msg);
                    return _MessageCard(
                      message: msg,
                      isPaidMember: widget.isPaidMember,
                      onUpgrade: widget.onUpgrade,
                      onMarkRead: origIndex >= 0
                          ? () => widget.onMarkRead(origIndex)
                          : () {},
                      lang: widget.lang,
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _filterLabel(_MsgFilter f) {
    switch (f) {
      case _MsgFilter.unread:  return 'Unread';
      case _MsgFilter.pending: return 'Pending';
      case _MsgFilter.replied: return 'Replied';
      case _MsgFilter.none:    return '';
    }
  }
}

// ─── Filter Tile (reusable checkbox row) ──────────────────────────────────────

class _FilterTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTile({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: KalyaThiruTheme.darkCharcoal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: KalyaThiruTheme.mutedGray,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (_) => onTap(),
              activeColor: KalyaThiruTheme.primaryMaroon,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Message Card ─────────────────────────────────────────────────────────────

class _MessageCard extends StatelessWidget {
  final MessageItem message;
  final bool isPaidMember;
  final VoidCallback onUpgrade;
  final VoidCallback onMarkRead;   // ← called after chat is opened
  final String lang;

  const _MessageCard({
    required this.message,
    required this.isPaidMember,
    required this.onUpgrade,
    required this.onMarkRead,
    required this.lang,
  });

  String _t(String key) => AppTranslations.translate(key, lang);

  void _showOptions(BuildContext context) {
    final List<Map<String, Object>> options = [
      {
        'icon': Icons.bookmark_border,
        'label': _t('comm_shortlist'),
        'color': KalyaThiruTheme.primaryMaroon,
      },
      {
        'icon': Icons.share_outlined,
        'label': _t('comm_share'),
        'color': KalyaThiruTheme.primaryMaroon,
      },
      {
        'icon': Icons.delete_outline,
        'label': _t('comm_delete'),
        'color': Colors.red,
      },
      {
        'icon': Icons.flag_outlined,
        'label': _t('comm_report'),
        'color': Colors.orange,
      },
      {
        'icon': Icons.block,
        'label': _t('comm_block'),
        'color': Colors.red,
      },
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ...options.map(
              (opt) => ListTile(
                leading: Icon(
                  opt['icon'] as IconData,
                  color: opt['color'] as Color,
                ),
                title: Text(
                  opt['label'] as String,
                  style: TextStyle(
                    color: opt['color'] as Color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${opt['label']} selected'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Mark this conversation as read before opening
        onMarkRead();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              personName: translateOption(message.name, lang),
              personPhotoUrl: message.photoUrl,
              isPaidMember: isPaidMember,
              isOnline: message.isOnline,
              lastSeen: message.lastSeen,
              initialMessages: message.unreadCount > 0
                  ? [
                      // The actual messages from this chat — match what's
                      // shown in the preview so content is consistent.
                      ChatMessage(
                        text: message.lastMessage,
                        isSentByMe: false,
                        time: message.time,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(message.photoUrl),
                ),
                if (message.isOnline)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Name + preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          translateOption(message.name, lang),
                          style: TextStyle(
                            fontWeight: message.isViewed
                                ? FontWeight.w600
                                : FontWeight.bold,
                            fontSize: 14,
                            color: KalyaThiruTheme.darkCharcoal,
                          ),
                        ),
                      ),
                      Text(
                        message.time,
                        style: TextStyle(
                          fontSize: 11,
                          color: message.unreadCount > 0
                              ? KalyaThiruTheme.primaryMaroon
                              : KalyaThiruTheme.mutedGray,
                          fontWeight: message.unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message.lastMessage,
                          style: TextStyle(
                            fontSize: 12,
                            color: message.isViewed
                                ? KalyaThiruTheme.mutedGray
                                : KalyaThiruTheme.darkCharcoal,
                            fontWeight: message.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (message.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: KalyaThiruTheme.primaryMaroon,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${message.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Phone + three-dot
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: isPaidMember
                       ? () {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                               content: Text('${_t('comm_calling')} ${translateOption(message.name, lang)}...'),
                             ),
                           );
                        }
                      : onUpgrade,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isPaidMember
                          ? const Color(0xFFF5F5F5)
                          : const Color(0xFFFDE8E9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.phone,
                      size: 18,
                      color: isPaidMember
                          ? KalyaThiruTheme.mutedGray
                          : KalyaThiruTheme.primaryMaroon,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _showOptions(context),
                  child: const Icon(
                    Icons.more_vert,
                    size: 20,
                    color: KalyaThiruTheme.mutedGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Awaiting Response Tab ────────────────────────────────────────────────────

class _AwaitingResponseTab extends StatelessWidget {
  final List<MessageItem> messages;
  final String lang;

  const _AwaitingResponseTab({required this.messages, required this.lang});

  String _t(String key) => AppTranslations.translate(key, lang);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AssistedServiceBanner(lang: lang),
        if (messages.isEmpty)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1545558014-8692077e9b5c?w=300',
                    width: 200,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 200,
                      height: 180,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _t('comm_no_pending'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: KalyaThiruTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _t('comm_no_pending_desc'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: KalyaThiruTheme.mutedGray,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: messages.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 74),
              itemBuilder: (context, i) {
                return _MessageCard(
                  message: messages[i],
                  isPaidMember: true,
                  onUpgrade: () {},
                  onMarkRead: () {},
                  lang: lang,
                );
              },
            ),
          ),
      ],
    );
  }
}

// ─── Calls Tab ────────────────────────────────────────────────────────────────

class _CallsTab extends StatefulWidget {
  final List<CallItem> contactedByYou;
  final List<CallItem> contactedYou;
  final bool isPaidMember;
  final VoidCallback onUpgrade;
  final String lang;

  const _CallsTab({
    required this.contactedByYou,
    required this.contactedYou,
    required this.isPaidMember,
    required this.onUpgrade,
    required this.lang,
  });

  @override
  State<_CallsTab> createState() => _CallsTabState();
}

class _CallsTabState extends State<_CallsTab> {
  bool _showContactedByYou = true;

  String _t(String key) => AppTranslations.translate(key, widget.lang);

  @override
  Widget build(BuildContext context) {
    final calls =
        _showContactedByYou ? widget.contactedByYou : widget.contactedYou;

    return Column(
      children: [
        _AssistedServiceBanner(lang: widget.lang),
        const SizedBox(height: 12),
        // Toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showContactedByYou = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _showContactedByYou
                          ? KalyaThiruTheme.primaryMaroon
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      border: Border.all(
                        color: KalyaThiruTheme.primaryMaroon,
                      ),
                    ),
                    child: Text(
                      _t('comm_contacted_by_you'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _showContactedByYou
                            ? Colors.white
                            : KalyaThiruTheme.primaryMaroon,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showContactedByYou = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: !_showContactedByYou
                          ? KalyaThiruTheme.primaryMaroon
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      border: Border.all(
                        color: KalyaThiruTheme.primaryMaroon,
                      ),
                    ),
                    child: Text(
                      _t('comm_contacted_you'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: !_showContactedByYou
                            ? Colors.white
                            : KalyaThiruTheme.primaryMaroon,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: calls.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.phone_missed,
                        size: 56,
                        color: KalyaThiruTheme.mutedGray,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _t('comm_no_call_history'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: KalyaThiruTheme.mutedGray,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: calls.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 74),
                  itemBuilder: (context, i) {
                    return _CallCard(
                      call: calls[i],
                      isPaidMember: widget.isPaidMember,
                      onUpgrade: widget.onUpgrade,
                      lang: widget.lang,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ─── Call Card ────────────────────────────────────────────────────────────────

class _CallCard extends StatelessWidget {
  final CallItem call;
  final bool isPaidMember;
  final VoidCallback onUpgrade;
  final String lang;

  const _CallCard({
    required this.call,
    required this.isPaidMember,
    required this.onUpgrade,
    required this.lang,
  });

  String _t(String key) => AppTranslations.translate(key, lang);

  @override
  Widget build(BuildContext context) {
    final Color arrowColor;
    final IconData arrowIcon;
    final String callTypeLabel;

    if (call.isOutgoing) {
      arrowColor = KalyaThiruTheme.primaryMaroon;
      arrowIcon = Icons.call_made;
      callTypeLabel = _t('comm_call_outgoing');
    } else if (call.isMissed) {
      arrowColor = Colors.red;
      arrowIcon = Icons.call_missed;
      callTypeLabel = _t('comm_call_missed');
    } else {
      arrowColor = Colors.green;
      arrowIcon = Icons.call_received;
      callTypeLabel = _t('comm_call_incoming');
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Direction indicator
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: arrowColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(arrowIcon, color: arrowColor, size: 18),
          ),
          const SizedBox(width: 12),
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(call.photoUrl),
          ),
          const SizedBox(width: 12),
          // Name and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translateOption(call.name, lang),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: KalyaThiruTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      '$callTypeLabel • ',
                      style: TextStyle(
                        fontSize: 11,
                        color: arrowColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        call.time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: KalyaThiruTheme.mutedGray,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Call-back button
          GestureDetector(
            onTap: isPaidMember
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${_t('comm_calling')} ${translateOption(call.name, lang)}...'),
                      ),
                    );
                  }
                : onUpgrade,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isPaidMember
                    ? const Color(0xFFF5F5F5)
                    : const Color(0xFFFDE8E9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone,
                size: 20,
                color: isPaidMember
                    ? KalyaThiruTheme.mutedGray
                    : KalyaThiruTheme.primaryMaroon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
