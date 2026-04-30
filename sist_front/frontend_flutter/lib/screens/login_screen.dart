import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/animated_fade_in.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE8ECE9)], // Branco e cinza/verde muito claro
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo Animado
                      AnimatedFadeIn(
                        delay: const Duration(milliseconds: 100),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppTheme.lightPrimary, AppTheme.lightSecondary],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.lightPrimary.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: const Icon(Icons.account_balance_wallet_outlined, size: 50, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Textos Animados
                      AnimatedFadeIn(
                        delay: const Duration(milliseconds: 200),
                        child: Column(
                          children: [
                            Text(
                              'FinControl',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    letterSpacing: 1.2,
                                    color: AppTheme.lightPrimary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sua vida financeira, simplificada.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.lightSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      // Login Glassmorphism Card Animado
                      AnimatedFadeIn(
                        delay: const Duration(milliseconds: 400),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.black.withOpacity(0.05)),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Acesse sua conta',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontSize: 20,
                                      color: AppTheme.lightPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Campo Email
                                  TextFormField(
                                    style: const TextStyle(color: AppTheme.lightPrimary),
                                    decoration: const InputDecoration(
                                      labelText: 'E-mail',
                                      prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 16),
                                  // Campo Senha
                                  TextFormField(
                                    style: const TextStyle(color: AppTheme.lightPrimary),
                                    decoration: InputDecoration(
                                      labelText: 'Senha',
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: !_isPasswordVisible,
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text('Esqueci minha senha'),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Botão Entrar
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => const MainNavigationScreen(),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            return FadeTransition(opacity: animation, child: child);
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text('ENTRAR'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Rodapé Animado
                      AnimatedFadeIn(
                        delay: const Duration(milliseconds: 600),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Ainda não tem uma conta? ', style: TextStyle(color: AppTheme.lightPrimary)),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                              child: const Text('Cadastre-se', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
