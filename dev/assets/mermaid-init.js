var script = document.createElement('script');
script.type = 'module';
script.innerHTML = `
import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
mermaid.initialize({ startOnLoad: true });
setTimeout(() => mermaid.run(), 500);
`;
document.head.appendChild(script);
