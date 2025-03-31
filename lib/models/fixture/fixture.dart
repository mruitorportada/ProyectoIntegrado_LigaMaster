class Fixture {
  final int _num;
  get num => _num;
  final DateTime _fixtureDay;
  get fixtureDay => _fixtureDay;
  final List<Match> _matches;
  get matches => _matches;

  Fixture(this._num, this._fixtureDay, this._matches);
}
