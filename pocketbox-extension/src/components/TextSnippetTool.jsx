import React, { useState, useEffect } from 'react';
import QRCode from 'qrcode';
import { motion, AnimatePresence } from 'framer-motion';
import { FaQrcode, FaCopy, FaShare, FaCheck } from 'react-icons/fa';

export default function TextSnippetTool() {
  const [text, setText] = useState('');
  const [qrCodeUrl, setQrCodeUrl] = useState('');
  const [showQR, setShowQR] = useState(false);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    // Listen for text selection changes
    const checkSelection = () => {
      const selectedText = window.getSelection().toString().trim();
      if (selectedText) {
        setText(selectedText);
      }
    };

    // Get the current tab's selected text
    chrome.tabs.query({ active: true, currentWindow: true }, async (tabs) => {
      if (tabs[0]?.id) {
        try {
          const [{ result }] = await chrome.scripting.executeScript({
            target: { tabId: tabs[0].id },
            func: () => window.getSelection().toString().trim(),
          });
          if (result) setText(result);
        } catch (err) {
          console.error('Error getting selection:', err);
        }
      }
    });

    document.addEventListener('selectionchange', checkSelection);
    return () => document.removeEventListener('selectionchange', checkSelection);
  }, []);

  useEffect(() => {
    if (text && showQR) {
      QRCode.toDataURL(text, {
        width: 200,
        margin: 1,
        color: {
          dark: '#1E293B',
          light: '#ffffff',
        },
      }).then(setQrCodeUrl);
    }
  }, [text, showQR]);

  const handleShare = () => {
    setShowQR(true);
  };

  const copyToClipboard = async () => {
    await navigator.clipboard.writeText(text);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="space-y-4">
      <div className="relative">
        <textarea
          value={text}
          onChange={(e) => setText(e.target.value)}
          placeholder="Selected text will appear here. You can also type or paste text directly."
          className="w-full h-32 p-4 text-sm text-slate-700 bg-white/50 backdrop-blur-sm rounded-xl border border-slate-200 focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
        />
        <motion.button
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          onClick={copyToClipboard}
          className="absolute bottom-3 right-3 p-2 text-slate-500 hover:text-slate-700 rounded-lg"
        >
          {copied ? <FaCheck className="text-green-500" /> : <FaCopy />}
        </motion.button>
      </div>

      <div className="flex justify-center">
        <motion.button
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
          onClick={handleShare}
          className="flex items-center gap-2 px-6 py-2.5 bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-xl hover:from-blue-600 hover:to-blue-700 transition-all duration-200 shadow-md hover:shadow-lg"
        >
          <FaShare className="text-sm" />
          <span>Generate QR Code</span>
        </motion.button>
      </div>

      <AnimatePresence>
        {showQR && qrCodeUrl && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            className="flex flex-col items-center space-y-3"
          >
            <div className="p-4 bg-white rounded-xl shadow-md">
              <img src={qrCodeUrl} alt="QR Code" className="w-48 h-48" />
            </div>
            <p className="text-xs text-slate-500">Scan to copy text</p>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
} 