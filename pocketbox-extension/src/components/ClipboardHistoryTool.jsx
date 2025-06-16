import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { FaCopy, FaTrash, FaHistory } from 'react-icons/fa';

export default function ClipboardHistoryTool() {
  const [history, setHistory] = useState([]);
  const [copied, setCopied] = useState(null);

  useEffect(() => {
    // Load history from storage
    chrome.storage.local.get(['clipboardHistory'], (result) => {
      if (result.clipboardHistory) {
        setHistory(result.clipboardHistory);
      }
    });

    // Listen for clipboard changes
    const handleClipboardChange = (e) => {
      const text = e.clipboardData.getData('text/plain');
      if (text.trim()) {
        const newItem = {
          id: Date.now(),
          text: text.trim(),
          timestamp: new Date().toISOString(),
        };
        const updatedHistory = [newItem, ...history].slice(0, 10);
        setHistory(updatedHistory);
        chrome.storage.local.set({ clipboardHistory: updatedHistory });
      }
    };

    document.addEventListener('copy', handleClipboardChange);
    return () => document.removeEventListener('copy', handleClipboardChange);
  }, [history]);

  const copyToClipboard = async (text) => {
    await navigator.clipboard.writeText(text);
    setCopied(text);
    setTimeout(() => setCopied(null), 2000);
  };

  const deleteItem = (id) => {
    const updatedHistory = history.filter((item) => item.id !== id);
    setHistory(updatedHistory);
    chrome.storage.local.set({ clipboardHistory: updatedHistory });
  };

  const formatTime = (timestamp) => {
    const date = new Date(timestamp);
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2 text-slate-600">
        <FaHistory className="w-4 h-4" />
        <h3 className="text-sm font-medium">Recent Copies</h3>
      </div>

      <div className="space-y-2 max-h-[400px] overflow-y-auto">
        <AnimatePresence>
          {history.map((item) => (
            <motion.div
              key={item.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, x: -20 }}
              className="group relative p-4 bg-white/80 backdrop-blur-sm rounded-xl border border-slate-200 shadow-sm"
            >
              <div className="flex items-start gap-3">
                <div className="flex-1">
                  <p className="text-sm text-slate-700">{item.text}</p>
                  <p className="text-xs text-slate-400 mt-1">
                    {formatTime(item.timestamp)}
                  </p>
                </div>
                <div className="flex gap-2">
                  <motion.button
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={() => copyToClipboard(item.text)}
                    className="p-1.5 text-slate-400 hover:text-blue-500 rounded-lg"
                  >
                    <FaCopy className="w-3 h-3" />
                  </motion.button>
                  <motion.button
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={() => deleteItem(item.id)}
                    className="p-1.5 text-slate-400 hover:text-red-500 rounded-lg"
                  >
                    <FaTrash className="w-3 h-3" />
                  </motion.button>
                </div>
              </div>
              {copied === item.text && (
                <motion.div
                  initial={{ opacity: 0, y: -10 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: 10 }}
                  className="absolute -top-2 right-2 px-2 py-1 bg-green-500 text-white text-xs rounded-full"
                >
                  Copied!
                </motion.div>
              )}
            </motion.div>
          ))}
        </AnimatePresence>
      </div>
    </div>
  );
} 