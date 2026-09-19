//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:fluentpet_api/src/date_serializer.dart';
import 'package:fluentpet_api/src/model/date.dart';

import 'package:fluentpet_api/src/model/audio_out.dart';
import 'package:fluentpet_api/src/model/base_button_out.dart';
import 'package:fluentpet_api/src/model/base_create.dart';
import 'package:fluentpet_api/src/model/base_out.dart';
import 'package:fluentpet_api/src/model/base_patch.dart';
import 'package:fluentpet_api/src/model/bulk_in.dart';
import 'package:fluentpet_api/src/model/bulk_out.dart';
import 'package:fluentpet_api/src/model/button_concept_out.dart';
import 'package:fluentpet_api/src/model/button_create.dart';
import 'package:fluentpet_api/src/model/button_merge.dart';
import 'package:fluentpet_api/src/model/button_out.dart';
import 'package:fluentpet_api/src/model/button_patch.dart';
import 'package:fluentpet_api/src/model/button_ref.dart';
import 'package:fluentpet_api/src/model/combination.dart';
import 'package:fluentpet_api/src/model/context_create.dart';
import 'package:fluentpet_api/src/model/context_out.dart';
import 'package:fluentpet_api/src/model/day_stat.dart';
import 'package:fluentpet_api/src/model/http_validation_error.dart';
import 'package:fluentpet_api/src/model/hour_stat.dart';
import 'package:fluentpet_api/src/model/household_detail_out.dart';
import 'package:fluentpet_api/src/model/household_out.dart';
import 'package:fluentpet_api/src/model/interaction_in.dart';
import 'package:fluentpet_api/src/model/interaction_merge.dart';
import 'package:fluentpet_api/src/model/interaction_out.dart';
import 'package:fluentpet_api/src/model/interaction_patch.dart';
import 'package:fluentpet_api/src/model/invitation_create.dart';
import 'package:fluentpet_api/src/model/invitation_out.dart';
import 'package:fluentpet_api/src/model/invitations_out.dart';
import 'package:fluentpet_api/src/model/items_inner.dart';
import 'package:fluentpet_api/src/model/learner_type_out.dart';
import 'package:fluentpet_api/src/model/linked_button_out.dart';
import 'package:fluentpet_api/src/model/location_inner.dart';
import 'package:fluentpet_api/src/model/me_out.dart';
import 'package:fluentpet_api/src/model/me_patch.dart';
import 'package:fluentpet_api/src/model/note_in.dart';
import 'package:fluentpet_api/src/model/note_out.dart';
import 'package:fluentpet_api/src/model/note_patch.dart';
import 'package:fluentpet_api/src/model/preference_in.dart';
import 'package:fluentpet_api/src/model/preference_out.dart';
import 'package:fluentpet_api/src/model/press_out.dart';
import 'package:fluentpet_api/src/model/push_token_in.dart';
import 'package:fluentpet_api/src/model/pusher_detail_out.dart';
import 'package:fluentpet_api/src/model/pusher_in.dart';
import 'package:fluentpet_api/src/model/pusher_out.dart';
import 'package:fluentpet_api/src/model/pusher_patch.dart';
import 'package:fluentpet_api/src/model/pusher_ref.dart';
import 'package:fluentpet_api/src/model/pusher_stats_out.dart';
import 'package:fluentpet_api/src/model/search_counts.dart';
import 'package:fluentpet_api/src/model/search_filters.dart';
import 'package:fluentpet_api/src/model/search_in.dart';
import 'package:fluentpet_api/src/model/search_out.dart';
import 'package:fluentpet_api/src/model/stats_range.dart';
import 'package:fluentpet_api/src/model/stats_summary_out.dart';
import 'package:fluentpet_api/src/model/stats_totals.dart';
import 'package:fluentpet_api/src/model/text_count.dart';
import 'package:fluentpet_api/src/model/url_out.dart';
import 'package:fluentpet_api/src/model/user_out.dart';
import 'package:fluentpet_api/src/model/validation_error.dart';
import 'package:fluentpet_api/src/model/webhook_log_out.dart';

part 'serializers.g.dart';

@SerializersFor([
  AudioOut,
  BaseButtonOut,
  BaseCreate,
  BaseOut,
  BasePatch,
  BulkIn,
  BulkOut,
  ButtonConceptOut,
  ButtonCreate,
  ButtonMerge,
  ButtonOut,
  ButtonPatch,
  ButtonRef,
  Combination,
  ContextCreate,
  ContextOut,
  DayStat,
  HTTPValidationError,
  HourStat,
  HouseholdDetailOut,
  HouseholdOut,
  InteractionIn,
  InteractionMerge,
  InteractionOut,
  InteractionPatch,
  InvitationCreate,
  InvitationOut,
  InvitationsOut,
  ItemsInner,
  LearnerTypeOut,
  LinkedButtonOut,
  LocationInner,
  MeOut,
  MePatch,
  NoteIn,
  NoteOut,
  NotePatch,
  PreferenceIn,
  PreferenceOut,
  PressOut,
  PushTokenIn,
  PusherDetailOut,
  PusherIn,
  PusherOut,
  PusherPatch,
  PusherRef,
  PusherStatsOut,
  SearchCounts,
  SearchFilters,
  SearchIn,
  SearchOut,
  StatsRange,
  StatsSummaryOut,
  StatsTotals,
  TextCount,
  UrlOut,
  UserOut,
  ValidationError,
  WebhookLogOut,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(PressOut)]),
        () => ListBuilder<PressOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ButtonConceptOut)]),
        () => ListBuilder<ButtonConceptOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ButtonRef)]),
        () => ListBuilder<ButtonRef>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ButtonOut)]),
        () => ListBuilder<ButtonOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ItemsInner)]),
        () => ListBuilder<ItemsInner>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(HourStat)]),
        () => ListBuilder<HourStat>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(UserOut)]),
        () => ListBuilder<UserOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(LinkedButtonOut)]),
        () => ListBuilder<LinkedButtonOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(TextCount)]),
        () => ListBuilder<TextCount>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(InvitationOut)]),
        () => ListBuilder<InvitationOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(PusherOut)]),
        () => ListBuilder<PusherOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DayStat)]),
        () => ListBuilder<DayStat>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(InteractionOut)]),
        () => ListBuilder<InteractionOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AudioOut)]),
        () => ListBuilder<AudioOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(int)]),
        () => ListBuilder<int>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(LocationInner)]),
        () => ListBuilder<LocationInner>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(BaseOut)]),
        () => ListBuilder<BaseOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(PusherDetailOut)]),
        () => ListBuilder<PusherDetailOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ContextOut)]),
        () => ListBuilder<ContextOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(WebhookLogOut)]),
        () => ListBuilder<WebhookLogOut>(),
      )
      ..addBuilderFactory(
        const FullType(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
        () => MapBuilder<String, JsonObject?>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ValidationError)]),
        () => ListBuilder<ValidationError>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(LearnerTypeOut)]),
        () => ListBuilder<LearnerTypeOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
        () => MapBuilder<String, JsonObject>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
