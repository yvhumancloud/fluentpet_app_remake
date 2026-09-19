// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(AudioOut.serializer)
      ..add(BaseButtonOut.serializer)
      ..add(BaseCreate.serializer)
      ..add(BaseOut.serializer)
      ..add(BasePatch.serializer)
      ..add(BulkIn.serializer)
      ..add(BulkInOperationEnum.serializer)
      ..add(BulkOut.serializer)
      ..add(ButtonConceptOut.serializer)
      ..add(ButtonCreate.serializer)
      ..add(ButtonMerge.serializer)
      ..add(ButtonOut.serializer)
      ..add(ButtonPatch.serializer)
      ..add(ButtonRef.serializer)
      ..add(ChatIn.serializer)
      ..add(ChatMessage.serializer)
      ..add(ChatMessageRoleEnum.serializer)
      ..add(ChatOut.serializer)
      ..add(Combination.serializer)
      ..add(ContextCreate.serializer)
      ..add(ContextCreateAppliesToEnum.serializer)
      ..add(ContextOut.serializer)
      ..add(DayStat.serializer)
      ..add(HTTPValidationError.serializer)
      ..add(HourStat.serializer)
      ..add(HouseholdDetailOut.serializer)
      ..add(HouseholdOut.serializer)
      ..add(InteractionIn.serializer)
      ..add(InteractionMerge.serializer)
      ..add(InteractionOut.serializer)
      ..add(InteractionOutTypeEnum.serializer)
      ..add(InteractionPatch.serializer)
      ..add(InvitationCreate.serializer)
      ..add(InvitationOut.serializer)
      ..add(InvitationsOut.serializer)
      ..add(ItemsInner.serializer)
      ..add(LearnerTypeOut.serializer)
      ..add(LinkedButtonOut.serializer)
      ..add(LocationInner.serializer)
      ..add(LogTextIn.serializer)
      ..add(LogTextOut.serializer)
      ..add(MeOut.serializer)
      ..add(MePatch.serializer)
      ..add(NoteIn.serializer)
      ..add(NoteOut.serializer)
      ..add(NoteOutTypeEnum.serializer)
      ..add(NotePatch.serializer)
      ..add(PreferenceIn.serializer)
      ..add(PreferenceOut.serializer)
      ..add(PressOut.serializer)
      ..add(PushTokenIn.serializer)
      ..add(PusherDetailOut.serializer)
      ..add(PusherIn.serializer)
      ..add(PusherOut.serializer)
      ..add(PusherPatch.serializer)
      ..add(PusherRef.serializer)
      ..add(PusherStatsOut.serializer)
      ..add(SearchCounts.serializer)
      ..add(SearchFilters.serializer)
      ..add(SearchFiltersFavouritesEnum.serializer)
      ..add(SearchFiltersMatchEnum.serializer)
      ..add(SearchFiltersNotesEnum.serializer)
      ..add(SearchFiltersPressesEnum.serializer)
      ..add(SearchFiltersWithNoteEnum.serializer)
      ..add(SearchIn.serializer)
      ..add(SearchInSortEnum.serializer)
      ..add(SearchInTabEnum.serializer)
      ..add(SearchOut.serializer)
      ..add(StatsRange.serializer)
      ..add(StatsSummaryOut.serializer)
      ..add(StatsTotals.serializer)
      ..add(TextCount.serializer)
      ..add(UrlOut.serializer)
      ..add(UserOut.serializer)
      ..add(ValidationError.serializer)
      ..add(WebhookLogOut.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ButtonRef)]),
          () => ListBuilder<ButtonRef>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ChatMessage)]),
          () => ListBuilder<ChatMessage>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InvitationOut)]),
          () => ListBuilder<InvitationOut>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InvitationOut)]),
          () => ListBuilder<InvitationOut>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ItemsInner)]),
          () => ListBuilder<ItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(LocationInner)]),
          () => ListBuilder<LocationInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PressOut)]),
          () => ListBuilder<PressOut>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ContextOut)]),
          () => ListBuilder<ContextOut>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PusherOut)]),
          () => ListBuilder<PusherOut>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PusherOut)]),
          () => ListBuilder<PusherOut>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InvitationOut)]),
          () => ListBuilder<InvitationOut>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TextCount)]),
          () => ListBuilder<TextCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TextCount)]),
          () => ListBuilder<TextCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TextCount)]),
          () => ListBuilder<TextCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TextCount)]),
          () => ListBuilder<TextCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TextCount)]),
          () => ListBuilder<TextCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TextCount)]),
          () => ListBuilder<TextCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TextCount)]),
          () => ListBuilder<TextCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DayStat)]),
          () => ListBuilder<DayStat>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(HourStat)]),
          () => ListBuilder<HourStat>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(UserOut)]),
          () => ListBuilder<UserOut>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InvitationOut)]),
          () => ListBuilder<InvitationOut>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ValidationError)]),
          () => ListBuilder<ValidationError>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(LinkedButtonOut)]),
          () => ListBuilder<LinkedButtonOut>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
