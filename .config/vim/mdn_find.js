const bcd = require('@mdn/browser-compat-data');

const prefix = process.argv[2]?.toLowerCase();
if (!prefix) process.exit(0);

const entries = new Set();

function collectKeys(obj) {
  for (const key in obj) {
    if (key === '__compat') continue;
    entries.add(key);
    collectKeys(obj[key]);
  }
}

collectKeys(bcd.api);

const matches = [...entries].filter((k) => k.toLowerCase().startsWith(prefix));
console.log(matches.join('\n'));
