import { createServer } from 'node:http';
import { readFile, stat } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(fileURLToPath(import.meta.url));
const port = Number(process.env.PORT || 4173);
const types = { '.css':'text/css; charset=utf-8', '.glb':'model/gltf-binary', '.html':'text/html; charset=utf-8', '.js':'text/javascript; charset=utf-8', '.json':'application/json; charset=utf-8', '.png':'image/png' };

createServer(async (request, response) => {
  try {
    const pathname = decodeURIComponent((request.url || '/').split('?')[0]);
    let filePath = path.resolve(root, `.${pathname === '/' ? '/index.html' : pathname}`);
    if (filePath !== root && !filePath.startsWith(`${root}${path.sep}`)) throw new Error('forbidden');
    if ((await stat(filePath)).isDirectory()) filePath = path.join(filePath, 'index.html');
    const body = await readFile(filePath);
    response.writeHead(200, { 'Content-Type': types[path.extname(filePath)] || 'application/octet-stream', 'Cache-Control':'no-store' });
    response.end(body);
  } catch (error) {
    response.writeHead(error.message === 'forbidden' ? 403 : 404, { 'Content-Type':'text/plain; charset=utf-8' });
    response.end('Fichier introuvable');
  }
}).listen(port, '127.0.0.1', () => console.log(`NO LOOK disponible sur http://localhost:${port}`));
