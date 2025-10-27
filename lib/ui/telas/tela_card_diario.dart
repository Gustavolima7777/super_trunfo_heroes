import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class HeroiSimples {
  final String id;
  final String nome;
  final String urlImagem;
  HeroiSimples({required this.id, required this.nome, required this.urlImagem});
}

class CardDiarioScreen extends StatefulWidget {
  const CardDiarioScreen({Key? key}) : super(key: key);

  @override
  _CardDiarioScreenState createState() => _CardDiarioScreenState();
}

class _CardDiarioScreenState extends State<CardDiarioScreen> {
  static const String PREF_DATA_SORTEIO = 'dataUltimoSorteio';
  static const String PREF_ID_HEROI_SORTEADO = 'idHeroiSorteado';

  bool _isLoading = true;
  bool _isProcessingObter = false;
  HeroiSimples? _heroiDoDia;
  bool _jaObteveHoje = false;

  String _dataSalva = '';
  String _idSalvo = '';
  bool _flagObteve = false;

  @override
  void initState() {
    super.initState();
    print('[CardDiario] initState chamado');
    _verificarSorteioDiario();
  }

  String _todayKey() => DateTime.now().toIso8601String().substring(0, 10);
  String _keyObteve(String data) => 'obteve_$data';

  Future<void> _verificarSorteioDiario({bool forcarNovo = false}) async {
    setState(() { _isLoading = true; });

    final prefs = await SharedPreferences.getInstance();
    final String hoje = _todayKey();
    final String? dataSalva = prefs.getString(PREF_DATA_SORTEIO);

    print('[CardDiario] verificar: hoje=$hoje dataSalva=$dataSalva forcarNovo=$forcarNovo');

    try {
      if (!forcarNovo && dataSalva == hoje) {
        final String? idSalvo = prefs.getString(PREF_ID_HEROI_SORTEADO);
        print('[CardDiario] já sorteado hoje, idSalvo=$idSalvo');
        if (idSalvo != null && idSalvo.isNotEmpty) {
          _heroiDoDia = await _fetchHeroiById(idSalvo);
        } else {
          print('[CardDiario] idSalvo ausente -> sorteando novo');
          _heroiDoDia = await _fetchHeroiAleatorio();
          await prefs.setString(PREF_ID_HEROI_SORTEADO, _heroiDoDia!.id);
        }
        _jaObteveHoje = prefs.getBool(_keyObteve(hoje)) ?? false;
      } else {
        print('[CardDiario] novo dia ou forçar -> sorteando novo');
        _heroiDoDia = await _fetchHeroiAleatorio();
        await prefs.setString(PREF_DATA_SORTEIO, hoje);
        await prefs.setString(PREF_ID_HEROI_SORTEADO, _heroiDoDia!.id);
        _jaObteveHoje = false;
      }

      // Atualiza campos para exibir no UI
      _dataSalva = prefs.getString(PREF_DATA_SORTEIO) ?? '';
      _idSalvo = prefs.getString(PREF_ID_HEROI_SORTEADO) ?? '';
      _flagObteve = prefs.getBool(_keyObteve(hoje)) ?? false;

      print('[CardDiario] estado após verificar -> heroi=${_heroiDoDia?.nome}, _jaObteveHoje=$_jaObteveHoje, dataSalva=$_dataSalva, idSalvo=$_idSalvo, flagObteve=$_flagObteve');
    } catch (e, st) {
      print('[CardDiario] Erro em verificar: $e\n$st');
      _heroiDoDia = await _fetchHeroiAleatorio();
      _jaObteveHoje = false;
    }

    setState(() { _isLoading = false; });
  }

