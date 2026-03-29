class UrgeScript {
  final String id;
  final String chipLabel;
  final String title;
  final String summary;
  final String realityCheck;
  final List<String> steps;
  final List<String> resetLines;

  const UrgeScript({
    required this.id,
    required this.chipLabel,
    required this.title,
    required this.summary,
    required this.realityCheck,
    required this.steps,
    required this.resetLines,
  });
}

class UrgeScriptService {
  static const List<UrgeScript> all = [
    UrgeScript(
      id: 'after_paycheck',
      chipLabel: 'After paycheck',
      title: 'The paycheck hit and the urge woke up',
      summary:
          'Payday can make scratch-offs feel affordable, deserved, or harmless.',
      realityCheck:
          'Fresh money is still your real life money. A ticket does not become safer because the account just changed.',
      steps: [
        'Move the money mentally back into real life: bills, food, gas, peace.',
        'Do not let “I have money right now” become “I should spend some on tickets.”',
        'Open Goals and look at your cap before buying anything.',
      ],
      resetLines: [
        'Payday is not permission.',
        'This money already has a better job.',
      ],
    ),
    UrgeScript(
      id: 'saw_display',
      chipLabel: 'Saw a display',
      title: 'The display caught your attention',
      summary:
          'The display is designed to make the ticket feel immediate, exciting, and available.',
      realityCheck:
          'The display is marketing, not meaning. It is trying to create a moment, not reveal one.',
      steps: [
        'Step away from the counter or machine.',
        'Look at literally anything else for 10 seconds and break the tunnel.',
        'Say: the display created the feeling, not an opportunity.',
      ],
      resetLines: [
        'The display is a trap, not a sign.',
        'Attention is not destiny.',
      ],
    ),
    UrgeScript(
      id: 'won_recently',
      chipLabel: 'Won recently',
      title: 'A recent win is trying to pull you back',
      summary:
          'A recent win can make the next ticket feel hot, due, or special.',
      realityCheck:
          'A past win does not improve the next ticket. The pull is emotional, not mathematical.',
      steps: [
        'Do not recycle the win into more tickets.',
        'Open the money converter and treat the win like real money again.',
        'Say: that win is already over. The next ticket is a new risk.',
      ],
      resetLines: [
        'A recent win does not make the next one smarter.',
        'Winning once is not a green light.',
      ],
    ),
    UrgeScript(
      id: 'passing_store',
      chipLabel: 'Passing a store',
      title: 'You are near a usual ticket stop',
      summary:
          'Sometimes the urge starts before you even go inside. The route itself becomes part of the habit.',
      realityCheck:
          'Passing the store is a cue, not a command. You are allowed to keep driving.',
      steps: [
        'Do not negotiate while approaching the store.',
        'Keep moving past the turn or parking lot.',
        'Use a replacement move right away: call someone, grab water elsewhere, or change route.',
      ],
      resetLines: [
        'Passing by does not mean stopping.',
        'The route is a cue, not a decision.',
      ],
    ),
    UrgeScript(
      id: 'only_one',
      chipLabel: 'Only want one',
      title: '“I only want one” is showing up',
      summary:
          'One ticket often sounds small enough to excuse, even when it reopens the spiral.',
      realityCheck:
          'One ticket is often not about one ticket. It is about restarting the loop.',
      steps: [
        'Pause the thought instead of debating it.',
        'Say: one is often the sentence that gets me to more than one.',
        'Delay 10 minutes before deciding anything else.',
      ],
      resetLines: [
        'One ticket can reopen the whole loop.',
        'Small does not always mean safe.',
      ],
    ),
    UrgeScript(
      id: 'already_in_store',
      chipLabel: 'In the store',
      title: 'You are already inside the store',
      summary:
          'Being inside can make buying feel easier because the friction is gone.',
      realityCheck:
          'Being in the store does not obligate you to buy a ticket.',
      steps: [
        'Do not stand at the ticket counter while thinking.',
        'Finish only the real errand or leave immediately.',
        'Use the quick check-in card before you reach the register.',
      ],
      resetLines: [
        'Being here is not the same as choosing.',
        'I can leave without buying.',
      ],
    ),
  ];

  static UrgeScript get defaultScript => all[1];

  static UrgeScript byId(String id) {
    return all.firstWhere(
      (script) => script.id == id,
      orElse: () => defaultScript,
    );
  }
}
