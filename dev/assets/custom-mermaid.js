document.addEventListener("DOMContentLoaded", function() {
    // Hide define.amd from require.js so that bundled UMD modules (like dayjs in mermaid) 
    // don't try to register as AMD modules and break the ESM import.
    var old_define = window.define;
    if (window.define && window.define.amd) {
        window.define = undefined;
    }

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
    
    // We must restore define after the script is loaded.
    // However, since it's a module script, it executes asynchronously.
    // So we shouldn't just restore it immediately.
    // But actually, require.js might break if define is gone for too long.
    // An alternative: the code inside the module script executes, so we can restore it inside.
    script.innerHTML += `
        if (window._old_define) {
            window.define = window._old_define;
        }
    `;
    
    // Let's pass old_define to window so the module can restore it
    if (old_define) {
        window._old_define = old_define;
    }

    document.body.appendChild(script);
});
