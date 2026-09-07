document.addEventListener("DOMContentLoaded", function() {
    var script = document.createElement('script');
    script.type = 'module';
    script.innerHTML = `
        import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
        mermaid.initialize({ startOnLoad: false, theme: 'neutral' });
        try {
            await mermaid.run({ querySelector: '.mermaid' });
        } catch (e) {
            console.error('Mermaid render error:', e);
        }
    `;
    document.body.appendChild(script);
});
