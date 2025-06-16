Development Roadmap
🚀 Project Name: PocketBox
📝 Description: A Chrome extension that provides a collection of tools for everyday use.

Phase 1 (Core Features)
QR Code Generator

 Get current tab URL (requires "activeTab" permission).

 Generate QR using a library like qrcode.react.

 Copy/download QR as image.

Color Picker

 Use EyeDropper API (fallback with manual input if not available).

 Display selected color in HEX, RGB, HSL.

 One-click copy of color codes.

Password Generator

 Options: length, use symbols, numbers, upper/lowercase.

 Generate password with randomizer.

 One-click copy.

 Phase 2 (Enhancements)
Text Snippets Saver

 Store frequently used snippets (notes, code).

 Editable, deletable entries.

 Store in localStorage or Firebase if logged in.

Clipboard Manager

 Monitor copy events and save last 5 copied items.

 Display history with copy back option.



TinyURL Generator

 Fetch TinyURL API to shorten current tab URL.

 Copy to clipboard.

📁 File Structure (Modular, One Tool Per Component)
arduino
Copy
Edit
pocketbox/
├── public/
│   └── icons/            # Extension icons
├── src/
│   ├── assets/
│   ├── components/
│   │   ├── QRCodeTool.tsx
│   │   ├── ColorPickerTool.tsx
│   │   ├── PasswordGeneratorTool.tsx
│   │   ├── TextSnippetsTool.tsx
│   │   ├── ClipboardManagerTool.tsx
│   │   ├── JSONBeautifierTool.tsx
│   │   ├── Base64Tool.tsx
│   │   └── TinyURLTool.tsx
│   ├── popup/
│   │   ├── Popup.tsx
│   │   └── Popup.css
│   ├── styles/
│   │   └── tailwind.css
│   ├── App.tsx
│   └── main.tsx
├── manifest.json
├── tailwind.config.js
├── postcss.config.js
├── vite.config.ts
└── tsconfig.json