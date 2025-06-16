import React, { useEffect, useRef, useState } from 'react';
import QRCode from 'qrcode';
import { FaDownload, FaCopy, FaLink } from 'react-icons/fa';
import { motion } from 'framer-motion';

function QRCodeTool() {
  const [url, setUrl] = useState('');
  const [inputValue, setInputValue] = useState('');
  const [isCopied, setIsCopied] = useState(false);
  const canvasRef = useRef(null);

  useEffect(() => {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      if (tabs[0]?.url) {
        setUrl(tabs[0].url);
        setInputValue(tabs[0].url);
      }
    });
  }, []);

  useEffect(() => {
    if (url && canvasRef.current) {
      QRCode.toCanvas(canvasRef.current, url, {
        width: 200,
        margin: 2,
        color: {
          dark: '#1E40AF',
          light: '#ffffff'
        }
      });
    }
  }, [url]);

  const handleInputChange = (e) => {
    setInputValue(e.target.value);
    setUrl(e.target.value);
  };

  const downloadQR = () => {
    const canvas = canvasRef.current;
    if (canvas) {
      const pngUrl = canvas
        .toDataURL('image/png')
        .replace('image/png', 'image/octet-stream');
      const link = document.createElement('a');
      link.href = pngUrl;
      link.download = 'qrcode.png';
      link.click();
    }
  };

  const copyToClipboard = () => {
    navigator.clipboard.writeText(url);
    setIsCopied(true);
    setTimeout(() => setIsCopied(false), 2000);
  };

  return (
    <div className="flex flex-col items-center space-y-6 h-full">
      <div className="w-full">
        <div className="relative">
          <input
            type="text"
            value={inputValue}
            onChange={handleInputChange}
            placeholder="Enter URL or text"
            className="w-full px-4 py-2 pr-10 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
          <FaLink className="absolute right-3 top-3 text-gray-400" />
        </div>
      </div>

      <div className="bg-white p-4 rounded-xl shadow-lg">
        <canvas ref={canvasRef} className="rounded-lg"></canvas>
      </div>

      <div className="flex gap-3 w-full">
        <motion.button
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
          onClick={downloadQR}
          className="flex-1 flex items-center justify-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
        >
          <FaDownload />
          Download
        </motion.button>
        <motion.button
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
          onClick={copyToClipboard}
          className="flex-1 flex items-center justify-center gap-2 px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors"
        >
          <FaCopy />
          {isCopied ? 'Copied!' : 'Copy URL'}
        </motion.button>
      </div>
    </div>
  );
}

export default QRCodeTool;
