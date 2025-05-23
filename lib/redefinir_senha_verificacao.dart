

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'redefinir_senha_confirmacao.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class CodigoENovaSenhaScreen extends StatefulWidget {
  final String email;

  const CodigoENovaSenhaScreen({required this.email, super.key});

  @override
  State<CodigoENovaSenhaScreen> createState() => _CodigoENovaSenhaScreenState();
}

class _CodigoENovaSenhaScreenState extends State<CodigoENovaSenhaScreen> {
  final _codigoController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  bool _isLoading = false;
  String _horaAtual = DateFormat('HH:mm').format(DateTime.now());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _horaAtual = DateFormat('HH:mm').format(DateTime.now());
        });
      };
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codigoController.dispose();
    _novaSenhaController.dispose();
    super.dispose();
  }

  void _confirmarRedefinicao() async {
    if (_codigoController.text.isEmpty || _novaSenhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://sua-api.com/redefinir-senha/confirmar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'codigo': _codigoController.text,
          'nova_senha': _novaSenhaController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => SenhaRedefinidaScreen()),
          (route) => false,
        );
      } else {
        final erro = jsonDecode(response.body)['erro'] ?? 'Erro desconhecido';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenSize.width > 600;
    double logoSize = isTablet ? 230 : 180;
    double containerWidth = isTablet ? 450 : 350;

    return WillPopScope(
      onWillPop: () async {
        final sair = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cancelar redefinição?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Sim', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        return sair ?? false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/imagem.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    const Color.fromARGB(51, 0, 0, 0),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(153, 155, 224, 236),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _horaAtual,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Row(
                              children: const [
                                Icon(Icons.wifi, color: Colors.white, size: 18),
                                SizedBox(width: 5),
                                Icon(Icons.signal_cellular_alt, color: Colors.white, size: 18),
                                SizedBox(width: 5),
                                Icon(Icons.battery_full, color: Colors.white, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: isLandscape
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 40),
                                      child: Image.asset(
                                        'assets/logo.png',
                                        width: logoSize,
                                      ),
                                    ),
                                    _buildFormContainer(containerWidth),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 40),
                                      child: Image.asset(
                                        'assets/logo.png',
                                        width: logoSize,
                                      ),
                                    ),
                                    _buildFormContainer(containerWidth),
                                  ],
                                ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Text(
                              "V 1.0.2",
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            SizedBox(height: 2),
                            SizedBox(width: 50, child: Divider(color: Colors.white, thickness: 1)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContainer(double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(178, 33, 38, 36),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(128),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Redefinir Senha',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _codigoController,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(Icons.code),
              labelText: 'Código de 6 dígitos',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _novaSenhaController,
            obscureText: true,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(Icons.lock),
              labelText: 'Nova Senha',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _confirmarRedefinicao,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: Size(double.infinity, 50),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}