const express = require('express');
const cors = require('cors');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Phi-3 Mini সার্ভারের URL (Render-এ ডিপ্লয় করা)
const PHI3_URL = 'http://ollama-phi3-mini.onrender.com'; // ⚠️ তোমার নিজের URL দাও

app.post('/api/chat', async (req, res) => {
    try {
        const { messages, stream = false } = req.body;

        if (!messages || !Array.isArray(messages)) {
            return res.status(400).json({ error: 'Messages array is required' });
        }

        const requestBody = {
            model: 'phi3:mini',
            messages: messages,
            stream: stream
        };

        if (stream) {
            res.setHeader('Content-Type', 'text/event-stream');
            res.setHeader('Cache-Control', 'no-cache');
            res.setHeader('Connection', 'keep-alive');

            const proxy = createProxyMiddleware({
                target: PHI3_URL,
                changeOrigin: true,
                pathRewrite: { '^/api/chat': '/v1/chat/completions' },
                onProxyReq: (proxyReq, req, res) => {
                    proxyReq.setHeader('Content-Type', 'application/json');
                },
                selfHandleResponse: false
            });

            return proxy(req, res);
        } else {
            const response = await fetch(`${PHI3_URL}/api/generate`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(requestBody)
            });

            const data = await response.json();
            res.json(data);
        }
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: 'Failed to process request' });
    }
});

app.use(express.static('public'));

app.get('*', (req, res) => {
    res.sendFile(__dirname + '/public/index.html');
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
