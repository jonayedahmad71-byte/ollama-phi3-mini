FROM ollama/ollama
# মডেল ডাউনলোড সরতে পারে না → সার্ভার স্সার্স করো
RUN ollama serve &   # সার্ভার স্সার্স করো
# মডেল ডাউনলোড করো
RUN sleep 10 && ollama pull phi3:mini
EXPOSE 11434
CMD ["ollama", "serve"]
