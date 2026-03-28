class NearMissSection {
  final String title;
  final String body;
  final List<String> bullets;

  const NearMissSection({
    required this.title,
    required this.body,
    required this.bullets,
  });
}

class NearMissEducationService {
  static const List<NearMissSection> sections = [
    NearMissSection(
      title: 'What a near miss really is',
      body:
          'A near miss is an almost-win moment that still ends in a loss. On a scratch-off, that can feel like being close, even though no real progress happened.',
      bullets: [
        'One symbol away is still not a payout.',
        'Almost matching is still money spent without a return.',
        'The ticket can feel exciting without actually helping you.',
      ],
    ),
    NearMissSection(
      title: 'Why it can feel so powerful',
      body:
          'An almost-win can create tension, urgency, and the feeling that another ticket might finish the story. That feeling can be strong even when the last ticket already lost.',
      bullets: [
        'The brain can react to “almost” like something important just happened.',
        'That can create the thought: I was close.',
        'That thought can make another ticket feel justified.',
      ],
    ),
    NearMissSection(
      title: 'Why it can cost more',
      body:
          'Near misses can make the loss feel recoverable, which can pull someone into buying again quickly.',
      bullets: [
        'A near miss can trigger “just one more.”',
        'It can make the next ticket feel special when it is still just another ticket.',
        'That is how a small stop can turn into a bigger spiral.',
      ],
    ),
    NearMissSection(
      title: 'What to say back to it',
      body:
          'The goal is not to argue with yourself forever. The goal is to answer the near miss clearly enough to break the spell.',
      bullets: [
        'Close is still a loss.',
        'Almost winning did not put money back in my pocket.',
        'Another ticket does not fix the last one.',
        'The feeling is strong, but it is not proof.',
      ],
    ),
    NearMissSection(
      title: 'What to do next',
      body:
          'Once you recognize the near miss pull, the best move is usually to interrupt it quickly.',
      bullets: [
        'Step away from the display or counter.',
        'Open coping strategies and do one small action.',
        'Read your reasons to stop.',
        'Send a support message if the urge is still climbing.',
      ],
    ),
  ];

  static const List<String> quickReminders = [
    'Close is still a loss.',
    'The ticket created the feeling, not a real opportunity.',
    'Almost does not mean the next one is due.',
  ];
}
