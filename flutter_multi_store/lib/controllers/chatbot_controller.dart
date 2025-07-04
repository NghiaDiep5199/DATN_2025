import 'dart:convert';

import 'package:flutter_multi_store/provider/chat_product_provider.dart';
import 'package:flutter_multi_store/services/gemini_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatbotController extends GetxController {
  RxList<MessageModel> messageList = <MessageModel>[].obs;
  RxBool isTyping = false.obs;
  final GeminiService _geminiService = GeminiService();
  final ChatProductProvider _productProvider = ChatProductProvider();

  String? handleCustomRequest(String input) {
    final productProvider = Get.find<ChatProductProvider>();

    // Giá cao nhất
    final highestMatch = RegExp(
      r"(giá cao nhất).*?(.+)",
      caseSensitive: false,
    ).firstMatch(input);
    if (highestMatch != null) {
      final categoryVi = highestMatch.group(2)!;
      final category = mapVietnameseCategoryToEnglish(categoryVi) ?? categoryVi;
      final product = productProvider.getHighestPriceInCategory(category);
      return product != null
          ? "Sản phẩm có giá cao nhất trong danh mục '$category':\nTên sản phẩm: ${product['productName']}\nGiá: \$${product['productPrice']}"
          : "Không tìm thấy sản phẩm nào trong danh mục '$category'.";
    }

    // Giá thấp nhất
    final lowestMatch = RegExp(
      r"(giá thấp nhất).*?(.+)",
      caseSensitive: false,
    ).firstMatch(input);
    if (lowestMatch != null) {
      final categoryVi = lowestMatch.group(2)!;
      final category = mapVietnameseCategoryToEnglish(categoryVi) ?? categoryVi;
      final product = productProvider.getLowestPriceInCategory(category);
      return product != null
          ? "Sản phẩm có giá thấp nhất trong danh mục '$category':\nTên sản phẩm: ${product['productName']}\nGiá: \$${product['productPrice']}"
          : "Không tìm thấy sản phẩm nào trong danh mục '$category'.";
    }

    // Sản phẩm dưới XXX đồng
    final underPriceMatch = RegExp(
      r"(?:cho tôi\s*)?(?:sản phẩm|sản phẩm nào)?\s*(.+?)\s*(?:dưới|<=)\s*(\d+)",
      caseSensitive: false,
    ).firstMatch(input);
    if (underPriceMatch != null) {
      final categoryVi = underPriceMatch.group(1)!;
      final category = mapVietnameseCategoryToEnglish(categoryVi) ?? categoryVi;
      final priceLimit = double.tryParse(underPriceMatch.group(2)!);
      if (priceLimit != null) {
        final products = productProvider.getProductsUnderPrice(
          category,
          priceLimit,
        );
        if (products.isEmpty)
          return "Không có sản phẩm nào dưới \$${priceLimit} trong danh mục '$category'.";
        return "Các sản phẩm dưới \$${priceLimit} trong danh mục '$category':\n" +
            products
                .map((p) => "${p['productName']} - \$${p['productPrice']}")
                .join('\n');
      }
    }

    // Đánh giá cao nhất
    final topRatedMatch = RegExp(
      r"(đánh giá cao nhất|được đánh giá cao|top đánh giá)\s+(.+)",
      caseSensitive: false,
    ).firstMatch(input);
    if (topRatedMatch != null) {
      final categoryVi = topRatedMatch.group(2)!;
      final category = mapVietnameseCategoryToEnglish(categoryVi) ?? categoryVi;
      final product = productProvider.getHighestRatedProduct(category);
      return product != null
          ? "Sản phẩm được đánh giá cao nhất trong danh mục '$category':\n${product['productName']} - ⭐ ${product['averageRating']}"
          : "Không tìm thấy sản phẩm nào trong danh mục '$category'.";
    }

    return null;
  }

  String? mapVietnameseCategoryToEnglish(String vietnamese) {
    final map = {
      'điện tử': 'Electronics',
      'đồng hồ': 'Watch',
      'túi': 'Bags',
      'nội thất': 'Furniture',
      'quần áo': 'Clothes',
      'thể thao': 'Sports',
    };

    final key = vietnamese.trim().toLowerCase();
    return map[key];
  }

  Future<void> sendMessage({required String message}) async {
    isTyping.value = true;
    messageList.add(MessageModel(message: message, isSender: true));

    // 1. Từ khóa đặc biệt (giá cao nhất, đánh giá cao nhất,...)
    final customReply = handleCustomRequest(message);
    if (customReply != null) {
      await Future.delayed(const Duration(milliseconds: 500));
      isTyping.value = false;
      messageList.add(MessageModel(message: customReply, isSender: false));
      return;
    }

    final lowerMsg = message.toLowerCase();
    final greetings = ['hello', 'hi', 'hey', 'xin chào', 'chào', 'yo'];
    if (greetings.any((greet) => lowerMsg.contains(greet))) {
      await Future.delayed(Duration(milliseconds: 300));
      isTyping.value = false;
      messageList.add(
        MessageModel(
          message: "Chào! Bạn muốn tôi giới thiệu loại sản phẩm nào?",
          isSender: false,
        ),
      );
      return;
    }

    // 2. Dùng AI để extract filter nếu là câu có vẻ lọc sản phẩm
    bool isProductFilterQuery(String message) {
      final text = message.toLowerCase();
      return text.contains('sản phẩm') ||
          text.contains('gợi ý') ||
          text.contains('mua') ||
          text.contains('đánh giá') ||
          text.contains('loại') ||
          text.contains('giá');
    }

    if (isProductFilterQuery(message)) {
      final filter = await _geminiService.extractFilter(message);
      if (filter != null) {
        final rawCategory = filter['category'];
        final category =
            mapVietnameseCategoryToEnglish(rawCategory ?? '') ?? rawCategory;
        final averageRating = filter['averageRating']?.toDouble() ?? 0.0;

        final products = await _productProvider.fetchProductsByFilter(
          category: category,
          averageRating: averageRating,
        );

        isTyping.value = false;
        if (products.isEmpty) {
          messageList.add(
            MessageModel(
              message: 'Không tìm thấy sản phẩm phù hợp với yêu cầu của bạn.',
              isSender: false,
            ),
          );
        } else {
          String productNames = products
              .map((e) => '• ${e['productName']} (⭐ ${e['averageRating']})')
              .join('\n');
          messageList.add(
            MessageModel(
              message: 'Sản phẩm gợi ý:\n$productNames',
              isSender: false,
            ),
          );
        }
        return;
      }
    }

    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyCEVFhXUTYiJfPC7WHJ8Puy7DFxd9QwFaQ',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": message},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> mapData = jsonDecode(response.body);
      String reply = mapData["candidates"][0]["content"]["parts"][0]["text"];
      isTyping.value = false;
      messageList.add(MessageModel(message: reply, isSender: false));
    } else {
      isTyping.value = false;
      messageList.add(
        MessageModel(
          message: 'Xin lỗi, tôi chưa thể phản hồi câu hỏi này.',
          isSender: false,
        ),
      );
    }
  }
}

class MessageModel {
  final String message;
  final bool isSender;

  MessageModel({required this.message, required this.isSender});
}
