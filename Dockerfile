FROM ollama/ollama

# সার্ভার চালাবে
RUN ollama serves &

# মসেল ডাউনসোড সরো
RUN sleep 10 && ollama pull phi3:mini

EXPOSE 11434
CMD ["ollama", "Serve"]
