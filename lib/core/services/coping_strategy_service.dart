class CopingStrategy {
  final String title;
  final String whyItHelps;
  final List<String> steps;

  const CopingStrategy({
    required this.title,
    required this.whyItHelps,
    required this.steps,
  });
}

class CopingStrategyService {
  static const List<CopingStrategy> strategies = [
    CopingStrategy(
      title: 'Delay the decision',
      whyItHelps:
          'Urges peak and pass. A short delay creates distance between the feeling and the purchase.',
      steps: [
        'Set a 10-minute pause before doing anything.',
        'Do not stand at the counter while deciding.',
        'Tell yourself: I can wait 10 minutes before I choose anything.',
      ],
    ),
    CopingStrategy(
      title: 'Leave the trigger zone',
      whyItHelps:
          'Getting away from the ticket display or store reduces the power of the cue.',
      steps: [
        'Step away from the checkout or lottery machine.',
        'Walk outside or move to a different aisle.',
        'Change the route if you are passing a usual ticket stop.',
      ],
    ),
    CopingStrategy(
      title: 'Put money out of reach',
      whyItHelps:
          'Reducing access to money lowers the chance of acting on impulse.',
      steps: [
        'Do not carry extra cash if this is a risky time.',
        'Move money to a place that is less immediate to spend.',
        'Avoid browsing with payment ready in your hand.',
      ],
    ),
    CopingStrategy(
      title: 'Name the trigger',
      whyItHelps:
          'When you name what is happening, the urge becomes more understandable and less automatic.',
      steps: [
        'Open ScratchLess and log the trigger chip.',
        'Ask: is this stress, boredom, payday, seeing a display, or something else?',
        'Write one sentence about what happened right before the urge.',
      ],
    ),
    CopingStrategy(
      title: 'Do one replacement action',
      whyItHelps:
          'A small replacement action can interrupt the gambling loop and give your brain a different next step.',
      steps: [
        'Get water or a snack.',
        'Walk for 5 minutes.',
        'Text someone, stretch, or do one small errand.',
      ],
    ),
    CopingStrategy(
      title: 'Reach out to someone safe',
      whyItHelps:
          'A fast human check-in can lower the isolation and urgency around the urge.',
      steps: [
        'Open your accountability screen.',
        'Send the quick check-in or support message.',
        'Ask for 5 minutes of contact, not a perfect solution.',
      ],
    ),
    CopingStrategy(
      title: 'Read your reasons to stop',
      whyItHelps:
          'Personal reasons reconnect you with the future you actually want.',
      steps: [
        'Open your saved reasons to stop.',
        'Read them slowly, one by one.',
        'Ask which reason matters most right now.',
      ],
    ),
    CopingStrategy(
      title: 'Use help when the urge is too big',
      whyItHelps:
          'Some urges need more than self-control. Getting help early is a strength move.',
      steps: [
        'Open the Help screen.',
        'Call, text, or chat if the urge feels overwhelming.',
        'Use support before the spiral gets bigger.',
      ],
    ),
  ];
}
