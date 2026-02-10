import 'package:intl/intl.dart';

/// Centralized Rupiah currency formatting.
///
/// Usage:
///   CurrencyFormatter.format(2500000) → 'Rp 2.500.000'
///   CurrencyFormatter.compact(850000000) → '850M'
class CurrencyFormatter {
  CurrencyFormatter._();

  static final _fmt = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  /// Full Rupiah format: Rp 2.500.000
  static String format(double value) => _fmt.format(value);

  /// Compact format for large numbers: 850M, 2.5B
  static String compact(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(0)}M';
    }
    return NumberFormat.compact().format(value);
  }
}
