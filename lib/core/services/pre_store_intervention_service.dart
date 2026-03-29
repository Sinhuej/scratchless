class PreStoreScenario {
  final String id;
  final String chipLabel;
  final String title;
  final String summary;
  final List<String> steps;
  final String resetLine;
  final String linkedUrgeScriptId;

  const PreStoreScenario({
    required this.id,
    required this.chipLabel,
    required this.title,
    required this.summary,
    required this.steps,
    required this.resetLine,
    required this.linkedUrgeScriptId,
  });
}

class PreStoreInterventionService {
  static const List<PreStoreScenario> all = [
    PreStoreScenario(
      id: 'after_paycheck',
      chipLabel: 'After paycheck',
      title: 'Payday can make the stop feel justified',
      summary:
          'Fresh money can make a scratch-off feel harmless or earned before the stop even happens.',
      steps: [
        'Name the money’s real job before you park.',
        'Do not let “I have it” become “I should spend some.”',
        'Keep driving and give the money back to real life.',
      ],
      resetLine: 'Payday is not permission.',
      linkedUrgeScriptId: 'after_paycheck',
    ),
    PreStoreScenario(
      id: 'passing_store',
      chipLabel: 'Passing a store',
      title: 'Passing the store is a cue, not a command',
      summary:
          'The habit can start before you go inside. The route itself can wake up the urge.',
      steps: [
        'Do not negotiate while approaching the turn or lot.',
        'Keep moving past the store.',
        'Replace the stop with a small action somewhere else.',
      ],
      resetLine: 'Passing by does not mean stopping.',
      linkedUrgeScriptId: 'passing_store',
    ),
    PreStoreScenario(
      id: 'routine_stop',
      chipLabel: 'Routine stop',
      title: 'A normal stop can quietly turn into a ticket stop',
      summary:
          'The familiar errand can blur into the old pattern before you notice it.',
      steps: [
        'Say the real errand out loud before you get there.',
        'Do only the real errand.',
        'Leave without adding a ticket to the trip.',
      ],
      resetLine: 'Routine does not have to include a ticket.',
      linkedUrgeScriptId: 'passing_store',
    ),
    PreStoreScenario(
      id: 'saw_display',
      chipLabel: 'Saw a display',
      title: 'The display is trying to create urgency',
      summary:
          'Even before the counter, the display can make the ticket feel available and special.',
      steps: [
        'Do not stare at the display while deciding.',
        'Shift your eyes and attention away immediately.',
        'Keep moving instead of letting the display set the agenda.',
      ],
      resetLine: 'The display created the feeling, not the opportunity.',
      linkedUrgeScriptId: 'saw_display',
    ),
    PreStoreScenario(
      id: 'want_one',
      chipLabel: 'Want one',
      title: '“Just one” can start the whole loop',
      summary:
          'The thought sounds small, but it often acts like a doorway back into the spiral.',
      steps: [
        'Do not argue with the thought for too long.',
        'Answer it clearly: one is often how more than one starts.',
        'Drive past and revisit the urge later, not at the store.',
      ],
      resetLine: 'One ticket can reopen the whole loop.',
      linkedUrgeScriptId: 'only_one',
    ),
    PreStoreScenario(
      id: 'in_the_car',
      chipLabel: 'In the car',
      title: 'This is the best moment to interrupt it',
      summary:
          'If you are still in the car, you still have distance from the counter. That is power.',
      steps: [
        'Do not get out while undecided.',
        'Send a quick support message or open a script.',
        'Choose to keep driving before the friction disappears.',
      ],
      resetLine: 'While I am still in the car, I can still leave clean.',
      linkedUrgeScriptId: 'passing_store',
    ),
  ];

  static PreStoreScenario get defaultScenario => all[1];

  static PreStoreScenario byId(String id) {
    return all.firstWhere(
      (item) => item.id == id,
      orElse: () => defaultScenario,
    );
  }
}
