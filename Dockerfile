FROM ollama/ollama
RUN ollama pull phi3:mini
EXPOSE 11434
CMD ["ollama", "serve"]
