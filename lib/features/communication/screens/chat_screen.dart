import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

class ChatMessage {
  final String text;
  final bool isSentByMe;
  final String time;
  final bool isRead;

  const ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.time,
    this.isRead = false,
  });
}

// ─── Widget ──────────────────────────────────────────────────────────────────

class ChatScreen extends StatefulWidget {
  final String personName;
  final String? personPhotoUrl;
  final bool isPaidMember;
  final bool isOnline;
  final String lastSeen;
  final List<ChatMessage>? initialMessages;  // ← injected from the message card

  const ChatScreen({
    super.key,
    required this.personName,
    this.personPhotoUrl,
    this.isPaidMember = false,
    this.isOnline = false,
    this.lastSeen = 'Last seen a few hours ago',
    this.initialMessages,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    // Use injected messages if provided; otherwise fall back to sample data
    if (widget.initialMessages != null && widget.initialMessages!.isNotEmpty) {
      _messages = List<ChatMessage>.from(widget.initialMessages!);
    } else {
      _messages = [
        const ChatMessage(
          text: 'assalamu alaikum',
          isSentByMe: false,
          time: '02:49 PM',
        ),
        const ChatMessage(
          text: 'mobile number pls',
          isSentByMe: false,
          time: '02:52 PM',
        ),
        const ChatMessage(
          text: 'assalamu alaikum',
          isSentByMe: true,
          time: '11:07 AM',
          isRead: true,
        ),
      ];
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
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
              const Text(
                'Upgrade to Call',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.primaryMaroon,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Phone calls are available for paid members only. '
                'Upgrade now to connect directly with your matches.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: KalyaThiruTheme.mutedGray,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/upgrade');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalyaThiruTheme.primaryMaroon,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'UPGRADE NOW',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Maybe Later',
                  style: TextStyle(color: KalyaThiruTheme.mutedGray),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _buildChatOptionsSheet(ctx),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isSentByMe: true,
        time: TimeOfDay.now().format(context),
      ));
      _messageController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: KalyaThiruTheme.darkCharcoal,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.personPhotoUrl != null
                      ? NetworkImage(widget.personPhotoUrl!)
                      : const NetworkImage(
                          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
                        ),
                  backgroundColor: Colors.grey,
                ),
                if (widget.isOnline)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.personName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: KalyaThiruTheme.darkCharcoal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.blue, size: 14),
                    ],
                  ),
                  Text(
                    widget.lastSeen,
                    style: const TextStyle(
                      fontSize: 11,
                      color: KalyaThiruTheme.mutedGray,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.phone,
              color: KalyaThiruTheme.darkCharcoal,
              size: 22,
            ),
            onPressed: widget.isPaidMember
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling...')),
                    );
                  }
                : _showUpgradeDialog,
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: KalyaThiruTheme.darkCharcoal,
              size: 22,
            ),
            onPressed: _showChatOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Message list ──────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _messages.length + 1, // +1 for the date separator
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Column(
                    children: [
                      _buildDateSeparator('Today'),
                      const SizedBox(height: 8),
                    ],
                  );
                }
                final msg = _messages[i - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: msg.isSentByMe
                      ? _buildSentBubble(msg)
                      : _buildReceivedBubble(msg),
                );
              },
            ),
          ),
          // ── Input bar ─────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(fontSize: 14),
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.emoji_emotions_outlined,
                              color: KalyaThiruTheme.mutedGray,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: KalyaThiruTheme.primaryMaroon,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _buildDateSeparator(String date) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          date,
          style: const TextStyle(
            fontSize: 11,
            color: KalyaThiruTheme.mutedGray,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildReceivedBubble(ChatMessage msg) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: widget.personPhotoUrl != null
                ? NetworkImage(widget.personPhotoUrl!)
                : const NetworkImage(
                    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
                  ),
          ),
          const SizedBox(width: 6),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: KalyaThiruTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  msg.time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: KalyaThiruTheme.mutedGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentBubble(ChatMessage msg) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: KalyaThiruTheme.primaryMaroon,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              msg.text,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.time,
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
                const SizedBox(width: 4),
                Icon(
                  msg.isRead ? Icons.done_all : Icons.done,
                  size: 12,
                  color: msg.isRead
                      ? const Color(0xFF90CAF9) // blue[200] constant
                      : Colors.white70,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatOptionsSheet(BuildContext sheetContext) {
    final List<Map<String, Object>> options = [
      {
        'icon': Icons.bookmark_border,
        'label': 'Shortlist Profile',
        'color': KalyaThiruTheme.primaryMaroon,
      },
      {
        'icon': Icons.share_outlined,
        'label': 'Share Profile',
        'color': KalyaThiruTheme.primaryMaroon,
      },
      {
        'icon': Icons.delete_outline,
        'label': 'Delete Conversation',
        'color': Colors.red,
      },
      {
        'icon': Icons.flag_outlined,
        'label': 'Report Profile',
        'color': Colors.orange,
      },
      {
        'icon': Icons.block,
        'label': 'Block Profile',
        'color': Colors.red,
      },
    ];

    return Container(
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
                Navigator.pop(sheetContext);
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
    );
  }
}
