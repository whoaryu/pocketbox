import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { FaDice, FaRedo, FaDiceD20, FaSpinner, FaCoins } from 'react-icons/fa';

const RANDOM_THINGS = {
  colors: ['Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange', 'Pink', 'Black', 'White', 'Gray'],
  numbers: Array.from({ length: 100 }, (_, i) => i + 1),
  letters: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''),
  countries: ['USA', 'Canada', 'UK', 'Australia', 'Japan', 'Germany', 'France', 'Italy', 'Spain', 'Brazil'],
  animals: ['Dog', 'Cat', 'Elephant', 'Lion', 'Tiger', 'Giraffe', 'Monkey', 'Panda', 'Kangaroo', 'Dolphin'],
  foods: ['Pizza', 'Burger', 'Sushi', 'Pasta', 'Salad', 'Ice Cream', 'Chocolate', 'Taco', 'Sandwich', 'Curry']
};

const DICE_TYPES = {
  d4: 4,
  d6: 6,
  d8: 8,
  d10: 10,
  d12: 12,
  d20: 20,
  d100: 100
};

const COIN_SIDES = {
  heads: 'Heads',
  tails: 'Tails'
};

export default function RandomThingTool() {
  const [selectedCategory, setSelectedCategory] = useState('colors');
  const [result, setResult] = useState('');
  const [history, setHistory] = useState([]);
  const [diceType, setDiceType] = useState('d6');
  const [customRange, setCustomRange] = useState({ min: 1, max: 100 });
  const [wheelItems, setWheelItems] = useState(['Item 1', 'Item 2', 'Item 3']);
  const [newWheelItem, setNewWheelItem] = useState('');
  const [isSpinning, setIsSpinning] = useState(false);
  const [selectedWheelItem, setSelectedWheelItem] = useState(null);
  const [coinSide, setCoinSide] = useState(null);
  const [isFlipping, setIsFlipping] = useState(false);
  const [flipCount, setFlipCount] = useState(0);

  const generateRandom = () => {
    if (selectedCategory === 'dice') {
      const max = DICE_TYPES[diceType];
      const roll = Math.floor(Math.random() * max) + 1;
      setResult(`Rolled ${diceType}: ${roll}`);
      setHistory(prev => [`${diceType}: ${roll}`, ...prev].slice(0, 5));
    } else if (selectedCategory === 'range') {
      const { min, max } = customRange;
      const num = Math.floor(Math.random() * (max - min + 1)) + min;
      setResult(`Random number between ${min}-${max}: ${num}`);
      setHistory(prev => [`${min}-${max}: ${num}`, ...prev].slice(0, 5));
    } else if (selectedCategory === 'wheel') {
      if (wheelItems.length > 0) {
        const randomIndex = Math.floor(Math.random() * wheelItems.length);
        setSelectedWheelItem(wheelItems[randomIndex]);
        setHistory(prev => [`Wheel: ${wheelItems[randomIndex]}`, ...prev].slice(0, 5));
      }
    } else if (selectedCategory === 'coin') {
      const side = Math.random() < 0.5 ? 'heads' : 'tails';
      setCoinSide(side);
      setFlipCount(prev => prev + 1);
      setHistory(prev => [`Coin: ${COIN_SIDES[side]}`, ...prev].slice(0, 5));
    } else {
      const items = RANDOM_THINGS[selectedCategory];
      const randomIndex = Math.floor(Math.random() * items.length);
      const newResult = items[randomIndex];
      setResult(newResult);
      setHistory(prev => [newResult, ...prev].slice(0, 5));
    }
  };

  const addWheelItem = () => {
    if (newWheelItem.trim() && !wheelItems.includes(newWheelItem.trim())) {
      setWheelItems(prev => [...prev, newWheelItem.trim()]);
      setNewWheelItem('');
    }
  };

  const removeWheelItem = (item) => {
    setWheelItems(prev => prev.filter(i => i !== item));
  };

  const spinWheel = () => {
    setIsSpinning(true);
    setTimeout(() => {
      generateRandom();
      setIsSpinning(false);
    }, 2000);
  };

  const flipCoin = () => {
    setIsFlipping(true);
    setTimeout(() => {
      generateRandom();
      setIsFlipping(false);
    }, 1000);
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-2">
        <FaDice className="w-4 h-4 text-slate-600" />
        <h3 className="text-sm font-medium text-slate-600">Random Generator</h3>
      </div>

      <div className="grid grid-cols-2 gap-2">
        {Object.keys(RANDOM_THINGS).map(category => (
          <motion.button
            key={category}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={() => setSelectedCategory(category)}
            className={`p-3 rounded-xl text-sm capitalize transition-all duration-200 ${
              selectedCategory === category
                ? 'bg-gradient-to-r from-emerald-500 to-emerald-600 text-white shadow-lg'
                : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
            }`}
          >
            {category}
          </motion.button>
        ))}
        <motion.button
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
          onClick={() => setSelectedCategory('dice')}
          className={`p-3 rounded-xl text-sm capitalize transition-all duration-200 ${
            selectedCategory === 'dice'
              ? 'bg-gradient-to-r from-blue-500 to-blue-600 text-white shadow-lg'
              : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
          }`}
        >
          Dice Roller
        </motion.button>
        <motion.button
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
          onClick={() => setSelectedCategory('range')}
          className={`p-3 rounded-xl text-sm capitalize transition-all duration-200 ${
            selectedCategory === 'range'
              ? 'bg-gradient-to-r from-purple-500 to-purple-600 text-white shadow-lg'
              : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
          }`}
        >
          Number Range
        </motion.button>
        <motion.button
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
          onClick={() => setSelectedCategory('wheel')}
          className={`p-3 rounded-xl text-sm capitalize transition-all duration-200 ${
            selectedCategory === 'wheel'
              ? 'bg-gradient-to-r from-pink-500 to-pink-600 text-white shadow-lg'
              : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
          }`}
        >
          Picker Wheel
        </motion.button>
        <motion.button
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
          onClick={() => setSelectedCategory('coin')}
          className={`p-3 rounded-xl text-sm capitalize transition-all duration-200 ${
            selectedCategory === 'coin'
              ? 'bg-gradient-to-r from-yellow-500 to-yellow-600 text-white shadow-lg'
              : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
          }`}
        >
          Coin Flip
        </motion.button>
      </div>

      <div className="bg-white/80 backdrop-blur-sm rounded-xl border border-slate-200 shadow-sm p-6">
        {selectedCategory === 'dice' && (
          <div className="space-y-4">
            <div className="flex flex-wrap gap-2">
              {Object.keys(DICE_TYPES).map(type => (
                <motion.button
                  key={type}
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setDiceType(type)}
                  className={`px-4 py-2 rounded-lg text-sm ${
                    diceType === type
                      ? 'bg-blue-500 text-white shadow-md'
                      : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                  }`}
                >
                  {type}
                </motion.button>
              ))}
            </div>
          </div>
        )}

        {selectedCategory === 'range' && (
          <div className="space-y-4">
            <div className="flex gap-4">
              <div>
                <label className="text-sm text-slate-600">Min</label>
                <input
                  type="number"
                  value={customRange.min}
                  onChange={(e) => setCustomRange(prev => ({ ...prev, min: parseInt(e.target.value) }))}
                  className="w-20 px-3 py-1.5 rounded-lg border border-slate-200 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
              <div>
                <label className="text-sm text-slate-600">Max</label>
                <input
                  type="number"
                  value={customRange.max}
                  onChange={(e) => setCustomRange(prev => ({ ...prev, max: parseInt(e.target.value) }))}
                  className="w-20 px-3 py-1.5 rounded-lg border border-slate-200 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>
          </div>
        )}

        {selectedCategory === 'wheel' && (
          <div className="space-y-4">
            <div className="flex gap-2">
              <input
                type="text"
                value={newWheelItem}
                onChange={(e) => setNewWheelItem(e.target.value)}
                placeholder="Add new item..."
                className="flex-1 px-3 py-1.5 rounded-lg border border-slate-200 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
              <motion.button
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                onClick={addWheelItem}
                className="px-3 py-1.5 bg-blue-500 text-white rounded-lg shadow-md"
              >
                Add
              </motion.button>
            </div>
            <div className="space-y-2">
              {wheelItems.map((item, index) => (
                <div key={index} className="flex items-center justify-between p-2 bg-slate-100 rounded-lg">
                  <span className="text-sm text-slate-600">{item}</span>
                  <motion.button
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={() => removeWheelItem(item)}
                    className="p-1 text-slate-400 hover:text-red-500"
                  >
                    ×
                  </motion.button>
                </div>
              ))}
            </div>
          </div>
        )}

        {selectedCategory === 'coin' && (
          <div className="flex flex-col items-center justify-center space-y-4">
            <motion.div
              className="relative w-24 h-24"
              animate={{
                rotateY: isFlipping ? [0, 1800] : 0,
                scale: isFlipping ? [1, 1.2, 1] : 1
              }}
              transition={{
                duration: 1,
                ease: "easeInOut"
              }}
            >
              <div className={`absolute inset-0 rounded-full ${
                coinSide === 'heads' ? 'bg-yellow-400' : 'bg-yellow-500'
              } shadow-lg flex items-center justify-center`}>
                <span className="text-white font-bold text-lg">
                  {coinSide ? COIN_SIDES[coinSide].charAt(0) : '?'}
                </span>
              </div>
            </motion.div>
            <p className="text-sm text-slate-600">
              Flips: {flipCount}
            </p>
          </div>
        )}

        <div className="flex items-center justify-center gap-4 mt-6">
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={selectedCategory === 'wheel' ? spinWheel : selectedCategory === 'coin' ? flipCoin : generateRandom}
            className="p-4 bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-xl hover:from-blue-600 hover:to-blue-700 transition-all duration-200 shadow-lg hover:shadow-xl"
          >
            {selectedCategory === 'wheel' ? (
              <FaSpinner className={`w-6 h-6 ${isSpinning ? 'animate-spin' : ''}`} />
            ) : selectedCategory === 'coin' ? (
              <FaCoins className="w-6 h-6" />
            ) : (
              <FaDice className="w-6 h-6" />
            )}
          </motion.button>
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => {
              setResult('');
              setHistory([]);
              if (selectedCategory === 'wheel') {
                setSelectedWheelItem(null);
              } else if (selectedCategory === 'coin') {
                setCoinSide(null);
                setFlipCount(0);
              }
            }}
            className="p-4 bg-slate-200 text-slate-600 rounded-xl hover:bg-slate-300 transition-colors shadow-lg hover:shadow-xl"
          >
            <FaRedo className="w-6 h-6" />
          </motion.button>
        </div>

        <AnimatePresence mode="wait">
          {(result || selectedWheelItem || coinSide) && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -20 }}
              className="mt-6 p-4 bg-gradient-to-r from-slate-100 to-slate-200 rounded-xl shadow-inner text-center"
            >
              <p className="text-2xl font-bold text-slate-800">
                {selectedCategory === 'wheel' ? selectedWheelItem :
                 selectedCategory === 'coin' ? COIN_SIDES[coinSide] :
                 result}
              </p>
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {history.length > 0 && (
        <div className="space-y-2">
          <p className="text-sm text-slate-600">Recent Results:</p>
          <div className="space-y-1">
            {history.map((item, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                className="p-2 bg-white/80 backdrop-blur-sm rounded-xl border border-slate-200 shadow-sm text-sm text-slate-600"
              >
                {item}
              </motion.div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
} 