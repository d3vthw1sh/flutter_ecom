import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../logic/blocs/cart/cart_bloc.dart';
import '../../../logic/blocs/cart/cart_state.dart';
import '../../../data/services/stripe_service.dart';
import '../../../core/utils.dart';
import '../../widgets/app_appbar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _stripeService = StripeService();
  bool _isLoading = true;
  String? _checkoutUrl;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _initializeCheckout();
  }

  Future<void> _initializeCheckout() async {
    final cartState = context.read<CartBloc>().state;
    
    if (cartState is! CartLoaded || cartState.items.isEmpty) {
      if (mounted) {
        AppUtils.showToast('Cart is empty');
        Navigator.pop(context);
      }
      return;
    }

    try {
      // Build order payload
      final payload = {
        'cartItems': cartState.items.map((item) => {
          'id': item.id,
          'name': item.name,
          'price': item.price,
          'qty': item.qty,
          'image': item.image,
        }).toList(),
        'total': cartState.total,
      };

      // Create checkout session
      final response = await _stripeService.createCheckoutSession(payload);
      final url = response['url'] as String?;

      if (url != null && mounted) {
        setState(() {
          _checkoutUrl = url;
          _isLoading = false;
        });
        _initializeWebView();
      } else {
        throw Exception('No checkout URL received');
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showToast('Error: ${e.toString()}');
        Navigator.pop(context);
      }
    }
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url.toLowerCase();
            
            if (url.contains('success')) {
              Navigator.pushReplacementNamed(context, '/success');
              return NavigationDecision.prevent;
            } else if (url.contains('cancel')) {
              Navigator.pushReplacementNamed(context, '/cancel');
              return NavigationDecision.prevent;
            }
            
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_checkoutUrl!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'Checkout',
        showBack: true,
        showCart: false,
      ),
      body: Stack(
        children: [
          if (_checkoutUrl != null && _webViewController != null)
            WebViewWidget(controller: _webViewController!)
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_isLoading)
            Container(
              color: Colors.white.withValues(alpha: 0.8),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
