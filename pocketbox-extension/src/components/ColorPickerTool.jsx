import React, { useState } from 'react'
import { FaEyeDropper, FaCopy, FaPalette } from 'react-icons/fa'
import { motion } from 'framer-motion'

function hexToRgb(hex) {
  const bigint = parseInt(hex.replace('#', ''), 16)
  const r = (bigint >> 16) & 255
  const g = (bigint >> 8) & 255
  const b = bigint & 255
  return `rgb(${r}, ${g}, ${b})`
}

function hexToHsl(hex) {
  let r = 0, g = 0, b = 0
  if (hex.length === 7) {
    r = parseInt(hex.slice(1, 3), 16) / 255
    g = parseInt(hex.slice(3, 5), 16) / 255
    b = parseInt(hex.slice(5, 7), 16) / 255
  }

  const max = Math.max(r, g, b)
  const min = Math.min(r, g, b)
  let h, s, l = (max + min) / 2

  if (max === min) {
    h = s = 0
  } else {
    const d = max - min
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
    switch (max) {
      case r: h = (g - b) / d + (g < b ? 6 : 0); break
      case g: h = (b - r) / d + 2; break
      case b: h = (r - g) / d + 4; break
    }
    h /= 6
  }

  return `hsl(${Math.round(h * 360)}, ${Math.round(s * 100)}%, ${Math.round(l * 100)}%)`
}

export default function ColorPickerTool() {
  const [color, setColor] = useState(null)
  const [isCopied, setIsCopied] = useState(false)
  const [copyType, setCopyType] = useState('')

  const pickColor = async () => {
    if (!window.EyeDropper) {
      alert('Your browser does not support EyeDropper API.')
      return
    }

    try {
      const eyeDropper = new EyeDropper()
      const result = await eyeDropper.open()
      setColor(result.sRGBHex)
    } catch (err) {
      console.error('Error picking color:', err)
    }
  }

  const copyToClipboard = (value, type) => {
    navigator.clipboard.writeText(value)
    setIsCopied(true)
    setCopyType(type)
    setTimeout(() => {
      setIsCopied(false)
      setCopyType('')
    }, 2000)
  }

  return (
    <div className="flex flex-col items-center space-y-6 h-full">
      <motion.button
        whileHover={{ scale: 1.02 }}
        whileTap={{ scale: 0.98 }}
        onClick={pickColor}
        className="flex items-center gap-2 px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
      >
        <FaEyeDropper />
        Pick Color
      </motion.button>

      {color && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="w-full space-y-4"
        >
          <div className="flex items-center gap-4">
            <div
              className="w-16 h-16 rounded-lg shadow-lg"
              style={{ backgroundColor: color }}
            />
            <div className="flex-1">
              <h3 className="font-medium text-gray-700">Selected Color</h3>
              <p className="text-sm text-gray-500">Click to copy</p>
            </div>
          </div>

          <div className="grid grid-cols-1 gap-2">
            <motion.div
              whileHover={{ scale: 1.01 }}
              whileTap={{ scale: 0.99 }}
              onClick={() => copyToClipboard(color, 'hex')}
              className="flex items-center justify-between p-3 bg-white rounded-lg shadow-sm cursor-pointer hover:bg-gray-50"
            >
              <div className="flex items-center gap-2">
                <FaPalette className="text-gray-400" />
                <span className="font-mono">{color}</span>
              </div>
              <FaCopy className="text-gray-400" />
            </motion.div>

            <motion.div
              whileHover={{ scale: 1.01 }}
              whileTap={{ scale: 0.99 }}
              onClick={() => copyToClipboard(hexToRgb(color), 'rgb')}
              className="flex items-center justify-between p-3 bg-white rounded-lg shadow-sm cursor-pointer hover:bg-gray-50"
            >
              <div className="flex items-center gap-2">
                <FaPalette className="text-gray-400" />
                <span className="font-mono">{hexToRgb(color)}</span>
              </div>
              <FaCopy className="text-gray-400" />
            </motion.div>

            <motion.div
              whileHover={{ scale: 1.01 }}
              whileTap={{ scale: 0.99 }}
              onClick={() => copyToClipboard(hexToHsl(color), 'hsl')}
              className="flex items-center justify-between p-3 bg-white rounded-lg shadow-sm cursor-pointer hover:bg-gray-50"
            >
              <div className="flex items-center gap-2">
                <FaPalette className="text-gray-400" />
                <span className="font-mono">{hexToHsl(color)}</span>
              </div>
              <FaCopy className="text-gray-400" />
            </motion.div>
          </div>

          {isCopied && (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              className="text-center text-sm text-green-600"
            >
              {copyType.toUpperCase()} color copied to clipboard!
            </motion.div>
          )}
        </motion.div>
      )}
    </div>
  )
}
