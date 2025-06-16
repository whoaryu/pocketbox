import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { FaPlus, FaTrash, FaSave } from 'react-icons/fa';

export default function StickyNotesTool() {
  const [notes, setNotes] = useState([]);
  const [newNote, setNewNote] = useState('');
  const [editingId, setEditingId] = useState(null);

  useEffect(() => {
    // Load notes from storage
    chrome.storage.local.get(['stickyNotes'], (result) => {
      if (result.stickyNotes) {
        setNotes(result.stickyNotes);
      }
    });
  }, []);

  const saveNotes = (updatedNotes) => {
    chrome.storage.local.set({ stickyNotes: updatedNotes });
  };

  const addNote = () => {
    if (newNote.trim()) {
      const updatedNotes = [
        ...notes,
        {
          id: Date.now(),
          text: newNote.trim(),
          createdAt: new Date().toISOString(),
        },
      ];
      setNotes(updatedNotes);
      saveNotes(updatedNotes);
      setNewNote('');
    }
  };

  const deleteNote = (id) => {
    const updatedNotes = notes.filter((note) => note.id !== id);
    setNotes(updatedNotes);
    saveNotes(updatedNotes);
  };

  const updateNote = (id, text) => {
    const updatedNotes = notes.map((note) =>
      note.id === id ? { ...note, text } : note
    );
    setNotes(updatedNotes);
    saveNotes(updatedNotes);
  };

  return (
    <div className="space-y-4">
      <div className="flex gap-2">
        <input
          type="text"
          value={newNote}
          onChange={(e) => setNewNote(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && addNote()}
          placeholder="Type a new note..."
          className="flex-1 px-4 py-2 text-sm bg-white/50 backdrop-blur-sm rounded-xl border border-slate-200 focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
        />
        <motion.button
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          onClick={addNote}
          className="p-2 bg-emerald-500 text-white rounded-xl hover:bg-emerald-600 transition-colors"
        >
          <FaPlus className="w-4 h-4" />
        </motion.button>
      </div>

      <div className="space-y-2 max-h-[400px] overflow-y-auto">
        <AnimatePresence>
          {notes.map((note) => (
            <motion.div
              key={note.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, x: -20 }}
              className="group relative p-4 bg-white/80 backdrop-blur-sm rounded-xl border border-slate-200 shadow-sm"
            >
              {editingId === note.id ? (
                <input
                  type="text"
                  value={note.text}
                  onChange={(e) => updateNote(note.id, e.target.value)}
                  onBlur={() => setEditingId(null)}
                  onKeyPress={(e) => e.key === 'Enter' && setEditingId(null)}
                  className="w-full px-2 py-1 text-sm bg-transparent focus:outline-none"
                  autoFocus
                />
              ) : (
                <p
                  className="text-sm text-slate-700 cursor-pointer"
                  onClick={() => setEditingId(note.id)}
                >
                  {note.text}
                </p>
              )}
              <motion.button
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.9 }}
                onClick={() => deleteNote(note.id)}
                className="absolute top-2 right-2 p-1 text-slate-400 hover:text-red-500 opacity-0 group-hover:opacity-100 transition-opacity"
              >
                <FaTrash className="w-3 h-3" />
              </motion.button>
            </motion.div>
          ))}
        </AnimatePresence>
      </div>
    </div>
  );
} 