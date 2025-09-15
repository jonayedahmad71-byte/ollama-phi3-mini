#!/bin/sh

# Ollama সার্ভার ব্যাকগ্রাউন্ডে চালু করুন
ollama serve &

# সার্ভার স্টার্ট হওয়ার জন্য অপেক্ষা করুন
echo "Waiting for Ollama server to start..."
sleep 5

# মডেল ডাউনলোড করুন
echo "Pulling model: phi3:mini"
ollama pull phi3:mini

echo "Model downloaded. Starting Ollama server in foreground..."

# সার্ভার ফরগ্রাউন্ডে চালাও
exec ollama serve