  Future<void> _obterCarta() async {
    if (_isProcessingObter) return;
    setState(() { _isProcessingObter = true; });

    try {
      final int contagemAtual = await _getContagemMinhasCartas();
      print('[CardDiario] contagemAtual=$contagemAtual');

      if (contagemAtual >= 15) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sua coleção está cheia!')));
        return;
      }

      if (_heroiDoDia == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Herói não carregado.')));
        return;
      }

      bool sucesso = await _adicionarHeroiEmMinhasCartas(_heroiDoDia!);
      print('[CardDiario] resultado inserir = $sucesso');

      if (sucesso) {
        final prefs = await SharedPreferences.getInstance();
        final hoje = _todayKey();
        await prefs.setBool(_keyObteve(hoje), true);
        _jaObteveHoje = true;
        _dataSalva = prefs.getString(PREF_DATA_SORTEIO) ?? '';
        _idSalvo = prefs.getString(PREF_ID_HEROI_SORTEADO) ?? '';
        _flagObteve = prefs.getBool(_keyObteve(hoje)) ?? false;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_heroiDoDia!.nome} adicionado!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Falha ao adicionar.')));
      }
    } catch (e, st) {
      print('[CardDiario] Erro em _obterCarta: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao obter carta. Veja console.')));
    } finally {
      setState(() { _isProcessingObter = false; });
    }
  }
  Future<void> _limparPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PREF_DATA_SORTEIO);
    await prefs.remove(PREF_ID_HEROI_SORTEADO);
    final hoje = _todayKey();
    await prefs.remove(_keyObteve(hoje));
    print('[CardDiario] SharedPreferences limpo para hoje=$hoje');
    await _verificarSorteioDiario();
  }
  Future<HeroiSimples> _fetchHeroiAleatorio() async {
    await Future.delayed(Duration(milliseconds: 300));
    List<String> ids = ['1', '70', '149'];
    String idSorteado = ids[Random().nextInt(ids.length)];
    print('[CardDiario] idSorteado = $idSorteado');
    return _fetchHeroiById(idSorteado);
  }

  Future<HeroiSimples> _fetchHeroiById(String id) async {
    await Future.delayed(Duration(milliseconds: 200));
    if (id == '70') {
      return HeroiSimples(id: '70', nome: 'Thor', urlImagem: 'https://via.placeholder.com/300x300.png?text=Thor');
    } else if (id == '149') {
      return HeroiSimples(id: '149', nome: 'Captain America', urlImagem: 'https://via.placeholder.com/300x300.png?text=Captain+America');
    }
    return HeroiSimples(id: '1', nome: 'A-Bomb', urlImagem: 'https://via.placeholder.com/300x300.png?text=A-Bomb');
  }

  Future<int> _getContagemMinhasCartas() async {
    await Future.delayed(Duration(milliseconds: 100));
    return 3; // substitua pelo SELECT COUNT(*) real
  }

  Future<bool> _adicionarHeroiEmMinhasCartas(HeroiSimples heroi) async {
    print('[CardDiario] Mock: adicionando ${heroi.nome}');
    await Future.delayed(Duration(milliseconds: 300));
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Diário')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Herói do dia:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              if (_heroiDoDia != null) ...[
                Text('Nome: ${_heroiDoDia!.nome}'),
                SizedBox(height: 8),
                Image.network(_heroiDoDia!.urlImagem, height: 180, errorBuilder: (_,__,___)=>Icon(Icons.image_not_supported,size:80)),
              ] else
                Text('Nenhum herói carregado'),
              Divider(),
              Text('SharedPreferences (info):', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('dataSalva: $_dataSalva'),
              Text('idSalvo: $_idSalvo'),
              Text('flagObteveHoje: $_flagObteve'),
              Divider(),
              ElevatedButton(
                onPressed: (_jaObteveHoje || _isProcessingObter) ? null : _obterCarta,
                child: _isProcessingObter ? SizedBox(height:16,width:16,child:CircularProgressIndicator(strokeWidth:2)) : Text(_jaObteveHoje ? 'Obtido!' : 'Obter'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _verificarSorteioDiario(forcarNovo: true),
                child: Text('Forçar Sorteio (novo herói)'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _limparPrefs,
                child: Text('Limpar SharedPrefs (hoje)'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _verificarSorteioDiario(),
                child: Text('Recarregar / Verificar'),
              ),
              SizedBox(height: 16),
              Text('Dicas de debug:'),
              Text('- Veja o console (procure por "[CardDiario]")'),
              Text('- Faça FULL RESTART após trocar código (hot reload pode não reinicializar SharedPreferences)'),
              Text('- Se a tela não estiver sendo aberta, verifique a navegação (Navigator.pushNamed / routes)'),
            ],
          ),
        ),
      ),
    );
  }
}
