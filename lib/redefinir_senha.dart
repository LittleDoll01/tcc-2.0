import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'redefinir_senha_verificacao.dart';

class PasswordResetContainer extends StatefulWidget {
  const PasswordResetContainer({super.key});

  @override
  State<PasswordResetContainer> createState() => _PasswordResetContainerState();
}

class _PasswordResetContainerState extends State<PasswordResetContainer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String _horaAtual = DateFormat('HH:mm').format(DateTime.now());

  // Timer para atualizar o relógio
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Atualiza o horário a cada minuto
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _horaAtual = DateFormat('HH:mm').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simula o processamento
      Timer(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email enviado para ${_emailController.text}'),
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => CodigoENovaSenhaScreen(email: _emailController.text),),); // Volta para tela anterior
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenSize.width > 600;

    double logoSize = isTablet ? 230 : 180;
    double containerWidth = isTablet ? 450 : 350;

    return Scaffold(
      body: Stack(
        children: [
          // Background com imagem
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imagem.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color.fromARGB(51, 0, 0, 0),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Overlay azul
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(153, 155, 224, 236),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status bar
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _horaAtual,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Row(
                            children: [
                              Icon(Icons.wifi, color: Colors.white, size: 18),
                              SizedBox(width: 5),
                              Icon(
                                Icons.signal_cellular_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.battery_full,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Conteúdo principal
                    Expanded(
                      child: Center(
                        child:
                            isLandscape
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
                                    PasswordResetForm(
                                      formKey: _formKey,
                                      emailController: _emailController,
                                      onResetPassword: _resetPassword,
                                      isLoading: _isLoading,
                                      containerWidth: containerWidth,
                                    ),
                                  ],
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 40,
                                      ),
                                      child: Image.asset(
                                        'assets/logo.png',
                                        width: logoSize,
                                      ),
                                    ),
                                    PasswordResetForm(
                                      formKey: _formKey,
                                      emailController: _emailController,
                                      onResetPassword: _resetPassword,
                                      isLoading: _isLoading,
                                      containerWidth: containerWidth,
                                    ),
                                  ],
                                ),
                      ),
                    ),

                    // Versão do app
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            "V 1.0.2",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Container(width: 50, height: 2, color: Colors.white),
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
    );
  }
}

class PasswordResetForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final VoidCallback onResetPassword;
  final bool isLoading;
  final double containerWidth;

  const PasswordResetForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.onResetPassword,
    required this.isLoading,
    required this.containerWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
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
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Redefinição de senha",
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Digite seu email no campo abaixo e lhe enviaremos uma nova senha",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            FractionallySizedBox(
              alignment: Alignment.center,
              widthFactor: 0.8,
              child: TextFormField(
                controller: emailController,
                decoration:  InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                  border: OutlineInputBorder(  borderRadius: BorderRadius.circular(10),),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu email';
                  }
                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  RegExp regExp = RegExp(pattern);
                  if (!regExp.hasMatch(value)) {
                    return 'Digite um email válido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            FractionallySizedBox(
              alignment: Alignment.center,
              widthFactor: 0.8,
              child:
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: onResetPassword,
                        child: const Text("Solicitar nova senha"),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
