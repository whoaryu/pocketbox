import React, { useState } from 'react'
import QRCodeTool from '../components/QRCodeTool'
import ColorPickerTool from '../components/ColorPickerTool'
import TextSnippetTool from '../components/TextSnippetTool'
import StickyNotesTool from '../components/StickyNotesTool'
import ClipboardHistoryTool from '../components/ClipboardHistoryTool'
import PomodoroTimerTool from '../components/PomodoroTimerTool'
import RandomThingTool from '../components/RandomThingTool'
import { FaQrcode, FaEyeDropper, FaBox, FaAlignLeft, FaStickyNote, FaClipboard, FaClock, FaDice, FaCog, FaSearch } from 'react-icons/fa'
import { motion, AnimatePresence } from 'framer-motion'

const tools = {
  SNIPPET: {
    label: 'Text Snippets',
    icon: <FaAlignLeft className="w-4 h-4" />,
    component: <TextSnippetTool />,
    description: 'Share text via QR code',
    color: 'from-emerald-500 to-emerald-600'
  },
  QR: {
    label: 'QR Generator',
    icon: <FaQrcode className="w-4 h-4" />,
    component: <QRCodeTool />,
    description: 'Generate QR codes from URLs',
    color: 'from-blue-500 to-blue-600'
  },
  COLOR: {
    label: 'Color Picker',
    icon: <FaEyeDropper className="w-4 h-4" />,
    component: <ColorPickerTool />,
    description: 'Pick colors from webpage',
    color: 'from-purple-500 to-purple-600'
  },
  NOTES: {
    label: 'Sticky Notes',
    icon: <FaStickyNote className="w-4 h-4" />,
    component: <StickyNotesTool />,
    description: 'Quick notes and reminders',
    color: 'from-yellow-500 to-yellow-600'
  },
  CLIPBOARD: {
    label: 'Clipboard',
    icon: <FaClipboard className="w-4 h-4" />,
    component: <ClipboardHistoryTool />,
    description: 'Clipboard history manager',
    color: 'from-orange-500 to-orange-600'
  },
  POMODORO: {
    label: 'Pomodoro',
    icon: <FaClock className="w-4 h-4" />,
    component: <PomodoroTimerTool />,
    description: 'Focus timer with breaks',
    color: 'from-red-500 to-red-600'
  },
  RANDOM: {
    label: 'Random',
    icon: <FaDice className="w-4 h-4" />,
    component: <RandomThingTool />,
    description: 'Random generator tool',
    color: 'from-pink-500 to-pink-600'
  }
}

