import React, { useState, useEffect, useRef } from 'react';
import { motion } from 'framer-motion';
import { FaPlay, FaPause, FaRedo } from 'react-icons/fa';

const WORK_TIME = 25 * 60; // 25 minutes
const BREAK_TIME = 5 * 60; // 5 minutes

export default function PomodoroTimerTool() {
  const [timeLeft, setTimeLeft] = useState(WORK_TIME);
  const [isRunning, setIsRunning] = useState(false);
  const [isWorkTime, setIsWorkTime] = useState(true);
  const [completedPomodoros, setCompletedPomodoros] = useState(0);
  const timerRef = useRef(null);

  useEffect(() => {
    if (isRunning) {
      timerRef.current = setInterval(() => {
        setTimeLeft((prev) => {
          if (prev <= 1) {
            clearInterval(timerRef.current);
            handleTimerComplete();
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    }

    return () => clearInterval(timerRef.current);
  }, [isRunning]);

  const handleTimerComplete = () => {
    if (isWorkTime) {
      setCompletedPomodoros((prev) => prev + 1);
      setIsWorkTime(false);
      setTimeLeft(BREAK_TIME);
      showNotification('Break Time!', 'Time to take a short break.');
    } else {
      setIsWorkTime(true);
      setTimeLeft(WORK_TIME);
      showNotification('Work Time!', 'Time to get back to work.');
    }
    setIsRunning(false);
  };

  const showNotification = (title, message) => {
    if (Notification.permission === 'granted') {
      new Notification(title, { body: message });
    }
  };

  const toggleTimer = () => {
    if (!isRunning) {
      if (Notification.permission !== 'granted') {
        Notification.requestPermission();
      }
    }
    setIsRunning(!isRunning);
  };

  const resetTimer = () => {
    clearInterval(timerRef.current);
    setIsRunning(false);
    setTimeLeft(isWorkTime ? WORK_TIME : BREAK_TIME);
  };

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className="flex flex-col items-center space-y-6">
      <div className="relative">
        <div className="w-48 h-48 rounded-full bg-gradient-to-br from-slate-100 to-slate-200 shadow-lg flex items-center justify-center">
          <div className="absolute inset-0 rounded-full border-4 border-slate-300" />
          <div className="text-center">
            <p className="text-4xl font-bold text-slate-800">{formatTime(timeLeft)}</p>
            <p className="text-sm text-slate-500 mt-1">
              {isWorkTime ? 'Focus Time' : 'Break Time'}
            </p>
          </div>
        </div>
      </div>

      <div className="flex items-center gap-4">
        <motion.button
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          onClick={toggleTimer}
          className="p-3 bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-xl hover:from-blue-600 hover:to-blue-700 transition-all duration-200 shadow-md hover:shadow-lg"
        >
          {isRunning ? <FaPause className="w-5 h-5" /> : <FaPlay className="w-5 h-5" />}
        </motion.button>
        <motion.button
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          onClick={resetTimer}
          className="p-3 bg-slate-200 text-slate-600 rounded-xl hover:bg-slate-300 transition-colors"
        >
          <FaRedo className="w-5 h-5" />
        </motion.button>
      </div>

      <div className="flex items-center gap-2 text-slate-600">
        <div className="w-2 h-2 rounded-full bg-emerald-500" />
        <p className="text-sm">
          Completed Pomodoros: <span className="font-medium">{completedPomodoros}</span>
        </p>
      </div>
    </div>
  );
} 