import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onToggleTheme});
  final VoidCallback onToggleTheme;
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = ApiService();
  int tab = 0;
  bool advanced = false;
  final symbols = ['TCS', 'INFY', 'RELIANCE', 'HDFCBANK', 'AAPL', 'MSFT', 'NVDA', 'TSLA'];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('AI MarketLens', style: TextStyle(fontWeight: FontWeight.w800)), actions: [IconButton(onPressed: widget.onToggleTheme, icon: const Icon(Icons.brightness_6_outlined), tooltip: 'Theme')]),
    body: IndexedStack(index: tab, children: [_dashboard(), _markets(), _watchlist(), _portfolio(), _assistant()]),
    bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (value) => setState(() => tab = value), destinations: const [NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Home'), NavigationDestination(icon: Icon(Icons.query_stats), label: 'Markets'), NavigationDestination(icon: Icon(Icons.bookmark_border), label: 'Watchlist'), NavigationDestination(icon: Icon(Icons.pie_chart_outline), label: 'Portfolio'), NavigationDestination(icon: Icon(Icons.auto_awesome), label: 'AI')]),
  );

  Widget _dashboard() => FutureBuilder<Map<String, dynamic>>(future: api.overview(), builder: (context, snapshot) {
    final indices = snapshot.data?['indices'] as List<dynamic>? ?? [];
    return ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 28), children: [
      Text('Good morning, investor', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 4), Text('Read the market clearly.', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 20), _demoBanner(), const SizedBox(height: 16),
      _sectionTitle('Market overview'), SizedBox(height: 106, child: ListView(scrollDirection: Axis.horizontal, children: indices.map((item) => _indexCard(item)).toList())),
      const SizedBox(height: 22), _pulseCard(), const SizedBox(height: 22), _sectionTitle('Stocks to understand'),
      ...symbols.take(4).map((symbol) => _stockTile(symbol)),
    ]);
  });

  Widget _demoBanner() => Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: const Color(0xff26352f), borderRadius: BorderRadius.circular(12)), child: const Row(children: [Icon(Icons.science_outlined, color: Color(0xff8ed9a9)), SizedBox(width: 10), Expanded(child: Text('DEMO DATA  •  Last updated just now', style: TextStyle(color: Color(0xffb7e6c8), fontSize: 12, fontWeight: FontWeight.w700)))]));
  Widget _sectionTitle(String text) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w800, color: Colors.grey)));
  Widget _indexCard(dynamic item) => Container(width: 142, margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w700)), const Spacer(), Text('${item['value']}', style: const TextStyle(fontWeight: FontWeight.w800)), Text('+${item['change']}%', style: const TextStyle(color: Color(0xff72d39a), fontWeight: FontWeight.w700))]));
  Widget _pulseCard() => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xff183b38), borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.auto_awesome, color: Color(0xffffc76b)), SizedBox(width: 8), Text('AI MARKET PULSE', style: TextStyle(color: Color(0xffffc76b), fontWeight: FontWeight.w800, letterSpacing: 1.1))]), const SizedBox(height: 14), const Text('Moderately bullish', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 14), const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Risk  Medium'), Text('Momentum  Positive'), Text('Confidence  81%')]), const SizedBox(height: 16), OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.arrow_outward), label: const Text('Explain market'), style: OutlinedButton.styleFrom(foregroundColor: Colors.white))]));
  Widget _stockTile(String symbol) => FutureBuilder<Map<String, dynamic>>(future: api.stock(symbol), builder: (context, snapshot) { final item = snapshot.data; if (item == null) return const SizedBox(height: 64); final positive = (item['change'] as num) >= 0; return ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(backgroundColor: positive ? const Color(0xff254c3c) : const Color(0xff4b302d), child: Text(symbol.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.w800))), title: Text(symbol, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(item['sector']), trailing: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [Text('\$${item['price']}', style: const TextStyle(fontWeight: FontWeight.w700)), Text('${positive ? '+' : ''}${item['change']}%', style: TextStyle(color: positive ? const Color(0xff72d39a) : const Color(0xffef8179)))])}); });

  Widget _markets() => ListView(padding: const EdgeInsets.all(20), children: [Text('Market scanner', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8), TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search company or ticker', border: OutlineInputBorder())), const SizedBox(height: 18), _modeSwitch(), ...symbols.map((symbol) => _stockTile(symbol))]);
  Widget _modeSwitch() => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Analysis mode', style: TextStyle(fontWeight: FontWeight.w700)), SegmentedButton<bool>(segments: const [ButtonSegment(value: false, label: Text('Beginner')), ButtonSegment(value: true, label: Text('Advanced'))], selected: {advanced}, onSelectionChanged: (value) => setState(() => advanced = value.first))]);
  Widget _watchlist() => ListView(padding: const EdgeInsets.all(20), children: [Text('My watchlist', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('Signals worth understanding before you act.'), const SizedBox(height: 16), ...symbols.take(5).map((symbol) => _stockTile(symbol))]);
  Widget _portfolio() => FutureBuilder<Map<String, dynamic>>(future: api.health(), builder: (context, snapshot) { final data = snapshot.data; return ListView(padding: const EdgeInsets.all(20), children: [Text('Portfolio health', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 18), if (data != null) ...[_scoreCard('Health score', '${data['health']}/100', const Color(0xffe36b3d)), _metricRow('Diversification', '${data['diversification']}/100'), _metricRow('Risk', data['risk']), _metricRow('Sector concentration', data['sector_concentration']), const SizedBox(height: 18), Text(data['explanation'], style: const TextStyle(height: 1.5))] else const Center(child: CircularProgressIndicator())]); });
  Widget _scoreCard(String title, String value, Color color) => Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800))]));
  Widget _metricRow(String label, String value) => ListTile(contentPadding: EdgeInsets.zero, title: Text(label), trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w800)));
  Widget _assistant() => ListView(padding: const EdgeInsets.all(20), children: [Text('AI market assistant', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('Ask about the market in plain language.'), const SizedBox(height: 22), ...['What is happening in the market today?', 'Explain RSI to me.', 'Which watchlist stock has high volatility?', 'Why did my portfolio change today?'].map((question) => Card(child: ListTile(leading: const Icon(Icons.auto_awesome), title: Text(question), onTap: () {}))), const SizedBox(height: 18), const Text('AI MarketLens provides educational information for decision support only. It is not financial advice and does not guarantee returns.', style: TextStyle(color: Colors.grey, height: 1.4, fontSize: 12))]);
}