export default function Popup() {
  const [activeTool, setActiveTool] = useState('SNIPPET')
  const [isSettingsOpen, setIsSettingsOpen] = useState(false)
  const [searchQuery, setSearchQuery] = useState('')

  const filteredTools = Object.entries(tools).filter(([key, tool]) => 
    tool.label.toLowerCase().includes(searchQuery.toLowerCase()) ||
    tool.description.toLowerCase().includes(searchQuery.toLowerCase())
  )

  return (
    <div className="w-[400px] h-[600px] bg-gradient-to-br from-slate-50 to-slate-100 backdrop-blur-xl rounded-2xl shadow-2xl overflow-hidden font-sans">
      {/* Header */}
      <div className="bg-gradient-to-r from-slate-800 to-slate-900 px-4 py-3 relative">
        <div className="flex items-center gap-2 text-white/90">
          <FaBox className="w-5 h-5" />
          <h1 className="text-lg font-medium tracking-tight">PocketBox</h1>
        </div>
        <motion.button
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          onClick={() => setIsSettingsOpen(!isSettingsOpen)}
          className="absolute right-3 top-1/2 -translate-y-1/2 p-2 text-white/70 hover:text-white transition-colors"
        >
          <FaCog className="w-4 h-4" />
        </motion.button>
      </div>

      {/* Search Bar */}
      <div className="px-4 py-3 border-b border-slate-200">
        <div className="relative">
          <FaSearch className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 w-4 h-4" />
          <input
            type="text"
            placeholder="Search tools..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-9 pr-4 py-2 bg-white/50 backdrop-blur-sm rounded-lg border border-slate-200 focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
          />
        </div>
      </div>

      <div className="flex h-[calc(100%-120px)]">
        {/* Tools Grid */}
        <div className="flex-1 p-4 overflow-y-auto">
          <div className="grid grid-cols-2 gap-3">
            {filteredTools.map(([key, { label, icon, description, color }]) => (
              <motion.button
                key={key}
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                onClick={() => setActiveTool(key)}
                className={`p-3 rounded-xl transition-all duration-200 ${
                  activeTool === key
                    ? 'bg-gradient-to-r ' + color + ' text-white shadow-lg'
                    : 'bg-white/80 backdrop-blur-sm border border-slate-200 hover:border-slate-300'
                }`}
              >
                <div className="flex items-center gap-2 mb-1">
                  <span className={`p-2 rounded-lg ${
                    activeTool === key ? 'bg-white/20' : 'bg-slate-100'
                  }`}>
                    {icon}
                  </span>
                  <span className="text-sm font-medium">{label}</span>
                </div>
                <p className="text-xs text-left text-slate-500">
                  {description}
                </p>
              </motion.button>
            ))}
          </div>
        </div>

        {/* Active Tool */}
        <AnimatePresence mode="wait">
          {activeTool && (
            <motion.div
              initial={{ opacity: 0, x: '100%' }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: '100%' }}
              transition={{ duration: 0.2 }}
              className="absolute inset-0 bg-white/90 backdrop-blur-sm p-4"
            >
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <motion.button
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={() => setActiveTool(null)}
                    className="p-2 text-slate-400 hover:text-slate-600"
                  >
                    ←
                  </motion.button>
                  <h2 className="text-lg font-medium text-slate-800">
                    {tools[activeTool].label}
                  </h2>
                </div>
              </div>
              <div className="h-[calc(100%-48px)] overflow-y-auto">
                {tools[activeTool].component}
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* Settings Panel */}
      <AnimatePresence>
        {isSettingsOpen && (
          <motion.div
            initial={{ opacity: 0, x: '100%' }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: '100%' }}
            transition={{ duration: 0.2 }}
            className="absolute inset-0 bg-white/90 backdrop-blur-sm p-4"
          >
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-medium text-slate-800">Settings</h2>
              <motion.button
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.9 }}
                onClick={() => setIsSettingsOpen(false)}
                className="p-2 text-slate-400 hover:text-slate-600"
              >
                ×
              </motion.button>
            </div>
            <div className="space-y-3">
              <div className="p-3 bg-slate-50 rounded-xl border border-slate-200">
                <h3 className="text-sm font-medium text-slate-600 mb-2">Theme</h3>
                <div className="flex gap-2">
                  <button className="w-8 h-8 rounded-full bg-slate-800 border-2 border-slate-800"></button>
                  <button className="w-8 h-8 rounded-full bg-slate-50 border-2 border-slate-200"></button>
                  <button className="w-8 h-8 rounded-full bg-emerald-500 border-2 border-emerald-500"></button>
                </div>
              </div>
              <div className="p-3 bg-slate-50 rounded-xl border border-slate-200">
                <h3 className="text-sm font-medium text-slate-600 mb-2">Notifications</h3>
                <div className="flex items-center justify-between">
                  <span className="text-sm text-slate-600">Enable notifications</span>
                  <label className="relative inline-flex items-center cursor-pointer">
                    <input type="checkbox" className="sr-only peer" />
                    <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                  </label>
                </div>
              </div>
              <div className="p-3 bg-slate-50 rounded-xl border border-slate-200">
                <h3 className="text-sm font-medium text-slate-600 mb-2">About</h3>
                <p className="text-sm text-slate-600">
                  PocketBox v1.0.0
                  <br />
                  A collection of useful tools in your browser
                </p>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
