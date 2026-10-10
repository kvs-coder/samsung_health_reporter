import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter_example/demo/catalog_bloc.dart';
import 'package:samsung_health_reporter_example/demo/demo_row.dart';
import 'package:samsung_health_reporter_example/demo/setup_bloc.dart';

void main() {
  final ok = DemoRow('ok', 'succeeds', run: () async => 'done');
  final failing = DemoRow(
    'failing',
    'fails',
    run: () async => throw PlatformException(code: 'save', message: 'denied'),
  );
  final updates = StreamController<String>.broadcast();
  final live = DemoRow(
    'live',
    'reports',
    listen: (report) => updates.stream.listen(report),
  );
  final sections = [
    DemoSection('Reader', [ok, failing]),
    DemoSection('Live', [live]),
  ];

  late CatalogBloc sut;
  setUp(() => sut = CatalogBloc(sections));
  tearDown(() => sut.close());

  test('a_row_reports_running_then_its_result', () async {
    final states =
        sut.states.map((e) => e.results[ok]?.status).take(2).toList();
    sut.add(RowTapped(ok));
    expect(await states, [RowStatus.running, RowStatus.success]);
    expect(sut.state.results[ok]?.text, 'done');
  });

  test('a_failing_row_reports_the_platform_error', () async {
    sut.add(RowTapped(failing));
    await sut.states.firstWhere(
      (e) => e.results[failing]?.status == RowStatus.failure,
    );
    expect(sut.state.results[failing]?.text, 'save: denied');
  });

  test('a_live_row_reports_updates_until_tapped_again', () async {
    sut.add(RowTapped(live));
    await sut.states.firstWhere((e) => e.live.contains(live));
    updates.add('1 update');
    await sut.states.firstWhere((e) => e.results[live]?.text == '1 update');
    expect(sut.state.results[live]?.status, RowStatus.listening);
    sut.add(RowTapped(live));
    await sut.states.firstWhere((e) => e.live.isEmpty);
    updates.add('ignored');
    await pumpEventQueue();
    expect(sut.state.results[live]?.text, 'stopped');
    expect(updates.hasListener, isFalse);
  });

  test('stopping_all_live_queries_clears_their_results', () async {
    sut.add(RowTapped(live));
    await sut.states.firstWhere((e) => e.live.contains(live));
    sut.add(const LiveQueriesStopped());
    await sut.states.firstWhere((e) => e.live.isEmpty);
    expect(sut.state.results.containsKey(live), isFalse);
  });

  test('search_and_section_filter_the_rows', () async {
    sut.add(const SearchChanged('FAIL'));
    await sut.states.first;
    expect(sut.state.visibleSections.single.rows, [failing]);
    sut
      ..add(const SearchChanged(''))
      ..add(const SectionSelected('Live'));
    await sut.states.firstWhere((e) => e.section == 'Live');
    expect(sut.state.visibleSections.single.title, 'Live');
    sut.add(const SectionSelected(null));
    await sut.states.first;
    expect(sut.state.visibleSections, hasLength(2));
  });

  group('setup', () {
    test('installed_samsung_health_is_ready', () async {
      final bloc = SetupBloc(isAvailable: () async => true);
      bloc.add(const SetupStarted());
      expect((await bloc.states.first).status, SetupStatus.ready);
      await bloc.close();
    });

    test('device_without_samsung_health_is_unavailable', () async {
      final bloc = SetupBloc(isAvailable: () async => false);
      bloc.add(const SetupStarted());
      expect((await bloc.states.first).status, SetupStatus.unavailable);
      await bloc.close();
    });

    test('a_failing_check_is_reported', () async {
      final bloc = SetupBloc(
        isAvailable: () async => throw PlatformException(
          code: 'isAvailable',
          message: 'No package manager',
        ),
      );
      bloc.add(const SetupStarted());
      final failed = await bloc.states.first;
      expect(failed.status, SetupStatus.failed);
      expect(failed.message, 'isAvailable: No package manager');
      await bloc.close();
    });
  });
}
