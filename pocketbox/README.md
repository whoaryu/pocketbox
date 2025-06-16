I’m building a Flutter app called “PocketBox” – a Swiss Army Knife of utility tools.

I already have some features implemented like:
- Word Counter
- Base64 Converter
- QR Code Generator
- JSON Formatter
- Coin Toss (with animation)
- Clipboard Manager

I want to **revamp the folder and file structure** to match this new logical layout of main tool categories. Please do the following:

---

### 🧩 1. Create a new feature-based folder structure under `/lib/features/` like this:

/features  
├── **text_tools/**  
│   ├── word_counter/  
│   ├── text_case_converter/  
│   ├── find_replace/  
│   ├── reverse_text/  
│   └── ...  

├── **image_tools/**  
│   ├── resize_image/  
│   ├── crop_image/  
│   ├── compress_image/  
│   └── ...  

├── **conversion_tools/**  
│   ├── base64_converter/  
│   ├── currency_converter/  
│   ├── unit_converter/  
│   └── ...  

├── **dev_tools/**  
│   ├── json_formatter/  
│   ├── xml_formatter/  
│   ├── api_tester/  
│   └── base_converter/  

├── **randomizer_tools/**  
│   ├── coin_toss/  
│   ├── wheel_spinner/  
│   ├── number_picker/  
│   └── dice_roller/  

├── **other_tools/**  
│   ├── qr_code_generator/  
│   ├── qr_code_scanner/  
│   ├── barcode_generator/  
│   ├── barcode_scanner/  
│   ├── color_picker/  
│   ├── image_color_picker/  
│   └── color_blend/  

├── **general_tools/**  
│   ├── clipboard_manager/  
│   ├── password_generator/  
│   ├── compass/  
│   ├── morse_code/  
│   └── ruler/  

---

### 🧭 2. Organize existing tools into their new locations:
- Move Word Counter → `features/text_tools/word_counter/`
- Move Base64 Converter → `features/conversion_tools/base64_converter/`
- Move JSON Formatter → `features/dev_tools/json_formatter/`
- Move QR Code Generator → `features/other_tools/qr_code_generator/`
- Move Coin Toss → `features/randomizer_tools/coin_toss/`
- Move Clipboard Manager → `features/general_tools/clipboard_manager/`

Each folder should have:
- A `screen.dart` for the main UI.
- A `controller.dart` or `provider.dart` for logic.
- Optional `utils.dart` for helpers.

---

### ⚙️ 3. Add Index Screens for Each Category
Under `/lib/screens/`, create new screens that act as **category dashboards**:
- `text_tools_screen.dart`
- `image_tools_screen.dart`
- `conversion_tools_screen.dart`
- `dev_tools_screen.dart`
- `randomizer_tools_screen.dart`
- `other_tools_screen.dart`
- `general_tools_screen.dart`

Each should list buttons/cards to navigate to individual tools.

---

### 🧼 4. Clean up `main.dart` or `home_screen.dart`
Replace the current flat layout with a **modular home screen**:
- Show category tiles (Text, Image, Conversion, etc.)
- On tap, navigate to the respective category screen

---

🎯 Ensure all routes are updated in `app_router.dart` or equivalent navigation file.

---

Let me know when you're done and I’ll provide prompts for the next batch of tools!
