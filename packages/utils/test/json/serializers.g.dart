// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(Chat.serializer)
      ..add(Hello.serializer)
      ..add(ListUsers.serializer)
      ..add(ListUsersResponse.serializer)
      ..add(Login.serializer)
      ..add(LoginResponse.serializer)
      ..add(QueryHelloReq.serializer)
      ..add(ShowChat.serializer)
      ..add(Status.serializer)
      ..add(StatusType.serializer)
      ..add(Title.serializer)
      ..add(Welcome.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Response)]),
          () => new ListBuilder<Response>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => new ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(Status)]),
          () => new MapBuilder<String, Status>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(StatusType)]),
          () => new SetBuilder<StatusType>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(String)]),
          () => new SetBuilder<String>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
