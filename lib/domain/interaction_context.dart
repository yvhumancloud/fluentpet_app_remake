/// A tag on an Interaction describing the surrounding situation, used to
/// interpret what the pet meant. "by the door", "after breakfast", "modelling".
///
/// The domain calls this a **Context**. The Dart type is [InteractionContext]
/// because `Context` sits one careless import away from Flutter's
/// `BuildContext` in every widget file. See `domain.dart` for the full note —
/// the decision is made once, there, and not re-taken per file.
class InteractionContext {
  const InteractionContext({required this.id, required this.text});

  final int id;
  final String text;

  @override
  String toString() => text;
}
