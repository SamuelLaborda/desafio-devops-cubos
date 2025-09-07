// Bootstrap: expõe as envs como variáveis globais esperadas pelo index.js
globalThis.user = process.env.user;
globalThis.pass = process.env.pass;
globalThis.host = process.env.host;
globalThis.db_port = process.env.db_port;
globalThis.port = process.env.port;

// Carrega o seu index.js original
import('./index.js');
