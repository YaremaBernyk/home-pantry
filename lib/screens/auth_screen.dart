import 'package:flutter/material.dart';

import '../core/widgets/pantry_widgets.dart';

enum AuthMode { login, register, reset }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.mode});
  final AuthMode mode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _userName = TextEditingController();
  AuthMode get mode => widget.mode;

  @override
  void dispose() {
    _userName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reset = mode == AuthMode.reset;
    final register = mode == AuthMode.register;
    void open(String route) => Navigator.pushReplacementNamed(context, route);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: SizedBox(
                    width: register || reset ? 456 : 424,
                    child: PantryCard(
                      padding: 32,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8D6C9),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              color: PantryColors.accent,
                            ),
                          ),
                          const SizedBox(height: 26),
                          if (reset) ...[
                            const Text(
                              'The Pantry',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 24,
                                color: PantryColors.accent,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          Text(
                            register
                                ? 'Create your pantry'
                                : reset
                                ? 'Forgot your password?'
                                : 'The Pantry',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 38,
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (register)
                            PantryField(
                              controller: _userName,
                              label: 'User name',
                              hint: 'Yarema_123',
                              helper: '3 to 20 characters: letters, numbers, underscores',
                            ),
                          if (reset) ...[
                            const Text(
                              "No worries. Enter your email and we’ll send a link to reset your password.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: PantryColors.muted,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          PantryField(
                            controller: mode == AuthMode.login
                                ? _userName
                                : null,
                            label: register
                                ? 'Email'
                                : reset
                                ? 'Email address'
                                : null,
                            hint: register || reset
                                ? 'you@email.com'
                                : 'Username',
                            keyboardType: register || reset
                                ? TextInputType.emailAddress
                                : null,
                          ),
                          if (!reset)
                            PantryField(
                              label: register ? 'Password' : null,
                              hint: register
                                  ? 'At least 8 characters'
                                  : 'Password',
                              secret: true,
                            ),
                          if (register)
                            const PantryField(
                              label: 'Confirm Password',
                              hint: 'Passwords must match',
                              secret: true,
                            ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            child: PantryButton(
                              label: register
                                  ? 'Create my pantry'
                                  : reset
                                  ? 'Send reset link'
                                  : 'Come on in',
                              onPressed: () {
                                if (reset) {
                                  showDemoNotice(
                                    context,
                                    'UI demo: email delivery is not connected.',
                                  );
                                } else {
                                  final name = _userName.text.trim();
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                    arguments: name.isEmpty ? 'Yarema' : name,
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (mode == AuthMode.login) ...[
                            TextButton(
                              onPressed: () => open('/reset'),
                              child: const Text('Forgot your password?'),
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'New here?',
                                  style: TextStyle(color: PantryColors.muted),
                                ),
                                TextButton(
                                  onPressed: () => open('/register'),
                                  child: const Text('Create your pantry'),
                                ),
                              ],
                            ),
                          ] else
                            TextButton(
                              onPressed: () => open('/login'),
                              child: const Text('←  Back to sign in'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
