FROM ollama/ollama:latest

# প্রয়োজনীয় টুলস ইন্সটল (যদি কী তৈরির জন্য লাগে)
RUN apk add --no-cache openssh-client && \
    mkdir -p /root/.ollama && \
    ssh-keygen -t ed25519 -f /root/.ollama/id_ed25519 -N "" || true

# মডেল ডাউনলোড — এটি এখন করা যাবে না, কারণ সার্ভার চালু নেই
# তাই আমরা একটি স্ক্রিপ্ট ব্যবহার করব যা সার্ভার চালু হওয়ার পর মডেল ডাউনলোড করবে

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 11434

# এন্ট্রিপয়েন্ট স্ক্রিপ্ট চালাবে — যেটি সার্ভার চালু করে মডেল ডাউনলোড করবে
ENTRYPOINT ["/entrypoint.sh"]
